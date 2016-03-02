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

#import "AIRequest.h"
#import "AIDataService.h"
#import "AISessionIdentifierStorage.h"
#import "AIRequest_Private.h"

@interface AIRequest ()

@property(nonatomic, assign) BOOL finished;

@end

@implementation AIRequest

@synthesize finished=_finished, dataTask=_dataTask;

@synthesize dataService=_dataService;

- (instancetype)initWithDataService:(AIDataService *)dataService
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

- (void)setCompletionBlockSuccess:(SuccesfullResponseBlock)succesfullBlock failure:(FailureResponseBlock)failureBlock
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
                    succesfullBlock(strongSelf, strongSelf.response);
                });
            }
        }
    }];
}

- (BOOL)isFinished
{
    return _finished;
}

- (void)handleResponse:(id)response
{
    [self willChangeValueForKey:@"isFinished"];
    
    self.response = response;
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
    [self.dataTask cancel];
}

@end
