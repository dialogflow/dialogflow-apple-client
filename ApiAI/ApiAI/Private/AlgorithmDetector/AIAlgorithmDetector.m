//
//  AlgorithmDetector.m
//  Assistant
//
//  Created by Dmitriy Kuragin on 10/13/13.
//  Copyright (c) 2013 SpeakToIt. All rights reserved.
//

#import "AIAlgorithmDetector.h"

@implementation AIAlgorithmDetector

@synthesize delegate=_delegate;

- (AIAlgorithmDetectorResult)processFrame:(NSArray *)data
{
    @throw [NSException exceptionWithName:NSInvalidArgumentException
                                   reason:[NSString stringWithFormat:@"%s must be overridden in a subclass/category", __PRETTY_FUNCTION__]
                                 userInfo:nil];
}

- (void)reset
{
    @throw [NSException exceptionWithName:NSInvalidArgumentException
                                   reason:[NSString stringWithFormat:@"%s must be overridden in a subclass/category", __PRETTY_FUNCTION__]
                                 userInfo:nil];
}

+ (instancetype)algorithmWithClassName:(NSString *)className
{
    Class class = NSClassFromString(className);
    if (!class) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException
                                       reason:[NSString stringWithFormat:@"%@ algorithm not found", className]
                                     userInfo:nil];
    }
    
    return [[class alloc] init];
}

@end
