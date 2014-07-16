//
//  AlgorithmDetectorDelegate.h
//  Assistant
//
//  Created by Dmitriy Kuragin on 10/13/13.
//  Copyright (c) 2013 SpeakToIt. All rights reserved.
//

#import "OPAlgorithmDetectorTypes.h"

@class OPAlgorithmDetector;

@protocol OPAlgorithmDetectorDelegate <NSObject>

@required
- (void)startDetection:(OPAlgorithmDetector *)algorithmDetector;
- (void)endDetection:(OPAlgorithmDetector *)algorithmDetector withStatus:(OPAlgorithmDetectorResult)algorithmDetectorResult;

@end
