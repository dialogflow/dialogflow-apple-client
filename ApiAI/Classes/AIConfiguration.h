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

/*!
 
 @protocol AIConfiguration
 
 @discussion Interface for configuration ApiAI SDK.
 
 */
@protocol AIConfiguration <NSObject>

/*!
 
 @property baseURL
 
 @discussion API endpoint URL, cannot be NULL.
 
 */
@property(nonatomic, copy) NSURL *baseURL;

/*!
 
 @property clientAccessToken
 
 @discussion Client Access Token, cannot be NULL. Can get it in http://api.ai/
 
 */
@property(nonatomic, copy) NSString *clientAccessToken;

/*!
 
 @property subscriptionKey
 
 @discussion Subscription Key, cannot be NULL. Can get it in http://api.ai/
 
 */
@property(nonatomic, copy) NSString *subscriptionKey;

@end
