//
//  AIUserEntitiesRequest.m
//  ApiAI
//
//  Created by Kuragin Dmitriy on 11/01/16.
//  Copyright © 2016 Kuragin Dmitriy. All rights reserved.
//

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
