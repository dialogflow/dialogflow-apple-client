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

#import <Foundation/Foundation.h>

@class AIDataService;
@class AFHTTPRequestOperation;
@class AIRequest;

/*!
 * Succesfull handler definition for AIRequest.
 *
 * @param request The request called handler.
 * @param response Server responce (Serialized JSON).
 */
typedef void(^SuccesfullResponseBlock)(AIRequest *request, id response);

/*!
 * Failure handler definition for AIRequest.
 *
 * @param request The request called handler.
 * @param response Server responce (Serialized JSON).
 */
typedef void(^FailureResponseBlock)(AIRequest *request, NSError *error);

@protocol AIRequest <NSObject>

@property(nonatomic, strong) AFHTTPRequestOperation *HTTPRequestOperation;
@property(nonatomic, weak) AIDataService *dataService;

@end

@interface AIRequest : NSOperation <AIRequest>
{
    @protected
    AFHTTPRequestOperation *_HTTPRequestOperation;
}

@property(nonatomic, copy) NSString *version;

@property(nonatomic, copy) NSArray *contexts; // default in nil
@property(nonatomic, assign) BOOL resetContexts; //default is no

@property(nonatomic, copy) NSString *sessionId; //default is md5 checksum from identifierForVendor + bundleIdentifier (maximum length 36 symbols)

@property(nonatomic, copy) NSString *lang; //default is ApiAI lang propery

@property(nonatomic, copy) NSTimeZone *timeZone; // default 

@property(nonatomic, copy) NSError *error;
@property(nonatomic, strong) id response;

- (instancetype)init __unavailable;
- (instancetype)initWithDataService:(AIDataService *)dataService;

- (void)setCompletionBlockSuccess:(SuccesfullResponseBlock)succesfullBlock failure:(FailureResponseBlock)failureBlock;

- (void)configureHTTPRequest;

- (void)handleResponse:(id)response;
- (void)handleError:(NSError *)error;

@end
