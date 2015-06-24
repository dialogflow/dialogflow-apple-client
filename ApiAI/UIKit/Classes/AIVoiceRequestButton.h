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

#import <UIKit/UIKit.h>

typedef void(^AIVoiceRequestButtonSuccess)(id response);
typedef void(^AIVoiceRequestButtonFailure)(NSError *error);

//IB_DESIGNABLE
@interface AIVoiceRequestButton : UIControl

@property(nonatomic, copy) IBInspectable UIColor *color;
@property(nonatomic, copy) IBInspectable UIColor *iconColor;

@property(nonatomic ,copy) AIVoiceRequestButtonSuccess successCallback;
-(void)setSuccessCallback:(AIVoiceRequestButtonSuccess)successCallback;

@property(nonatomic ,copy) AIVoiceRequestButtonFailure failureCallback;
-(void)setFailureCallback:(AIVoiceRequestButtonFailure)failureCallback;

@end
