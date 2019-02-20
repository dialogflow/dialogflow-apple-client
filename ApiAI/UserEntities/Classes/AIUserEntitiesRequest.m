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
 

#import "AIUserEntitiesRequest.h"
#import "AISessionIdentifierStorage.h"
#import "AIRequest_Private.h"
#import "AIConfiguration.h"
#import "AIDataService_Private.h"
#import "AIResponseConstants.h"

@implementation AIUserEntitiesRequest

@synthesize dataTask=_dataTask, dataService=_dataService;

- (instancetype)initWithDataService:(AIDataService *)dataService
{
    self = [super initWithDataService:dataService];
    if (self) {
        self.sessionId = [AISessionIdentifierStorage defaulSessionIdentifier];
    }
    
    return self;
}

- (void)configureHTTPRequest
{
    AIDataService *dataService = self.dataService;
    id <AIConfiguration> configuration = dataService.configuration;
    
    NSString *path = @"userEntities";
    
    NSMutableArray *serializedEntities = [NSMutableArray array];
    
    [self.entities enumerateObjectsUsingBlock:^(AIUserEntity * obj, NSUInteger idx, BOOL * stop) {
        NSMutableArray *serializedEntries = [NSMutableArray array];
        
        [obj.entries enumerateObjectsUsingBlock:^(AIRequestEntry * obj, NSUInteger idx, BOOL * stop) {
            [serializedEntries addObject:@{
                                           @"value": obj.value,
                                           @"synonyms": obj.synonyms
                                           }];
        }];
        
        NSDictionary *serializedEntity = @{
                                           @"sessionId": obj.sessionId,
                                           @"name": obj.name,
                                           @"entries": serializedEntries,
                                           @"extend": @(obj.extend)
                                           };
    
        [serializedEntities addObject:serializedEntity];
    }];
    
    NSURL *URL = [configuration.baseURL URLByAppendingPathComponent:path];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:URL];
    
    [request setHTTPMethod:@"POST"];
    
    NSError *serializeError = nil;
    
    NSData *requestData =
    [NSJSONSerialization dataWithJSONObject:serializedEntities
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
