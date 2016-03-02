//
//  AIUserEntity.h
//  ApiAI
//
//  Created by Kuragin Dmitriy on 11/01/16.
//  Copyright © 2016 Kuragin Dmitriy. All rights reserved.
//

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
