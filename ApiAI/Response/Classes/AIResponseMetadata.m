//
//  AIResponseMetadata.m
//  AIWrapRespProject
//
//  Created by Kuragin Dmitriy on 06/05/15.
//  Copyright (c) 2015 Kuragin Dmitriy. All rights reserved.
//

#import "AIResponseMetadata.h"
#import "AIResponseResult_Private.h"

@implementation AIResponseMetadata

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        _indentId = dictionary[@"intentId"];
        _intentName = dictionary[@"intentName"];
    }
    
    return self;
}

@end
