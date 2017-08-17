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
 
#import <Foundation/Foundation.h>

#import "AINullabilityDefines.h"

@interface AIRequestContext : NSObject

@property(nonatomic, copy, readonly, AI_NONNULL) NSString *name;
@property(nonatomic, copy, readonly, AI_NULLABLE) NSDictionary AI_GENERICS_2(NSString *, id) *parameters;

@property(nonatomic, copy, readonly, AI_NULLABLE) NSNumber *lifespan;

- (AI_NONNULL instancetype)initWithName:(NSString * __AI_NONNULL)name
                          andParameters:(NSDictionary AI_GENERICS_2(NSString *, id) * __AI_NULLABLE)parameters;

- (AI_NONNULL instancetype)initWithName:(NSString * __AI_NONNULL)name
                            andLifespan:(NSNumber * __AI_NULLABLE)lifespan
                          andParameters:(NSDictionary AI_GENERICS_2(NSString *, id) * __AI_NULLABLE)parameters;

@end
