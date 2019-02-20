/**
 * Copyright 2017 Google Inc. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
 
#import "AIQueryRequest.h"
#import "AISessionIdentifierStorage.h"

@implementation AIQueryRequestLocation

- (instancetype)initWithLatitude:(double)latitude andLongitude:(double)longitude {
    self = [super init];
    if (self) {
        self.latitude = latitude;
        self.longitude = longitude;
    }
    
    return self;
}

+ (instancetype)locationWithLatitude:(double)latitude andLongitude:(double)longitude {
    return [[self alloc] initWithLatitude:latitude andLongitude:longitude];
}

@end

@implementation AIQueryRequest

- (void)setContexts:(NSArray *)contexts
{
    _contexts = [contexts copy];
    
    NSMutableArray AI_GENERICS_1(AIRequestContext *)  *requestContexts = [NSMutableArray array];
    
    [contexts enumerateObjectsUsingBlock:^(id  __AI_NONNULL obj, NSUInteger idx, BOOL * __AI_NONNULL stop) {
        AIRequestContext *requestContext = [[AIRequestContext alloc] initWithName:obj
                                                                    andParameters:nil];
        [requestContexts addObject:requestContext];
    }];
    
    self.requestContexts = requestContexts;
}

- (NSString *)sessionId
{
    if (!_sessionId) {
        _sessionId = [AISessionIdentifierStorage defaulSessionIdentifier];
    }
    
    return _sessionId;
}

- (NSTimeZone *)timeZone
{
    if (!_timeZone) {
        _timeZone = [NSTimeZone localTimeZone];
    }
    
    return _timeZone;
}

@end
