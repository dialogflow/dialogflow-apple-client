//
//  AlgorithmDetector.h
//  Assistant
//
//  Created by Dmitriy Kuragin on 10/13/13.
//  Copyright (c) 2013 SpeakToIt. All rights reserved.
//
#import "OPAlgorithmDetectorDelegate.h"
#import "OPAlgorithmDetectorTypes.h"

@protocol OPAlgorithmDetector <NSObject>

@required

- (OPAlgorithmDetectorResult)processFrame:(NSArray *)data;
- (void)reset;

@end

@interface OPAlgorithmDetector : NSObject <OPAlgorithmDetector>
{
    @protected
    __weak id <OPAlgorithmDetectorDelegate> _delegate;
}

@property(nonatomic, weak) id <OPAlgorithmDetectorDelegate> delegate;
@property(nonatomic, assign) NSInteger frameSize;

+ (instancetype)algorithmWithClassName:(NSString *)className;

@end
