//
//  AlgorithmDetectorDelegate.h
//  Assistant
//
//  Created by Dmitriy Kuragin on 10/13/13.
//  Copyright (c) 2013 SpeakToIt. All rights reserved.
//

#import "AIAlgorithmDetectorTypes.h"

@class AIAlgorithmDetector;

@protocol AIAlgorithmDetectorDelegate <NSObject>

@required
- (void)startDetection:(AIAlgorithmDetector *)algorithmDetector;
- (void)endDetection:(AIAlgorithmDetector *)algorithmDetector withStatus:(AIAlgorithmDetectorResult)algorithmDetectorResult;

@end
