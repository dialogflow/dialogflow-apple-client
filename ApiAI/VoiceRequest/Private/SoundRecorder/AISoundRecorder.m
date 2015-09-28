/***********************************************************************************************************************
 *
 * API.AI iOS SDK - client-side libraries for API.AI
 * ==========================================
 *
 * Copyright (C) 2015 by Speaktoit, Inc. (https://www.speaktoit.com)
 * https://www.api.ai
 *
 ***********************************************************************************************************************
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with
 * the License. You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on
 * an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the
 * specific language governing permissions and limitations under the License.
 *
 ***********************************************************************************************************************/

#import "AISoundRecorder.h"
#import "AISoundRecorderConstants.h"
#import "AIAudioUtils.h"
#import "AIMeterTable.h"

#define kBufferSize 32768

@import AudioUnit;
@import AudioToolbox;
@import AVFoundation;

@interface AISoundRecorder()

@property(nonatomic, assign) double currentSampleRate;

@property(nonatomic, assign) AudioUnit remoteIOUnit;
@property(nonatomic, assign) AURenderCallbackStruct inputProcess;
@property(nonatomic, assign) AudioStreamBasicDescription outputFormat;

@property(nonatomic, strong) AIMeterTable *meterTable;

- (CGFloat)calculateLevel:(AudioBufferList *)ioData andNumberFrames:(UInt32)numberofFrames;

@end

static OSStatus PerformThru(
                            void                        *inRefCon,
                            AudioUnitRenderActionFlags  *ioActionFlags,
                            const AudioTimeStamp        *inTimeStamp,
                            UInt32                      inBusNumber,
                            UInt32                      inNumberFrames,
                            AudioBufferList             *ioData)
{
    __strong AISoundRecorder *THIS = (__bridge AISoundRecorder*) inRefCon;
    
    AudioBuffer buffer;
    
    buffer.mNumberChannels = 1;
    buffer.mDataByteSize = inNumberFrames * sizeof(SInt16);
    buffer.mData = malloc( inNumberFrames * sizeof(SInt16));

    AudioBufferList *bufferList = (AudioBufferList *)malloc(sizeof(AudioBufferList));
    bufferList->mNumberBuffers = 1;
    bufferList->mBuffers[0] = buffer;
    
    OPCA(AudioUnitRender(THIS.remoteIOUnit,
                     ioActionFlags,
                     inTimeStamp,
                     inBusNumber,
                     inNumberFrames,
                     bufferList));
    
    float decibels = [THIS calculateLevel:bufferList andNumberFrames:inNumberFrames];
    
    float level = [THIS.meterTable valueAt:decibels];
    THIS.currentPower = level;
    
    if ([NSThread isMainThread]) {
        [THIS.delegate soundRecorder:THIS receivedData:bufferList andNumberOfFrames:inNumberFrames];
        free(bufferList->mBuffers[0].mData);
        free(bufferList);
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [THIS.delegate soundRecorder:THIS receivedData:bufferList andNumberOfFrames:inNumberFrames];
            free(bufferList->mBuffers[0].mData);
            free(bufferList);
        });
    }
    
    return noErr;
}

@implementation AISoundRecorder
{
    
}

- (id)init
{
    if (self = [super init]) {
        self.meterTable = [[AIMeterTable alloc] init];
        
#if TARGET_OS_IOS || TARGET_IPHONE_SIMULATOR
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(interruption:) name:AVAudioSessionInterruptionNotification object:nil];
#endif
    }
    return self;
}

#if TARGET_OS_IOS || TARGET_IPHONE_SIMULATOR
- (void)interruption:(NSNotification *)notification
{
    int interruptionType = [notification.userInfo[AVAudioSessionInterruptionTypeKey] intValue];
    if (interruptionType == AVAudioSessionInterruptionTypeEnded) {
        if ([self isRecording]) {
            [self stop];
            [self start];
        }
    }
}
#endif

