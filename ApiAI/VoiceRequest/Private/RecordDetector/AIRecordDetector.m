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
//#import "AISoundRecorder.h"
#import "AIQueueAudioRecorder.h"

@import AVFoundation;

@interface AIRecordDetector() <AIQueueAudioRecorderDelegate, AIAlgorithmDetectorDelegate>

@property(nonatomic, strong) AIAlgorithmDetector *algorithmDetector;
@property(nonatomic, strong) AIQueueAudioRecorder *audioRecorder;
@property(nonatomic, strong) NSMutableArray *frames;

@end

@implementation AIRecordDetector

- (id)init
{
    self = [super init];
    if (self) {
//        self.algorithmDetector = [AIAlgorithmDetector algorithmWithClassName:@"EnergyAndZeroCross"];
        self.algorithmDetector = [AIAlgorithmDetector algorithmWithClassName:@"AdaptiveThresold"];
        _algorithmDetector.delegate = self;
        [_algorithmDetector reset];
        
        self.audioRecorder = [[AIQueueAudioRecorder alloc] init];
        _audioRecorder.delegate = self;
        
        self.frames = [NSMutableArray array];
    }
    
    return self;
}

- (void)start
{
    self.frames = [NSMutableArray array];
    [_algorithmDetector reset];
    
    _audioRecorder.delegate = self;
    [_audioRecorder start];
    
    __weak id selfWeak = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [_delegate recordDetectorDidStartRecording:selfWeak];
    });
}

- (void)cancel
{
    if (![_audioRecorder isRecording]) {
        return;
    }
    
    _audioRecorder.delegate = nil;
    [_audioRecorder stop];
    
    [_frames removeAllObjects];
    
    __weak id selfWeak = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [_delegate recordDetectorDidStopRecording:selfWeak cancelled:YES];
    });
}

- (void)stop
{
    if (![_audioRecorder isRecording]) {
        return;
    }
    
    _audioRecorder.delegate = nil;
    [_audioRecorder stop];
    
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
    _audioRecorder.delegate = nil;
    [_audioRecorder stop];
    
    [_frames removeAllObjects];
    
    if (algorithmDetectorResult != AIAlgorithmDetectorResultTerminate) {
        NSError *error = [NSError errorWithDomain:@"voice.detection.error" code:algorithmDetectorResult userInfo:@{}];
        [_delegate recordDetector:self didFailWithError:error];
    } else {
        [_delegate recordDetectorDidStopRecording:self cancelled:NO];
    }
}

#pragma mark -
#pragma mark AIQueueAudioRecorderDelegate

- (void)audioRecorder:(AIQueueAudioRecorder *)audioRecorder dataReceived:(SInt16 *)samples andSamplesCount:(UInt32)samplesCount
{
    NSMutableData *data = [[NSMutableData alloc] init];
    [data appendBytes:samples length:samplesCount * sizeof(SInt16)];
    
    for (UInt32 i = 0; i < samplesCount; i++)
    {
        [_frames addObject:@((double)samples[i] / (double)SHRT_MAX)];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.VADListening) {
            [self process];
        }
    
        [_delegate recordDetector:self didReceiveData:data];
    });
}

- (void)audioRecorder:(AIQueueAudioRecorder *)audioRecorder didFailWithError:(NSError *)error {
    
}

- (void)audioRecorder:(AIQueueAudioRecorder *)audioRecorder audioLevelChanged:(float)audioLevel {
    [_delegate recordDetector:self audioLevelChanged:audioLevel];
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
