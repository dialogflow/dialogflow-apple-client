//
//  AIRequest+Private.m
//  ApiAI
//
//  Created by Kuragin Dmitriy on 28/07/15.
//  Copyright © 2015 Kuragin Dmitriy. All rights reserved.
//

#import "AIRequest+Private.h"
#import "AIConfiguration.h"
#import "AIDataService_Private.h"
#import "AIRequestEntity_Private.h"
#import "AINullabilityDefines.h"

@implementation AIRequest (Private)

- (NSDictionary *)defaultHeaders
{
    id <AIConfiguration> configuration = self.dataService.configuration;
    
    return @{
             @"Accept": @"application/json",
             @"Authorization": [NSString stringWithFormat:@"Bearer %@", configuration.clientAccessToken],
             @"ocp-apim-subscription-key": [NSString stringWithFormat:@"%@", configuration.subscriptionKey]
             };
}

- (NSDictionary *)requestBodyDictionary
{
    NSString *timeZoneString = self.timeZone ? self.timeZone.name : [NSTimeZone localTimeZone].name;
    
    NSMutableDictionary *parameters = [@{
                                         @"lang": self.lang,
                                         @"timezone": timeZoneString
                                         } mutableCopy];
    
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

    return [parameters copy];
}

- (NSMutableURLRequest *)prepareDefaultRequest
{
    id <AIConfiguration> configuration = self.dataService.configuration;
    
    NSString *version = self.version;
    
    NSString *path = @"query";
    
    if (version) {
        path = [path stringByAppendingFormat:@"?v=%@", version];
    }
    
    NSURL *URL = [configuration.baseURL URLByAppendingPathComponent:path];
    
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
        
        [contexts addObject:context];
    }];
    
    return [contexts copy];
}

@end
