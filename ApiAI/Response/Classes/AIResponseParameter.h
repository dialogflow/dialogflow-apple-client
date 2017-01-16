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
 Representation of parameter.
 */

@interface AIResponseParameter : NSObject

- (instancetype)init __unavailable;

/**
 Return string presentation of parameter value.
 */
@property(nonatomic, copy, readonly) NSString *stringValue;

/**
 Return number presentation of parameter value.
 */
@property(nonatomic, copy, readonly) NSNumber *numberValue;

/**
 Return Date Period presentation of parameter value. Can be nil or array of 2 dates.
 */
@property(nonatomic, copy, readonly) NSArray AI_GENERICS_1(NSDate *) *datePeriodValue;

/**
 Return Date presentation of parameter value. Can be nil or date objects.
 */
@property(nonatomic, copy, readonly) NSDate *dateValue;

/**
 Return list presentation of parameter value. Can be nil or array of `AIResponseParameter` objects.
 */
@property(nonatomic, copy, readonly) NSArray AI_GENERICS_1(AIResponseParameter *) *listValue;

/**
 Return compiste presentation of parameter value. Can be nil or dictionary with `AIResponseParameter` objects.
 */
@property(nonatomic, copy, readonly) NSDictionary AI_GENERICS_2(NSString *, AIResponseParameter *) *compositeValue;

/**
 Return raw presentation of parameter value. Can be nil or any type object. 
 This is value like JSON serialized field. Can be string, object, array, null
 */
@property(nonatomic, copy, readonly) id <NSObject> rawValue;

@end
