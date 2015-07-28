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

#import "AdaptiveThresold.h"

@interface AdaptiveThresold ()

@property(nonatomic, assign) BOOL isFirst;
@property(nonatomic, assign) BOOL wait;

@property(nonatomic, assign) double energyMAX;
@property(nonatomic, assign) double energyMIN;

@property(nonatomic, assign) double energyMIN_INITIAL;

@property(nonatomic, assign) double delta;

@property(nonatomic, assign) NSInteger inactiveFrameCount;
@property(nonatomic, assign) NSInteger activeFrameCount;

@end

@implementation AdaptiveThresold

- (id)init
{
    self = [super init];
    if (self) {
        [self reset];
    }
    
    return self;
}

- (void)resetDelta
{
    self.delta = 1.01;
}

- (double)energy:(NSArray *)frame
{
    double result = 0;
    
    for (NSNumber *value in frame) {
        result += [value doubleValue] * [value doubleValue];
    }
    
    return sqrt(result / (double)[frame count]);
}

- (AIAlgorithmDetectorResult)processFrame:(NSArray *)data
{
    AIAlgorithmDetectorResult state = AIAlgorithmDetectorResultContinue;
    
    if (![data count]) return state;
    
    double energy = [self energy:data];
    
    if (self.isFirst) {
        self.isFirst = NO;
        
        self.energyMAX = energy;
        self.energyMIN_INITIAL = energy;
        self.energyMIN = self.energyMIN_INITIAL;
        
        return state;
    }
    
    if (energy > self.energyMAX) {
        self.energyMAX = energy;
    }
    
    if (energy < self.energyMIN) {
        if (energy < 0.025) {
            self.energyMIN = self.energyMIN_INITIAL;
        } else {
            self.energyMIN = energy;
        }
        
        [self resetDelta];
    }
    
    double lam = (ABS(self.energyMAX - self.energyMIN) / (self.energyMAX + 0.001));
    
    double thresold = (1.0 - lam) * self.energyMAX + lam * self.energyMIN;
    
    
    ///////
    
    BOOL cz = [self czCalc:data];
    
    ///////
    
    if ((energy > thresold * 1.4) && (lam > 0.25) && cz) {
        if (self.activeFrameCount > 10) {
            state = AIAlgorithmDetectorResultContinue;
            self.inactiveFrameCount = 0;
            self.wait = NO;
        } else {
            state = AIAlgorithmDetectorResultContinue;
        }
        
        self.activeFrameCount += 1;
    } else {
        if (self.inactiveFrameCount > 150) {
            state = AIAlgorithmDetectorResultTerminate;
            self.activeFrameCount = 0;
        } else {
            state = AIAlgorithmDetectorResultContinue;
        }
        
        self.inactiveFrameCount += 1;
    }
    
    if (state == AIAlgorithmDetectorResultTerminate && self.wait) {
        if (self.inactiveFrameCount < 350) {
            state = AIAlgorithmDetectorResultContinue;
        } else {
            state = AIAlgorithmDetectorResultNoSpeech;
            [_delegate endDetection:self withStatus:AIAlgorithmDetectorResultNoSpeech];
            self.wait = NO;
        }
    }
    
    if (state == AIAlgorithmDetectorResultTerminate && self.inactiveFrameCount > 150) {
        [_delegate endDetection:self withStatus:AIAlgorithmDetectorResultTerminate];
    }
    
    self.delta *= 1.001;
    
    self.energyMIN = self.energyMIN * self.delta;
    
    return state;
}

- (BOOL)czCalc:(NSArray *)frame
{
    NSInteger lastsign = 0;
    NSInteger czCount = 0;
    double energy = 0.0;
    
    double minCZ = (int)(5. * 10. / 10.);
    double maxCZ = minCZ * 3;
    
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
    
    if (czCount >= minCZ && czCount <= maxCZ) {
        return YES;
    }
    
    return NO;
}

- (void)reset
{
    self.isFirst = YES;
    
    self.activeFrameCount = 0;
    self.inactiveFrameCount = 0;
    self.energyMAX = 0.0;
    self.energyMIN = 0.0;
    self.energyMIN_INITIAL = 0.0;
    
    self.wait = YES;
    
    [self resetDelta];
    
    self.frameSize = 160;
}

@end
