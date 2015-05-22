//
//  AIRequestContext.m
//  ApiAI
//
//  Created by Kuragin Dmitriy on 22/05/15.
//  Copyright (c) 2015 Kuragin Dmitriy. All rights reserved.
//

#import "AIRequestEntry.h"

@implementation AIRequestEntry

- (instancetype)initWithValue:(NSString * __nonnull)value andSynonims:(NSArray * __nonnull) synonims
{
    self = [super init];
    if (self) {
        _value = value;
        _synonyms = synonims;
    }
    
    return self;
}

@end
