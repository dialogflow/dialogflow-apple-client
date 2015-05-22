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

#import "AIResponse.h"
#import "AIResponseStatus_Private.h"
#import "AIResponseResult_Private.h"

@interface AIResponse ()

@property(nonatomic, copy) NSDictionary *response;

@end

@implementation AIResponse

- (instancetype)initWithResponse:(id)responseObject
{
    self = [super init];
    if (self) {
        self.response = responseObject;
        
        
        static NSDateFormatter *timestampDateFormatter = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
            [dateFormatter setLocale:locale];
            
            [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
            
            timestampDateFormatter = dateFormatter;
        });
        
        _identifier = _response[@"id"];
        _timestamp = [timestampDateFormatter dateFromString:_response[@"timestamp"]];
        
        _result = [[AIResponseResult alloc] initWithDictionary:_response[@"result"]];
        _status = [[AIResponseStatus alloc] initWithDictionary:_response[@"status"]];
    }
    
    return self;
}

@end
