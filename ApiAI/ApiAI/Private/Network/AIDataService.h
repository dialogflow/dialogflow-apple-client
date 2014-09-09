//
//  OPDataService.h
//  OpenAPI
//
//  Created by Kuragin Dmitriy on 09/06/14.
//  Copyright (c) 2014 Kuragin Dmitriy. All rights reserved.
//

#import "AIRequest.h"

@class AFHTTPRequestOperationManager;

@interface AIDataService : NSObject

@property(nonatomic, strong) AFHTTPRequestOperationManager *manager;
@property(nonatomic, copy) NSURL *baseURL;

- (void)enqueueRequest:(AIRequest *)request;
- (void)dequeueRequest:(AIRequest *)request;

@end
