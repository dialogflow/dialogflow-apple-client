//
//  AIQueueAudioRecorder.m
//  PartialDemo
//
//  Created by Kuragin Dmitriy on 27/01/16.
//  Copyright © 2016 Kuragin Dmitriy. All rights reserved.
//

#import "AIQueueAudioRecorder.h"

#import "AISoundRecorderConstants.h"

#import <AudioToolbox/AudioToolbox.h>

@interface AIQueueAudioRecorder ()

@property(nonatomic, copy) NSError *error;

@property(nonatomic, copy, readonly) NSRecursiveLock *lock;
@property(nonatomic, assign) AudioQueueRef audioQueue;
@property(nonatomic, strong) dispatch_source_t timer;

@property(nonatomic, assign) BOOL isRunning;

@end

static const UInt32 kNumberRecordBuffers = 3;
static const UInt32 kBufferByteSize = 1024;

static NSError *errorFromStatusWithMessage(OSStatus status, NSString *message) {
    NSDictionary *userInfo = @{
                               NSLocalizedDescriptionKey: message
                               };
    
    NSError *error = [[NSError alloc] initWithDomain:NSOSStatusErrorDomain
                                                code:status
                                            userInfo:userInfo];
    
    return error;
}

static void MyAudioQueueInputCallback(
                                    void * __nullable               inUserData,
                                    AudioQueueRef                   inAQ,
                                    AudioQueueBufferRef             inBuffer,
                                    const AudioTimeStamp *          inStartTime,
                                    UInt32                          inNumberPacketDescriptions,
                                    const AudioStreamPacketDescription * __nullable inPacketDescs
                                    )
{
    if (inUserData) {
        AIQueueAudioRecorder *recorder = (__bridge AIQueueAudioRecorder *)(inUserData);
        
        void * const data = inBuffer->mAudioData;
        UInt32 size = inBuffer->mAudioDataByteSize;
        
        SInt16 *buffer = (SInt16 *)malloc(size);
        memcpy(buffer, data, size);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [recorder.lock lock];
            
            if (recorder.isRunning && [recorder.delegate respondsToSelector:@selector(audioRecorder:dataReceived:andSamplesCount:)]) {
                [recorder.delegate audioRecorder:recorder
                                    dataReceived:buffer
                                 andSamplesCount:(UInt32)(size / sizeof(SInt16))];
            }
            
            [recorder.lock unlock];
            
            free(buffer);
        });
    }
    
    AudioQueueEnqueueBuffer(inAQ, inBuffer, 0, nil);
}

@implementation AIQueueAudioRecorder {
    BOOL _isRunning;
}

@dynamic isRunning;

- (void)setIsRunning:(BOOL)isRunning
{
    [_lock lock];
    
    _isRunning = isRunning;
    
    [_lock unlock];
}

