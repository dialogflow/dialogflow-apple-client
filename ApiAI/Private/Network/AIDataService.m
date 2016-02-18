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

#import "AIDataService.h"
#import "AIConfiguration.h"
#import "AIDataService_Private.h"

@interface AIDataService ()

@end

@implementation AIDataService

- (instancetype)initWithConfiguration:(id <AIConfiguration>)configuration
{
    self = [super init];
    if (self) {
        self.configuration = configuration;
        
        self.URLSession = [NSURLSession sharedSession];
        self.acceptableStatusCodes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(200, 100)];
        
        self.queue = [[NSOperationQueue alloc] init];
        [_queue setSuspended:NO];
    }
    
    return self;
}

- (void)enqueueRequest:(NSOperation<AIRequest> *)request
{
    [_queue addOperation:request];
}

- (void)dequeueRequest:(NSOperation<AIRequest> *)request
{
    [request cancel];
}

@end
