/***********************************************************************************************************************
 *
 * API.AI iOS SDK - client-side libraries for API.AI
 * ==========================================
 *
 * Copyright (C) 2014 by Speaktoit, Inc. (https://www.speaktoit.com)
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

#import "AFNetworking.h"

@implementation AITextRequest

- (void)configureHTTPRequest
{
    AFHTTPRequestOperationManager *manager = self.dataService.manager;
    
    NSString *path = @"query/";
    
    NSError *error = nil;
    
    NSDictionary *parameters = @{
                                 @"query": _query
                                 };
    
    NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:@"POST"
                                                                      URLString:[[NSURL URLWithString:path relativeToURL:manager.baseURL] absoluteString]
                                                                     parameters:parameters
                                                                          error:&error];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"Bearer e43c0g5d787787d95221c9481cw8fe98" forHTTPHeaderField:@"Authorization"];
    
    __weak typeof(self) seflWeak = self;
    
    self.HTTPRequestOperation = [manager HTTPRequestOperationWithRequest:request
                                                                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                                     [seflWeak handleResponse:responseObject];
                                                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                                     [seflWeak handleError:error];
                                                                 }];
    [manager.operationQueue addOperation:_HTTPRequestOperation];
}

@end
