//
//  OPDataService.m
//  OpenAPI
//
//  Created by Kuragin Dmitriy on 09/06/14.
//  Copyright (c) 2014 Kuragin Dmitriy. All rights reserved.
//

#import "AIDataService.h"
#import "AFNetworking.h"

@interface AIDataService ()

@property(nonatomic, strong) NSOperationQueue *queue;

@end

@implementation AIDataService

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.baseURL = [NSURL URLWithString:@"https://dev.api.ai/api/"];
        self.manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:_baseURL];
        self.manager.requestSerializer = [AFJSONRequestSerializer serializerWithWritingOptions:0];
        
        self.queue = [[NSOperationQueue alloc] init];
        [_queue setSuspended:NO];
    }
    
    return self;
}

- (void)enqueueRequest:(AIRequest *)request
{
    [_queue addOperation:request];
}

- (void)dequeueRequest:(AIRequest *)request
{
    [request cancel];
}

@end
