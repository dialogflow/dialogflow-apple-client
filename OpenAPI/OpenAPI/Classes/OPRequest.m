//
//  OPRequest.m
//  OpenAPI
//
//  Created by Kuragin Dmitriy on 20/06/14.
//  Copyright (c) 2014 Kuragin Dmitriy. All rights reserved.
//

#import "OPRequest.h"
#import "OPDataService.h"
#import "AFNetworking.h"

@interface OPRequest ()

@property(nonatomic, assign) BOOL finished;

@end

@implementation OPRequest

@synthesize HTTPRequestOperation=_HTTPRequestOperation, dataService=_dataService;

- (instancetype)initWithDataService:(OPDataService *)dataService
{
    self = [super init];
    if (self) {
        self.dataService = dataService;
    }
    
    return self;
}

- (void)start
{
    [self configureHTTPRequest];
    [super start];
}

- (void)configureHTTPRequest
{
    
}

- (void)setCompletionBlockSuccess:(SuccesfullResponceBlock)succesfullBlock failure:(FailureResponceBlock)failureBlock
{
    __weak typeof(self) weakSelf = self;
    [self setCompletionBlock:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (weakSelf.error) {
            if (failureBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    failureBlock(strongSelf, strongSelf.error);
                });
            }
        } else {
            if (succesfullBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    succesfullBlock(strongSelf, strongSelf.responce);
                });
            }
        }
    }];
}

- (BOOL)isFinished
{
    return _finished;
}

- (void)handleResponce:(id)responce
{
    [self willChangeValueForKey:@"isFinished"];
    
    self.responce = responce;
    self.finished = YES;
    
    [self didChangeValueForKey:@"isFinished"];
}

- (void)handleError:(NSError *)error
{
    [self willChangeValueForKey:@"isFinished"];
    
    self.error = error;
    self.finished = YES;
    
    [self didChangeValueForKey:@"isFinished"];
}

- (void)cancel
{
    [self cancelHTTPRequest];
    [super cancel];
}

- (void)cancelHTTPRequest
{
    [self.HTTPRequestOperation cancel];
}

- (void)dealloc
{
    NSLog(@"Deallocating");
}

@end
