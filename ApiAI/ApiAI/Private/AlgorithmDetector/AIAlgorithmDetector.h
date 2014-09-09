//
//  AlgorithmDetector.h
//  Assistant
//
//  Created by Dmitriy Kuragin on 10/13/13.
//  Copyright (c) 2013 SpeakToIt. All rights reserved.
//
#import "AIAlgorithmDetectorDelegate.h"
#import "AIAlgorithmDetectorTypes.h"

@protocol AIAlgorithmDetector <NSObject>

@required

- (AIAlgorithmDetectorResult)processFrame:(NSArray *)data;
- (void)reset;

@end

@interface AIAlgorithmDetector : NSObject <AIAlgorithmDetector>
{
    @protected
    __weak id <AIAlgorithmDetectorDelegate> _delegate;
}

@property(nonatomic, weak) id <AIAlgorithmDetectorDelegate> delegate;
@property(nonatomic, assign) NSInteger frameSize;

+ (instancetype)algorithmWithClassName:(NSString *)className;

@end
