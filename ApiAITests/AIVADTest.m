//
//  AIVADTest.m
//  ApiAI
//
//  Created by Kuragin Dmitriy on 23/06/15.
//  Copyright (c) 2015 Kuragin Dmitriy. All rights reserved.
//

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
    AIAlgorithmDetectorResult result = [self testVoiceSoundWithName:@"sound2"];
    NSLog(@"");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
