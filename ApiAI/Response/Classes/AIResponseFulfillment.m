//
//  AIResponseFulfillment.m
//  AIWrapRespProject
//
//  Created by Kuragin Dmitriy on 07/05/15.
//  Copyright (c) 2015 Kuragin Dmitriy. All rights reserved.
//

#import "AIResponseFulfillment.h"
#import "AIResponseFulfillment_Private.h"

@implementation AIResponseFulfillment

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        _speech = dictionary[@"speech"];
    }
    
    return self;
}

@end
