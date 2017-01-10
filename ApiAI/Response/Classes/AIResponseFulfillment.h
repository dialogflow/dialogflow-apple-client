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
#import "AINullabilityDefines.h"

/**
 Fulfillment
 */

@interface AIResponseFulfillment : NSObject

- (instancetype)init __unavailable;

/**
 Response speech.
 */
@property(nonatomic, copy, readonly) NSString *speech AI_DEPRECATED_MSG_ATTRIBUTE("Use messages property.");

/**
 Response messages. See https://docs.api.ai/docs/rich-messages for details.
 */
@property(nonatomic, copy, readonly) NSArray AI_GENERICS_1(NSDictionary *) *messages;

@end
