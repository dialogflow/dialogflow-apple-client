/***********************************************************************************************************************
 *
 * API.AI iOS SDK - client-side libraries for API.AI
 * ==========================================
 *
 * Copyright (C) 2015 by Speaktoit, Inc. (https://www.speaktoit.com)
 * https://www.api.ai
 *
 ***********************************************************************************************************************
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with
 * the License. You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on
 * an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the
 * specific language governing permissions and limitations under the License.
 *
 ***********************************************************************************************************************/

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
        _actionIncomplete = _responseResult[@"actionIncomplete"];
        
        {
            __block NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
            
            NSDictionary *sourceParameters = _responseResult[@"parameters"]?:@{};
            
            [sourceParameters enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                parameters[key] = [[AIResponseParameter alloc] initWithObject:obj];
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
