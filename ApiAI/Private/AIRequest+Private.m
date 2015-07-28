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
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:self.timeZone];
    [dateFormatter setDateFormat:@"Z"];
    
    NSString *timeZoneString = [dateFormatter stringFromDate:[NSDate date]];
    
    NSMutableDictionary *parameters = [@{
                                         @"lang": self.lang,
                                         @"timezone": timeZoneString
                                         } mutableCopy];
    
    if (self.resetContexts) {
        parameters[@"resetContexts"] = @(self.resetContexts);
    }
    
    if ([self.contexts count]) {
        parameters[@"contexts"] = self.contexts;
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
    
    NSURL *URL = [NSURL URLWithString:path relativeToURL:configuration.baseURL];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:URL];
    
    [request setHTTPMethod:@"POST"];
    
    [request setAllHTTPHeaderFields:self.defaultHeaders];
    
    return request;
}

@end
