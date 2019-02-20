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

#import "AIRequestEntry.h"
#import "AINullabilityDefines.h"

@interface AIUserEntity : NSObject

@property(nonatomic, copy,                AI_NONNULL) NSString *sessionId;
@property(nonatomic, copy,      readonly, AI_NONNULL) NSString *name;
@property(nonatomic, copy,      readonly, AI_NONNULL) NSArray AI_GENERICS_1(AIRequestEntry *) *entries;
@property(nonatomic, assign,    readonly            ) BOOL extend;

- (AI_NONNULL instancetype)initWithName:(NSString * __AI_NONNULL)name
                             andEntries:(NSArray AI_GENERICS_1(AIRequestEntry *) * __AI_NONNULL)entries
                              andExtend:(BOOL)extend;

@end
