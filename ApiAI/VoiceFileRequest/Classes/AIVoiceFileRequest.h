/**
 * Copyright 2017 Google Inc. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
 
#import "AIQueryRequest.h"

/*!
 API.AI speech recognition is going to be deprecated soon.
 Use Google Cloud Speech API or other solutions.
 
 This is request type available only for old paid plans.
 It doesn't working for new users.
 
 Will be removed on 1 Feb 2016.
 */
AI_DEPRECATED_MSG_ATTRIBUTE("Will be removed on 1 Feb 2016.")
@interface AIVoiceFileRequest : AIQueryRequest

@property(nonatomic, copy) NSString *contentType AI_DEPRECATED_ATTRIBUTE;

@end
