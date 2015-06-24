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

#import "EnergyAndZeroCross.h"

@interface EnergyAndZeroCross()

@property(nonatomic, strong) NSMutableArray *frame;

@end

@implementation EnergyAndZeroCross
{
    double maxSilenceLengthMilis;
    double minSilenceLengthMilis;
    double silenceLengthMilis;
    double sequenceLengthMilis;
    int minSequenceCount;
    double energyFactor;
    int minCZ;
    int maxCZ;
    
    int noiseFrames;
    double noiseEnergy;
    int frameNumber;
    double lastActiveTime;
    double lastSequenceTime;
    int sequenceCounter;
    double time;
    
    float sampleRate;
    double frameLengthMilis;
}

@synthesize sampleRate=sampleRate;

- (id)init
{
    self = [super init];
    if (self) {
        self.sampleRate = 16000.f;
        [self reset];
    }
    return self;
}

- (AIAlgorithmDetectorResult)processFrame:(NSArray *)data
{
    BOOL active = [self frameActive:data];
    time = frameNumber * self.frameSize / sampleRate;
    
    if (active) {
        printf("Active %.2f: %.2f\n", time, lastActiveTime);
        if (lastActiveTime >= 0 && (time - lastActiveTime) < sequenceLengthMilis) {
            sequenceCounter += 1;
            printf("Seq %.2f %i\n", time, sequenceCounter);
            if (sequenceCounter >= minSequenceCount) {
                printf("LAST SPEECH %.2f\n", time);
                lastSequenceTime = time;
                silenceLengthMilis = MAX(minSilenceLengthMilis, silenceLengthMilis - (maxSilenceLengthMilis - minSilenceLengthMilis) / 4);
                printf("SM: %.2f\n", silenceLengthMilis);
            }
        } else {
            sequenceCounter = 1;
        }
        lastActiveTime = time;
    } else {
        if (time - lastSequenceTime > silenceLengthMilis) {
            if (lastSequenceTime > 0) {
                printf("TERMINATE: %.2f\n", time);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_delegate endDetection:self withStatus:AIAlgorithmDetectorResultTerminate];
                });
                return AIAlgorithmDetectorResultTerminate;
            } else {
                printf("NOSPEECH: %.2f\n", time);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_delegate endDetection:self withStatus:AIAlgorithmDetectorResultNoSpeech];
                });
                return AIAlgorithmDetectorResultNoSpeech;
            }
        }
    }
    
    return AIAlgorithmDetectorResultContinue;
}

- (BOOL)frameActive:(NSArray *)frame
{
    NSInteger lastsign = 0;
    NSInteger czCount = 0;
    double energy = 0.0;
    
    
    for (int i = 0; i < [frame count]; i++) {
        energy += [frame[i] floatValue] * [frame[i] floatValue] / (double)self.frameSize;
        NSInteger sign = 0;
        if ([frame[i] floatValue] > 0) {
            sign = 1;
        } else {
            sign = -1;
        }
        
        if (sign != 0) {
            if (lastsign != 0 && sign != lastsign) {
                czCount += 1;
            }
            lastsign = sign;
        }
    }
    frameNumber += 1;
    
    BOOL result = NO;
    if (frameNumber < noiseFrames) {
        noiseEnergy = noiseEnergy + energy / (double)noiseFrames;
    } else {
        if (czCount >= minCZ && czCount <= maxCZ) {
            if (energy > MAX(noiseEnergy, 0.0008) * energyFactor) {
                result = YES;
            }
        }
    }
    
    
    return result;
}

- (void)reset
{
    frameLengthMilis = 10.0;
    maxSilenceLengthMilis = 3.5;
    minSilenceLengthMilis = 0.8;
    silenceLengthMilis = maxSilenceLengthMilis;
    sequenceLengthMilis = 0.03;
    minSequenceCount = 3;
    energyFactor = 3.1; // 1.1
    self.frameSize = (int)((sampleRate * frameLengthMilis) / 1000.0);
    minCZ = (int)(5. * frameLengthMilis / 10.);
    maxCZ = minCZ * 3;
    
    noiseFrames = (int)(150. / frameLengthMilis);
    noiseEnergy = 0.0;
    frameNumber = 0;
    lastActiveTime = -1.0;
    lastSequenceTime = 0.0;
    sequenceCounter = 0;
    time = 0.f;
    
    self.frame = [NSMutableArray array];
}

@end