- (CGFloat)calculateLevel:(AudioBufferList *)ioData andNumberFrames:(UInt32)numberofFrames
{
#define DBOFFSET -74.0
#define LOWPASSFILTERTIMESLICE .001
    
    SInt16 *samples = (SInt16 *)(ioData->mBuffers[0].mData);
    
    Float32 decibels = DBOFFSET;
    Float32 currentFilteredValueOfSampleAmplitude = 0.f, previousFilteredValueOfSampleAmplitude = 0.f;
    
    Float32 peakValue = DBOFFSET;
    
    for (int i = 0; i < numberofFrames; i++) {
        
        Float32 absoluteValueOfSampleAmplitude = abs(samples[i]); //Step 2: for each sample, get its amplitude's absolute value.
        
        // Step 3: for each sample's absolute value, run it through a simple low-pass filter
        // Begin low-pass filter
        currentFilteredValueOfSampleAmplitude = LOWPASSFILTERTIMESLICE * absoluteValueOfSampleAmplitude + (1.0 - LOWPASSFILTERTIMESLICE) * previousFilteredValueOfSampleAmplitude;
        previousFilteredValueOfSampleAmplitude = currentFilteredValueOfSampleAmplitude;
        Float32 amplitudeToConvertToDB = currentFilteredValueOfSampleAmplitude;
        // End low-pass filter
        
        Float32 sampleDB = 20.0 * log10(amplitudeToConvertToDB) + DBOFFSET;
        // Step 4: for each sample's filtered absolute value, convert it into decibels
        // Step 5: for each sample's filtered absolute value in decibels, add an offset value that normalizes the clipping point of the device to zero.
        
        if((sampleDB == sampleDB) && (sampleDB != -DBL_MAX)) {
            if(sampleDB > peakValue) {
                peakValue = sampleDB;
            }
            
            decibels = peakValue;
        }
    }
    
    return decibels;
}

- (void)start
{
    if ([self isRecording]) {
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([_delegate respondsToSelector:@selector(willStartSoundRecorder:)]) {
                [_delegate willStartSoundRecorder:self];
            }
        });

        [self configureFormat];
        [self configureProperties];
        
        [self startRecording];
    });
}

- (void)startRecording
{
    OPCA(AudioOutputUnitStart(_remoteIOUnit));
}

- (void)configureFormat
{
    _inputProcess.inputProc = PerformThru;
    _inputProcess.inputProcRefCon = (__bridge void *)self;
    
    AudioComponentDescription desc;
    desc.componentType = kComponentType;
    desc.componentSubType = kComponentSubType;
    desc.componentManufacturer = kComponentManufacturer;
    desc.componentFlags = kComponentFlags;
    desc.componentFlagsMask = kComponentFlagsMask;
    
    AudioComponent comp = AudioComponentFindNext(NULL, &desc);
    
    OPCA(AudioComponentInstanceNew(comp, &_remoteIOUnit));
}

- (void)configureProperties
{
#if TARGET_OS_IOS || TARGET_IPHONE_SIMULATOR
    UInt32 one = 1;
    
    OPCA(AudioUnitSetProperty(_remoteIOUnit,
                              kAudioOutputUnitProperty_EnableIO,
                              kAudioUnitScope_Input,
                              1,
                              &one,
                              sizeof(one)));
#endif
    
    OPCA(AudioUnitSetProperty(_remoteIOUnit,
                                  kAudioOutputUnitProperty_SetInputCallback,
                                  kAudioUnitScope_Global,
                                  1,
                                  &_inputProcess,
                                  sizeof(_inputProcess)));
    
    _outputFormat.mSampleRate = kSampleRate;
    _outputFormat.mFormatID = kFormatID;
    _outputFormat.mBytesPerPacket = kBytesPerPacket;
    _outputFormat.mFramesPerPacket = kFramesPerPacket;
    _outputFormat.mBytesPerFrame = kBytesPerFrame;
    _outputFormat.mChannelsPerFrame = kChannelsPerFrame;
    _outputFormat.mBitsPerChannel = kBitsPerChannel;
    _outputFormat.mFormatFlags = kFormatFlags;
    
    
    OPCA(AudioUnitSetProperty(_remoteIOUnit,
                            kAudioUnitProperty_StreamFormat,
                            kAudioUnitScope_Input,
                            0,
                            &_outputFormat,
                            sizeof(_outputFormat)));
    
    OPCA(AudioUnitSetProperty(_remoteIOUnit,
                            kAudioUnitProperty_StreamFormat,
                            kAudioUnitScope_Output,
                            1,
                            &_outputFormat,
                            sizeof(_outputFormat)));
    
    UInt32 flag = 0;
    OPCA(AudioUnitSetProperty(_remoteIOUnit,
                                  kAudioUnitProperty_ShouldAllocateBuffer,
                                  kAudioUnitScope_Input,
                                  1,
                                  &flag,
                                  sizeof(flag)));
    
    OPCA(AudioUnitInitialize(_remoteIOUnit));
}

- (BOOL)isRecording
{
    return _remoteIOUnit?YES:NO;
}

- (void)stop
{
    if (_remoteIOUnit == nil) {
        return;
    }
    
    OPCA(AudioOutputUnitStop(_remoteIOUnit));
    OPCA(AudioUnitUninitialize(_remoteIOUnit));
    OPCA(AudioComponentInstanceDispose(_remoteIOUnit));
    
    self.remoteIOUnit = nil;
    
    if ([_delegate respondsToSelector:@selector(didStopSoundRecorder:)]) {
        [_delegate didStopSoundRecorder:self];
    }
}

- (void)dealloc
{
    _delegate = nil;
    [self stop];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
