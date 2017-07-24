//
//  AIRequest+Private.m
//  ApiAI
//
//  Created by Kuragin Dmitriy on 28/07/15.
//  Copyright © 2015 Kuragin Dmitriy. All rights reserved.
//

#import "AIQueryRequest+Private.h"
#import "AIConfiguration.h"
#import "AIDataService_Private.h"
#import "AIRequestEntity_Private.h"
#import "AINullabilityDefines.h"
#import "AIOriginalRequest_Private.h"

static NSString *URLEncode(NSString *string) {
    return [string stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
}

@implementation AIQueryRequest (Private)

- (NSDictionary *)defaultHeaders
{
    id <AIConfiguration> configuration = self.dataService.configuration;
    
    return @{
             @"Accept": @"application/json",
             @"Authorization": [NSString stringWithFormat:@"Bearer %@", configuration.clientAccessToken]
             };
}

- (NSDictionary *)requestBodyDictionary
{
    NSString *timeZoneString = self.timeZone ? self.timeZone.name : [NSTimeZone localTimeZone].name;
    
    NSMutableDictionary *parameters = [@{
                                         @"lang": self.lang,
                                         @"timezone": timeZoneString
                                         } mutableCopy];
    
    parameters[@"originalRequest"] = [self.originalRequest serialized];
    
    if (self.resetContexts) {
        parameters[@"resetContexts"] = @(self.resetContexts);
    }
    
    if ([self.requestContexts count]) {
        parameters[@"contexts"] = [self contextsRequestPresentation];
    }
    
    if ([self.entities count]) {
        NSMutableArray *entities = [NSMutableArray array];
        [self.entities enumerateObjectsUsingBlock:^(AIRequestEntity *obj, NSUInteger idx, BOOL *stop) {
            [entities addObject:obj.dictionaryPresentation];
        }];
        
        parameters[@"entities"] = [entities copy];
    }
    
    parameters[@"sessionId"] = self.sessionId;
    
    AIQueryRequestLocation *location = self.location;
    
    if (location) {
        parameters[@"location"] = @{
                                    @"latitude": @(location.latitude),
                                    @"longitude": @(location.longitude)
                                    };
    }

    return [parameters copy];
}

- (NSDictionary *)getQueryParameters {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (self.version) {
        parameters[@"v"] = self.version;
    }
    
    return [parameters copy];
}

- (NSString *)queryFromQueryParameters:(NSDictionary *)queryParameters {
    NSMutableArray *pairs = [NSMutableArray arrayWithCapacity:queryParameters.count];
    
    [queryParameters enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [pairs addObject:[NSString stringWithFormat:@"%@=%@", URLEncode(key), URLEncode(obj)]];
    }];
    
    return [pairs componentsJoinedByString:@"&"];
}

- (NSMutableURLRequest *)prepareDefaultRequest
{
    id <AIConfiguration> configuration = self.dataService.configuration;
    
    NSString *path = @"query";
    
    NSString *getQueryString = [self queryFromQueryParameters: [self getQueryParameters]];
    
    NSURL *URL = [configuration.baseURL URLByAppendingPathComponent:path];
    
    NSURLComponents *components = [NSURLComponents componentsWithURL:URL resolvingAgainstBaseURL:NO];
    components.query = getQueryString;
    
    URL = components.URL;
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:URL];
    
    [request setHTTPMethod:@"POST"];
    
    [request setAllHTTPHeaderFields:self.defaultHeaders];
    
    return request;
}

- (NSArray *)contextsRequestPresentation
{
    NSMutableArray AI_GENERICS_1(NSDictionary AI_GENERICS_2(NSString *, id) *) *contexts = [NSMutableArray array];
    [self.requestContexts enumerateObjectsUsingBlock:^(AIRequestContext * __AI_NONNULL obj, NSUInteger idx, BOOL * __AI_NONNULL stop) {
        NSMutableDictionary AI_GENERICS_2(NSString *, id) *context = [NSMutableDictionary dictionary];
        
        context[@"name"] = obj.name;
        if (obj.parameters) {
            context[@"parameters"] = obj.parameters;
        }
        
        if (obj.lifespan) {
            context[@"lifespan"] = obj.lifespan;
        }
        
        [contexts addObject:context];
    }];
    
    return [contexts copy];
}

@end
