//
//  OPDataService.m
//  OpenAPI
//
//  Created by Kuragin Dmitriy on 09/06/14.
//  Copyright (c) 2014 Kuragin Dmitriy. All rights reserved.
//

#import "OPDataService.h"
#import "AFNetworking.h"

@interface OPDataService ()

@property(nonatomic, strong) NSOperationQueue *queue;

@end

@implementation OPDataService

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

- (void)enqueueRequest:(OPRequest *)request
{
    [_queue addOperation:request];
}

- (void)dequeueRequest:(OPRequest *)request
{
    [request cancel];
}

@end
