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

#import "AIResponseConstants.h"

@interface AIResponseStatus : NSObject

- (instancetype)init __unavailable;

/**
 HTTP Status Code.
 */
@property(nonatomic, assign, readonly) NSInteger code;

/**
 String representation of error.
 */
@property(nonatomic, copy, readonly) NSString *errorType;

@end

@interface AIResponseStatus ()

///---------------------------
/// @name Helper methods
///---------------------------

/**
 Validate response and return status of validation.
*/
@property(nonatomic, assign, readonly) BOOL isSuccess;

/**
 Optionally. Not nil if error response validation or server error.
 */
@property(nonatomic, copy, readonly) NSError *error;

@end