- (BOOL)isRunning
{
    BOOL __isRunning = NO;
    
    [_lock lock];
    
    __isRunning = _isRunning;
    
    [_lock unlock];
    
    return __isRunning;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _lock = [[NSRecursiveLock alloc] init];
        
        AudioStreamBasicDescription format = {
            .mSampleRate = kSampleRate,
            .mFormatID = kFormatID,
            .mBytesPerPacket = kBytesPerPacket,
            .mFramesPerPacket = kFramesPerPacket,
            .mBytesPerFrame = kBytesPerFrame,
            .mChannelsPerFrame = kChannelsPerFrame,
            .mBitsPerChannel = kBitsPerChannel,
            .mFormatFlags = kFormatFlags
        };
        
        AudioQueueRef audioQueue = NULL;
        
        OSStatus createQueueStatus =
        AudioQueueNewInput(&format,
                           MyAudioQueueInputCallback,
                           (__bridge void * _Nullable)(self),
                           NULL,
                           NULL,
                           0,
                           &audioQueue);
        
        self.audioQueue = audioQueue;
        
        if (createQueueStatus != noErr) {
            self.error = errorFromStatusWithMessage(createQueueStatus, @"Cannot create audio queue.");
        } else {
            NSError *allocateBufferError = nil;
            NSError *enqueueBufferError = nil;
            
            for (UInt32 i = 0; (i < kNumberRecordBuffers) && !allocateBufferError && !enqueueBufferError; ++i) {
                AudioQueueBufferRef buffer = NULL;
                OSStatus allocateBufferStatus = AudioQueueAllocateBuffer(audioQueue, kBufferByteSize, &buffer);
                
                if (allocateBufferStatus != noErr) {
                    allocateBufferError = errorFromStatusWithMessage(allocateBufferStatus, @"Cannot allocate queue buffer.");
                    break;
                }
                
                OSStatus enqueueBufferStatus = AudioQueueEnqueueBuffer(audioQueue, buffer, 0, NULL);
                
                if (enqueueBufferStatus != noErr) {
                    enqueueBufferError = errorFromStatusWithMessage(enqueueBufferStatus, @"Cannot enqueue queue buffer.");
                    break;
                }
            };
            
            if (allocateBufferError || enqueueBufferError) {
                self.error = allocateBufferError ? allocateBufferError : enqueueBufferError;
            } else {
                UInt32 value = 1;
                
                OSStatus setLevelMeterenableStatus = AudioQueueSetProperty(audioQueue, kAudioQueueProperty_EnableLevelMetering, &value, sizeof(UInt32));
                
                if (setLevelMeterenableStatus != noErr) {
                    self.error = errorFromStatusWithMessage(setLevelMeterenableStatus, @"Cannot set property kAudioQueueProperty_EnableLevelMetering.");
                } else {
                    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
                    
                    dispatch_source_set_timer(
                                              timer,
                                              DISPATCH_TIME_NOW,
                                              1.0 / 30.0 * NSEC_PER_SEC,
                                              1.0 / 30.0 * NSEC_PER_SEC
                                              );
                    
                    __weak typeof(self) selfWeak = self;
                    
                    dispatch_source_set_event_handler(timer, ^{
                        __strong typeof(selfWeak) selfStrong = selfWeak;
                        
                        if (selfStrong && self.isRunning) {
                            UInt32 channels = format.mChannelsPerFrame;
                            UInt32 dataSize = (UInt32)(sizeof(AudioQueueLevelMeterState) * channels);
                            
                            AudioQueueLevelMeterState levels[channels];
                            
                            OSStatus getAudioLevelStatus = AudioQueueGetProperty(audioQueue, kAudioQueueProperty_CurrentLevelMeter, &levels, &dataSize);
                            
                            [selfStrong.lock lock];
                            
                            if (getAudioLevelStatus != noErr) {
                                NSError *error = errorFromStatusWithMessage(getAudioLevelStatus, @"Cannot get property kAudioQueueProperty_CurrentLevelMeter.");
                                [selfStrong stopWithError:error];
                            } else {
                                [selfStrong.delegate audioRecorder:selfStrong audioLevelChanged:levels[0].mAveragePower];
                            }
                            
                            [selfStrong.lock unlock];
                        }
                    });
                    
                    self.timer = timer;
                }
            }
        }
    }
    
    return self;
}

- (void)stopWithError:(NSError *)error {
    [_lock lock];
    
    self.isRunning = NO;
    
    dispatch_source_cancel(_timer);
    AudioQueueStop(_audioQueue, true);
    
    [_lock unlock];
    
    if ([_delegate respondsToSelector:@selector(audioRecorder:didFailWithError:)]) {
        [_delegate audioRecorder:self didFailWithError:self.error];
    }
}

- (void)start {
    [_lock lock];
    
    if (self.error) {
        [self stopWithError:self.error];
    } else {
        OSStatus audioQueueStartStatus = AudioQueueStart(_audioQueue, NULL);
        if (audioQueueStartStatus != noErr) {
            NSError *error = errorFromStatusWithMessage(audioQueueStartStatus, @"Cannot start audio queue.");
            [self stopWithError:error];
        } else {
            dispatch_resume(_timer);
            self.isRunning = YES;
        }
    }
    
    [_lock unlock];
}

- (BOOL)isRecording
{
    return self.isRunning;
}

- (void)stop
{
    self.isRunning = NO;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        dispatch_source_cancel(_timer);
        
        OSStatus audioQueueStopStatus = AudioQueueStop(_audioQueue, true);
        
        if (audioQueueStopStatus != noErr) {
            NSError *error = errorFromStatusWithMessage(audioQueueStopStatus, @"Cannot stop audio queue.");
            [self stopWithError:error];
        }
    });
}

- (void)dealloc
{
    
}

@end
