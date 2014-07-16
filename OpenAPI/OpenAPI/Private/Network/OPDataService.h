//
//  OPDataService.h
//  OpenAPI
//
//  Created by Kuragin Dmitriy on 09/06/14.
//  Copyright (c) 2014 Kuragin Dmitriy. All rights reserved.
//

#import "OPRequest.h"

@class AFHTTPRequestOperationManager;

@interface OPDataService : NSObject

@property(nonatomic, strong) AFHTTPRequestOperationManager *manager;
@property(nonatomic, copy) NSURL *baseURL;

- (void)enqueueRequest:(OPRequest *)request;
- (void)dequeueRequest:(OPRequest *)request;

@end
