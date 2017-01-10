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
#import "AIQueryRequest.h"

/*!
 * Sound level handler definition for AIVoiceRequest.
 *
 * @param request The request called handler.
 * @param level Noise level in range from 0 to 1.
 */
typedef void(^SoundLevelHandleBlock)(AIRequest *request, float level);

/*!
 * Record begin handler definition for AIVoiceRequest.
 *
 * @param request The request called handler.
 */
typedef void(^SoundRecordBeginBlock)(AIRequest *request);

/*!
 * Record end handler definition for AIVoiceRequest.
 *
 * @param request The request called handler.
 */
typedef void(^SoundRecordEndBlock)(AIRequest *request);

/*!
 API.AI speech recognition is going to be deprecated soon.
 Use Google Cloud Speech API or other solutions.
 
 This is request type available only for old paid plans.
 It doesn't working for new users.
 
 Will be removed on 1 Feb 2016.
 */
AI_DEPRECATED_MSG_ATTRIBUTE("Will be removed on 1 Feb 2016.")
@interface AIVoiceRequest : AIQueryRequest

/*!
 
 @property soundLevelHandleBlock
 
 @discussion Sound level handler. Default is nil.
 */
@property(nonatomic, copy) SoundLevelHandleBlock soundLevelHandleBlock AI_DEPRECATED_ATTRIBUTE;

/*!
 
 @property soundRecordBeginBlock
 
 @discussion Record begin handler. Default is nil.
 
 */
@property(nonatomic, copy) SoundRecordBeginBlock soundRecordBeginBlock AI_DEPRECATED_ATTRIBUTE;

/*!
 
 @property soundRecordEndBlock
 
 @discussion Record end handler. Default is nil.
 
 */
@property(nonatomic, copy) SoundRecordEndBlock soundRecordEndBlock AI_DEPRECATED_ATTRIBUTE;

/*!
 
 @property useVADForAutoCommit
 
 @discussion Use Voice Activity Detection for detect end of speech. Default is YES.
 
 */
@property(nonatomic, assign) BOOL useVADForAutoCommit AI_DEPRECATED_ATTRIBUTE;

/*!
 * Manually stop listening and send request to server.
 */
- (void)commitVoice AI_DEPRECATED_ATTRIBUTE;

@end
