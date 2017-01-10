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

#import "AIConfiguration.h"
#import "AIRequest.h"
#import "AITextRequest.h"
#import "AIDefaultConfiguration.h"

#if __has_include("AIVoiceRequestButton.h")
    #import "AIVoiceRequestButton.h"
#endif

#if __has_include("AIResponse.h")
    #import "AIResponse.h"
#endif

#if __has_include("AIVoiceRequest.h")
    #import "AIVoiceRequest.h"

    #if defined(TARGET_OS_IOS) || defined(TARGET_OS_MAC)
        #define AI_SUPPORT_VOICE_REQUEST (TARGET_OS_IOS || TARGET_OS_MAC)
    #else
        //Enable support voice request for XCode older than 7.x version
        #define AI_SUPPORT_VOICE_REQUEST 1
    #endif
#else
    #define AI_SUPPORT_VOICE_REQUEST 0
#endif

#if __has_include("AIVoiceFileRequest.h")
    #import "AIVoiceFileRequest.h"
#endif

#if __has_include("AIUserEntitiesRequest.h")
    #import "AIUserEntitiesRequest.h"
#endif

#if __has_include("AIEventRequest.h")
    #import "AIEventRequest.h"
#endif

/*!
 
 @enum AIRequestType enum
 
 @discussion Requst type (Voice or Text).
 
 */
typedef NS_ENUM(NSUInteger, AIRequestType) {
    /*! Simple text request type */
    AIRequestTypeText,
    /*! Voice request type with VAD(Voice activity detection) for detect end of phrase. */
    AIRequestTypeVoice DEPRECATED_MSG_ATTRIBUTE("Use :voiceRequest or :textRequest methods") = 1
};

/*!
 
 @class ApiAI
 
 @discussion ApiAI endpoint for ApiAi SDK
 */
@interface ApiAI : NSObject

+ (instancetype)sharedApiAI;

+ (NSArray *)supportedLanguages;

/*!
 
 @property lang language
 
 @discussion configuration language, default using first system ([NSLocale preferredLanguages]) 
 cantaining in [ApiAI supportedLanguages]. Can be:
                             @"en",
                             @"es",
                             @"ru",
                             @"de",
                             @"pt",
                             @"pt-BR",
                             @"es",
                             @"fr",
                             @"it",
                             @"ja",
                             @"ko",
                             @"zh-CN",
                             @"zh-HK",
                             @"zh-TW",
 */

@property(nonatomic, copy) NSString *lang;

/*!
 
 @property version string
 
 @discussion configuration version property, default use latest version, not recommended use it.
 
 */

@property(nonatomic, copy) NSString *version;

/*!
 
 @property ApiAI enum
 
 @discussion configuration property, cannot be NULL.
 
 */
@property(nonatomic, strong) id <AIConfiguration> configuration;

/*!
 
 @method requestWithType
 
 @discussion return request object with used type (@see AIRequestType).
 @return
 
 @deprecated This method will be remove in future version. Please use :voiceRequest and :textRequest.
 
 */

- (AIRequest *)requestWithType:(AIRequestType)requestType DEPRECATED_MSG_ATTRIBUTE("Use :voiceRequest or :textRequest methods");

#if AI_SUPPORT_VOICE_REQUEST
/*!
 API.AI speech recognition is going to be deprecated soon.
 Use Google Cloud Speech API or other solutions.
 
 This is request type available only for old paid plans.
 It doesn't working for new users.
 
 Will be removed on 1 Feb 2016.
 */
- (AIVoiceRequest *)voiceRequest AI_DEPRECATED_MSG_ATTRIBUTE("Will be removed on 1 Feb 2016.");
#endif

#if __has_include("AITextRequest.h")
- (AITextRequest *)textRequest;
#endif

#if __has_include("AIUserEntitiesRequest.h")
- (AIUserEntitiesRequest *)userEntitiesRequest;
#endif


#if __has_include("AIVoiceFileRequest.h")
/*!
 API.AI speech recognition is going to be deprecated soon.
 Use Google Cloud Speech API or other solutions.
 
 This is request type available only for old paid plans.
 It doesn't working for new users.
 
 Will be removed on 1 Feb 2016.
 */
- (AIVoiceFileRequest *)voiceFileRequestWithFileURL:(NSURL *)fileURL AI_DEPRECATED_MSG_ATTRIBUTE("Will be removed on 1 Feb 2016.");
- (AIVoiceFileRequest *)voiceFileRequestWithStream:(NSInputStream *)inputStream AI_DEPRECATED_MSG_ATTRIBUTE("Will be removed on 1 Feb 2016.");
- (AIVoiceFileRequest *)voiceFileRequestWithData:(NSData *)fileData AI_DEPRECATED_MSG_ATTRIBUTE("Will be removed on 1 Feb 2016.");
#endif

#if __has_include("AIEventRequest.h")
- (AIEventRequest *)eventRequest;
#endif

/*!
 
 @method enqueue
 
 @discussion using this method for send request.
 
 */
- (void)enqueue:(NSOperation<AIRequest> *)request;

/*!
 
 @method cancellAllRequests
 
 @discussion using this method for cancell all performing requests.
 
 */

- (void)cancellAllRequests;

@end
