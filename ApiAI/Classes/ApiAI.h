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

#import "CWLSynthesizeSingleton.h"

#import "AIConfiguration.h"
#import "AIRequest.h"



/*!
 
 @enum AIRequestType enum
 
 @discussion Requst type (Voice or Text).
 
 */
typedef NS_ENUM(NSUInteger, AIRequestType) {
    /*! Simple text request type */
    AIRequestTypeText,
    /*! Voice request type with VAD(Voice activity detection) for detect end of phrase. */
    AIRequestTypeVoice = 1
};

/*!
 
 @class ApiAI
 
 @discussion ApiAI endpoint for ApiAi SDK
 */
@interface ApiAI : NSObject

CWL_DECLARE_SINGLETON_FOR_CLASS(ApiAI);

@property(nonatomic, copy) NSString *lang;

/*!
 
 @property ApiAI enum
 
 @discussion configuration property, cannot be NULL.
 
 */
@property(nonatomic, strong) id <AIConfiguration> configuration;

/*!
 
 @method requestWithType
 
 @discussion return request object with used type (@see AIRequestType).
 @return
 
 */
- (AIRequest *)requestWithType:(AIRequestType)requestType;

/*!
 
 @method enqueue
 
 @discussion using this method for send request.
 
 */
- (void)enqueue:(AIRequest *)request;

@end