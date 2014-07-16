//
//  RecordHelper.m
//  RecordAndRecognize
//
//  Created by Eugene Polyakov on 4/19/13.
//  Copyright (c) 2013 Eugene Polyakov. All rights reserved.
//

#import "OPRecordDetector.h"
#import "OPAlgorithmDetector.h"
#import "OPSoundRecorder.h"

@import AVFoundation;

@interface OPRecordDetector() <OPAlgorithmDetectorDelegate, OPSoundRecorderDelegate>

@property(nonatomic, strong) OPAlgorithmDetector *algorithmDetector;
@property(nonatomic, strong) OPSoundRecorder *soundRecorder;
@property(nonatomic, strong) NSMutableArray *frames;

@end

@implementation OPRecordDetector

- (id)init
{
    self = [super init];
    if (self) {
        self.algorithmDetector = [OPAlgorithmDetector algorithmWithClassName:@"EnergyAndZeroCross"];
        _algorithmDetector.delegate = self;
        [_algorithmDetector reset];
        
        self.soundRecorder = [[OPSoundRecorder alloc] init];
        _soundRecorder.delegate = self;
        
        self.frames = [NSMutableArray array];
    }
    
    return self;
}

- (void)start
{
    self.frames = [NSMutableArray array];
    [_algorithmDetector reset];
    _soundRecorder.delegate = self;
    [_soundRecorder start];
    
    NSLog(@"Speak!");
    
    __weak id selfWeak = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [_delegate recordDetectorDidStartRecording:selfWeak];
    });
}

- (void)cancel
{
    if (![_soundRecorder isRecording]) {
        return;
    }
    
    _soundRecorder.delegate = nil;
    [_soundRecorder stop];
    [_frames removeAllObjects];
    
    __weak id selfWeak = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [_delegate recordDetectorDidStopRecording:selfWeak cancelled:YES];
    });
}

- (void)stop
{
    if (![_soundRecorder isRecording]) {
        return;
    }
    
    _soundRecorder.delegate = nil;
    [_soundRecorder stop];
    [_frames removeAllObjects];
    
    __weak id selfWeak = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [_delegate recordDetectorDidStopRecording:selfWeak cancelled:NO];
    });
}

#pragma mark - 
#pragma mark AlgorithmDetectorDelegate

- (void)startDetection:(OPAlgorithmDetector *)algorithmDetector
{
    // TODO: remove this method (and from delegate too) or implement
}

- (void)endDetection:(OPAlgorithmDetector *)algorithmDetector
          withStatus:(OPAlgorithmDetectorResult)algorithmDetectorResult;
{
    _soundRecorder.delegate = nil;
    [_soundRecorder stop];
    [_frames removeAllObjects];
    
    if (algorithmDetectorResult != OPAlgorithmDetectorResultTerminate) {
        NSError *error = [NSError errorWithDomain:@"voice.detection.error" code:algorithmDetectorResult userInfo:@{}];
        [_delegate recordDetector:self didFailWithError:error];
    } else {
        [_delegate recordDetectorDidStopRecording:self cancelled:NO];
    }
}

#pragma mark - 
#pragma mark SoundRecorderDelegate

- (void)willStartSoundRecorder:(OPSoundRecorder *)soundRecorder
{
    
}

- (void)didStopSoundRecorder:(OPSoundRecorder *)soundRecorder
{
    
}

- (void)soundRecorder:(OPSoundRecorder *)soundRecorder
         receivedData:(AudioBufferList *)ioData
    andNumberOfFrames:(UInt32)numberofFrames
{
    long long pw = 0;
    long long cnt = 0;
    
    NSMutableData *data = [[NSMutableData alloc] init];
    for (int i = 0; i < ioData->mNumberBuffers; i++) {
        SInt16* mdata = (SInt16 *)ioData->mBuffers[i].mData;
        UInt32 len = ioData->mBuffers[i].mDataByteSize;
        [data appendBytes:mdata length:len];
        
        long long ret = 0;
        for (UInt32 i = 0; i < numberofFrames; i++)
        {
            SInt16 mY1 = mdata[i];
            ret += abs(mY1);
            [_frames addObject:@((double)mY1 / (double)SHRT_MAX)];
        }
        
        pw += ret;
        cnt += len;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        OPAlgorithmDetectorResult result = [self process];
        if (result != OPAlgorithmDetectorResultContinue) {
            if (result == OPAlgorithmDetectorResultNoSpeech) {
                
            } else if (result == OPAlgorithmDetectorResultTerminate) {

            }
        }
        
        double power1 = _soundRecorder.currentPower;
        
        [_delegate recordDetector:self didReceiveData:data power:power1];
    });
}

- (OPAlgorithmDetectorResult)process
{
    while ([_frames count] > [_algorithmDetector frameSize]) {
        NSMutableArray *frame = [NSMutableArray array];
        for (int i = 0; i < [_algorithmDetector frameSize]; i++) {
            id number = [_frames firstObject];
            if (number) {
                [frame addObject:number];
            }
            [_frames removeObjectAtIndex:0];
        }
        
        OPAlgorithmDetectorResult result = [_algorithmDetector processFrame:frame];
        
        if (result != OPAlgorithmDetectorResultContinue) {
            return result;
        }
    }
    
    return OPAlgorithmDetectorResultContinue;
}

#pragma mark -
#pragma mark Deallocation

- (void)dealloc
{
    
}

@end
