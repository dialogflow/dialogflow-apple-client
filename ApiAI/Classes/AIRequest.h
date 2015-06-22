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

#import <Foundation/Foundation.h>

#import "AIRequestEntity.h"
#import "AIRequestEntry.h"

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

/*!
 
 @property HTTPRequestOperation
 
 @discussion AFNetworking request.
 
 */
@property(nonatomic, strong) AFHTTPRequestOperation *HTTPRequestOperation;

/*!
 
 @property dataService
 
 @discussion private property, don't use it.
 
 */
@property(nonatomic, weak) AIDataService *dataService;

@end

@interface AIRequest : NSOperation <AIRequest>
{
    @protected
    AFHTTPRequestOperation *_HTTPRequestOperation;
}

/*!
 
 @property version
 
 @discussion current version of apiai, default upper version.
 
 */

@property(nonatomic, copy) NSString *version;

/*!
 
 @property contexts
 
 @discussion array of strings - List of contexts for the query that are enforced from the client. Default in nil.
 
 */
@property(nonatomic, copy) NSArray *contexts;

/*!
 
 @property entities
 
 @discussion array of entity objects - List of entities for the query that are enforced from the client. Default in nil.
 
 */
@property(nonatomic, copy) NSArray *entities;

/*!
 
 @property resetContexts
 
 @discussion Possible values: YES, NO. Add new contexts to the active contexts or forget old contexts and use only supplied with the query. Default is NO.
 
 */
@property(nonatomic, assign) BOOL resetContexts;

/*!
 
 @property sessionId
 
 @discussion A string token up to 36 symbols long, used to identify the client and to manage contexts per client. Default is md5 checksum from identifierForVendor + bundleIdentifier (maximum length 36 symbols)
 
 */
@property(nonatomic, copy) NSString *sessionId;

/*!
 
 @property lang
 
 @discussion Language of current client. Default is ApiAI lang propery.
 
 */
@property(nonatomic, copy) NSString *lang;

/*!
 
 @property timeZone
 
 @discussion Current timezone. Default system timetoze.
 
 */
@property(nonatomic, copy) NSTimeZone *timeZone;

/*!
 
 @property error
 
 @discussion Contain error (optional) after getting response
 
 */
@property(nonatomic, copy) NSError *error;

/*!
 
 @property response
 
 @discussion Contain server response.
 
 */
@property(nonatomic, strong) id response;

/**
 Set completion handlers.
 @param success A block object to be executed when the task finishes successfully.
 @param failure A block object to be executed when the task finishes unsuccessfully, or that finishes successfully, but encountered an error while parsing the response data.
 */
- (void)setCompletionBlockSuccess:(SuccesfullResponseBlock)succesfullBlock failure:(FailureResponseBlock)failureBlock;

/* private methods */

- (instancetype)init __unavailable;
- (instancetype)initWithDataService:(AIDataService *)dataService;

- (void)configureHTTPRequest;

- (void)handleResponse:(id)response;
- (void)handleError:(NSError *)error;

@end
