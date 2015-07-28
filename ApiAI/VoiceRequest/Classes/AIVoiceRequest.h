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
#import "AIRequest.h"

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

@interface AIVoiceRequest : AIRequest

/*!
 
 @property soundLevelHandleBlock
 
 @discussion Sound level handler. Default is nil.
 
 */
@property(nonatomic, copy) SoundLevelHandleBlock soundLevelHandleBlock;

/*!
 
 @property soundRecordBeginBlock
 
 @discussion Record begin handler. Default is nil.
 
 */
@property(nonatomic, copy) SoundRecordBeginBlock soundRecordBeginBlock;

/*!
 
 @property soundRecordEndBlock
 
 @discussion Record end handler. Default is nil.
 
 */
@property(nonatomic, copy) SoundRecordEndBlock soundRecordEndBlock;

/*!
 
 @property useVADForAutoCommit
 
 @discussion Use Voice Activity Detection for detect end of speech. Default is YES.
 
 */
@property(nonatomic, assign) BOOL useVADForAutoCommit;

/*!
 * Manually stop listening and send request to server.
 */
- (void)commitVoice;

@end
