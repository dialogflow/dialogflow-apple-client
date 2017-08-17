/**
 * Copyright 2017 Google Inc. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
 

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "EnergyAndZeroCross.h"
#import "AudioFileReader.h"

@interface AIVADTest : XCTestCase

@property(nonatomic, strong) EnergyAndZeroCross *energyAndZeroCross;

@end

@implementation AIVADTest

- (void)setUp {
    [super setUp];
    
    self.energyAndZeroCross = [[EnergyAndZeroCross alloc] init];
    _energyAndZeroCross.sampleRate = 16000.f;
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (AIAlgorithmDetectorResult)testVoiceSoundWithName:(NSString *)name
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *filePath = [bundle pathForResource:name ofType:@"wav"];
    
    AudioFileReader *reader = [[AudioFileReader alloc] initWithFileURL:[NSURL fileURLWithPath:filePath]];
    
    ExtAudioFileRef audioFileRef;
    ExtAudioFileOpenURL((__bridge CFURLRef)[NSURL fileURLWithPath:filePath], &audioFileRef);
    
    SInt64 framesCount = 0;
    UInt32 size = sizeof(SInt64);
    ExtAudioFileGetProperty(audioFileRef, kExtAudioFileProperty_FileLengthFrames, &size, &framesCount);
    
    AudioStreamBasicDescription audioStreamBasicDescription;
    UInt32 descSize = sizeof(AudioStreamBasicDescription);
    
    ExtAudioFileGetProperty(audioFileRef, kExtAudioFileProperty_FileDataFormat, &descSize, &audioStreamBasicDescription);
    
    SInt64 offset = 0;
    
    _energyAndZeroCross.sampleRate = audioStreamBasicDescription.mSampleRate;
    [_energyAndZeroCross reset];
    
    AIAlgorithmDetectorResult result = AIAlgorithmDetectorResultContinue;
    
    NSInteger count = 0;
    
    while (offset < framesCount && result == AIAlgorithmDetectorResultContinue) {
        NSMutableArray *frames = [NSMutableArray array];
        
        NSInteger len = _energyAndZeroCross.frameSize;
        
        AudioBufferList bufferList;
        
        [reader read:&bufferList withFramesCount:(UInt32)_energyAndZeroCross.frameSize];
        
        
        SInt16 *int16Buffer = bufferList.mBuffers[0].mData;
        
        for (int i = 0; i < len; i++) {
            SInt16 value = int16Buffer[i];
            
            [frames addObject:@(((double)value) / (double)SHRT_MAX)];
        }
        
        if (count == 20) {
            for (int i = 0; i < 160; i++) {
                printf("%d\n", int16Buffer[i]);
            }
            NSLog(@"");
        }
    
        offset += len;
        
        result = [_energyAndZeroCross processFrame:frames];
        
        [reader enqueueAudioBufferList:&bufferList];
        
        count ++;
    }
    
    float currentTime = ((double) (framesCount - (framesCount - offset))) / (audioStreamBasicDescription.mSampleRate);
    NSLog(@"Current time == %f", currentTime);
    NSLog(@"Count == %ld", (long)count);
    
    return result;
}

- (void)testExample {
    AIAlgorithmDetectorResult result = [self testVoiceSoundWithName:@"speech_d"];
    NSLog(@"");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
