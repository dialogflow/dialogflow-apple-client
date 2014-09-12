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
