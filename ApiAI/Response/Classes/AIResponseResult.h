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

#import "AIResponseMetadata.h"
#import "AIResponseParameter.h"
#import "AIResponseFulfillment.h"
#import "AIResponseContext.h"

/**
 `AIResponseResult` is class containing result of server response.
*/

@interface AIResponseResult : NSObject

- (instancetype)init __unavailable;

/**
 Source of processing request. Can be 'agent', 'domain'
 */
@property(nonatomic, copy, readonly) NSString *source;

/**
 The query that was used to produce this result.
 */
@property(nonatomic, copy, readonly) NSString *resolvedQuery;

/**
 Action.
 */
@property(nonatomic, copy, readonly) NSString *action;

/**
 The list of parameters for the action.
 */
@property(nonatomic, copy, readonly) NSDictionary *parameters;

/**
 Array of `AIResponseContext` object.
 
 @see `AIResponseContext`
 */
@property(nonatomic, copy, readonly) NSArray *contexts;

/**
 Fulfillment.
 
 @see `AIResponseFulfillment`
 */
@property(nonatomic, strong, readonly) AIResponseFulfillment *fulfillment;

/**
 Metadata object.
 
 @see `AIResponseMetadata`
 */
@property(nonatomic, strong, readonly) AIResponseMetadata *metadata;

@end
