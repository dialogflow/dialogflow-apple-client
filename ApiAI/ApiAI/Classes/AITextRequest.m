//
//  OPTextRequest.m
//  OpenAPI
//
//  Created by Kuragin Dmitriy on 24/06/14.
//  Copyright (c) 2014 Kuragin Dmitriy. All rights reserved.
//

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
                                                                     [seflWeak handleResponce:responseObject];
                                                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                                     [seflWeak handleError:error];
                                                                 }];
    [manager.operationQueue addOperation:_HTTPRequestOperation];
}

@end
