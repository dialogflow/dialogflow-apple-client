//
//  AIResponseResult.m
//  AIWrapRespProject
//
//  Created by Kuragin Dmitriy on 06/05/15.
//  Copyright (c) 2015 Kuragin Dmitriy. All rights reserved.
//

#import "AIResponseResult.h"
#import "AIResponseStatus_Private.h"
#import "AIResponseMetadata_Private.h"
#import "AIResponseParameter_Private.h"
#import "AIResponseFulfillment_Private.h"
#import "AIResponseContext_Private.h"

@interface AIResponseResult ()

@property(nonatomic, copy) NSDictionary *responseResult;

@end

@implementation AIResponseResult

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        self.responseResult = dictionary;
        
        _source = _responseResult[@"source"];
        _resolvedQuery = _responseResult[@"resolvedQuery"];
        _action = _responseResult[@"action"];
        
        {
            __block NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
            
            NSDictionary *sourceParameters = _responseResult[@"parameters"]?:@{};
            
            [sourceParameters enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                parameters[key] = [[AIResponseParameter alloc] initWithString:obj];
            }];
            
            _parameters = [parameters copy];
        }
        
        {
            NSArray *sourceContexts = _responseResult[@"contexts"]?:@[];
            
            NSMutableArray *contexts = [NSMutableArray array];
            [sourceContexts enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
                AIResponseContext *context = [[AIResponseContext alloc] initWithDictionary:obj];
                [contexts addObject:context];
            }];
            
            _contexts = [contexts copy];
        }
        
        _fulfillment = [[AIResponseFulfillment alloc] initWithDictionary:_responseResult[@"fulfillment"]];
        _metadata = [[AIResponseMetadata alloc] initWithDictionary:_responseResult[@"metadata"]];
    }
    
    return self;
}

@end
