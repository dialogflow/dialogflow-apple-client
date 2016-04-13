//
//  AIQueryRequest.m
//  ApiAI
//
//  Created by Kuragin Dmitriy on 02/03/16.
//  Copyright © 2016 Kuragin Dmitriy. All rights reserved.
//

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
