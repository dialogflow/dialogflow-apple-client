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

#import "AITextRequest.h"
#import "AIDataService.h"
#import "AIDataService_Private.h"
#import "AIConfiguration.h"
#import "AIRequestEntity_Private.h"
#import "AIQueryRequest+Private.h"
#import "AIRequest_Private.h"

#import "AIResponseConstants.h"

@implementation AITextRequest

- (void)configureHTTPRequest
{
    AIDataService *dataService = self.dataService;
    id <AIConfiguration> configuration = dataService.configuration;
    
    NSString *version = self.version;
    
    NSString *path = @"query";
    
    if (version) {
        path = [path stringByAppendingFormat:@"?v=%@", version];
    }
    
    NSString *timeZoneString = self.timeZone ? self.timeZone.name : [NSTimeZone localTimeZone].name;
    
    NSMutableDictionary *parameters = [@{
                                        @"query": _query,
                                        @"timezone": timeZoneString,
                                        @"lang": self.lang
                                        } mutableCopy];
    
    if (self.resetContexts) {
        parameters[@"resetContexts"] = @(YES);
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
    
    NSURL *URL = [configuration.baseURL URLByAppendingPathComponent:path];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:URL];
    
    [request setHTTPMethod:@"POST"];
    
    NSError *serializeError = nil;
    
    NSData *requestData =
    [NSJSONSerialization dataWithJSONObject:parameters
                                    options:0
                                      error:&serializeError];
    
    [request setHTTPBody:requestData];
    
    [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request setValue:[NSString stringWithFormat:@"Bearer %@", configuration.clientAccessToken]
   forHTTPHeaderField:@"Authorization"];
    
    NSURLSession *session = dataService.URLSession;
    
    __weak typeof(self) selfWeak = self;
    
    NSURLSessionDataTask *dataTask =
    [session dataTaskWithRequest:request
               completionHandler:^(NSData * __AI_NULLABLE data, NSURLResponse * __AI_NULLABLE response1, NSError * __AI_NULLABLE error) {
                   if (!error) {
                       NSHTTPURLResponse *response = (NSHTTPURLResponse *)response1;
                       if ([dataService.acceptableStatusCodes containsIndex:(NSUInteger)response.statusCode]) {
                           NSError *responseSerializeError = nil;
                           id responseData =
                           [NSJSONSerialization JSONObjectWithData:data
                                                           options:0
                                                             error:&responseSerializeError];
                           
                           if (!responseSerializeError) {
                               [self handleResponse:responseData];
                           } else {
                               [self handleError:responseSerializeError];
                           }
                           
                       } else {
                           NSError *responseStatusCodeError =
                           [NSError errorWithDomain:AIErrorDomain
                                               code:NSURLErrorBadServerResponse
                                           userInfo:@{
                                                      NSLocalizedDescriptionKey: [NSHTTPURLResponse localizedStringForStatusCode:response.statusCode]
                                                      }];
                           [selfWeak handleError:responseStatusCodeError];
                       }
                   } else {
                       [selfWeak handleError:error];
                   }
               }];
    
    self.dataTask = dataTask;

    [dataTask resume];
}

@end
