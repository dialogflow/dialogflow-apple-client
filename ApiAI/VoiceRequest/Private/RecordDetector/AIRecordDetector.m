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

#import "AIRecordDetector.h"
#import "AIAlgorithmDetector.h"
#import "AISoundRecorder.h"

@import AVFoundation;

@interface AIRecordDetector() <AIAlgorithmDetectorDelegate, AISoundRecorderDelegate>

@property(nonatomic, strong) AIAlgorithmDetector *algorithmDetector;
@property(nonatomic, strong) AISoundRecorder *soundRecorder;
@property(nonatomic, strong) NSMutableArray *frames;

@end

@implementation AIRecordDetector

- (id)init
{
    self = [super init];
    if (self) {
        self.algorithmDetector = [AIAlgorithmDetector algorithmWithClassName:@"EnergyAndZeroCross"];
//        self.algorithmDetector = [AIAlgorithmDetector algorithmWithClassName:@"AdaptiveThresold"];
        _algorithmDetector.delegate = self;
        [_algorithmDetector reset];
        
        self.soundRecorder = [[AISoundRecorder alloc] init];
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

- (void)startDetection:(AIAlgorithmDetector *)algorithmDetector
{
    // TODO: remove this method (and from delegate too) or implement
}

- (void)endDetection:(AIAlgorithmDetector *)algorithmDetector
          withStatus:(AIAlgorithmDetectorResult)algorithmDetectorResult;
{
    _soundRecorder.delegate = nil;
    [_soundRecorder stop];
    [_frames removeAllObjects];
    
    if (algorithmDetectorResult != AIAlgorithmDetectorResultTerminate) {
        NSError *error = [NSError errorWithDomain:@"voice.detection.error" code:algorithmDetectorResult userInfo:@{}];
        [_delegate recordDetector:self didFailWithError:error];
    } else {
        [_delegate recordDetectorDidStopRecording:self cancelled:NO];
    }
}

#pragma mark - 
#pragma mark SoundRecorderDelegate

- (void)willStartSoundRecorder:(AISoundRecorder *)soundRecorder
{
    
}

- (void)didStopSoundRecorder:(AISoundRecorder *)soundRecorder
{
    
}

- (void)soundRecorder:(AISoundRecorder *)soundRecorder
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
        if (self.VADListening) {
            AIAlgorithmDetectorResult result = [self process];
            if (result != AIAlgorithmDetectorResultContinue) {
                if (result == AIAlgorithmDetectorResultNoSpeech) {
                    
                } else if (result == AIAlgorithmDetectorResultTerminate) {
                    
                }
            }
        }
        
        double power1 = _soundRecorder.currentPower;
        [_delegate recordDetector:self didReceiveData:data power:power1];
    });
}

- (AIAlgorithmDetectorResult)process
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
        
        AIAlgorithmDetectorResult result = [_algorithmDetector processFrame:frame];
        
        if (result != AIAlgorithmDetectorResultContinue) {
            return result;
        }
    }
    
    return AIAlgorithmDetectorResultContinue;
}

@end
