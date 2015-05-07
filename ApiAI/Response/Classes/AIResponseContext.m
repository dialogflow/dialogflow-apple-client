//
//  AIResponseContext.m
//  ApiAI
//
//  Created by Kuragin Dmitriy on 07/05/15.
//  Copyright (c) 2015 Kuragin Dmitriy. All rights reserved.
//

#import "AIResponseContext.h"

#import "AIResponseParameter_Private.h"
#import "AIResponseContext_Private.h"

@implementation AIResponseContext

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        _name = dictionary[@"name"];
        
        {
            __block NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
            
            NSDictionary *sourceParameters = dictionary[@"parameters"]?:@{};
            
            [sourceParameters enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                parameters[key] = [[AIResponseParameter alloc] initWithString:obj];
            }];
            
            _parameters = [parameters copy];
        }
    }
    
    return self;
}

@end
