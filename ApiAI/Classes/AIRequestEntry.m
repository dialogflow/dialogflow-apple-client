//
//  AIRequestContext.m
//  ApiAI
//
//  Created by Kuragin Dmitriy on 22/05/15.
//  Copyright (c) 2015 Kuragin Dmitriy. All rights reserved.
//

#import "AIRequestEntry.h"

@implementation AIRequestEntry

- (instancetype)initWithValue:(NSString * __AI_NONNULL)value andSynonims:(NSArray * __AI_NONNULL) synonims
{
    self = [super init];
    if (self) {
        _value = [value copy];
        _synonyms = [synonims copy];
    }
    
    return self;
}

@end
