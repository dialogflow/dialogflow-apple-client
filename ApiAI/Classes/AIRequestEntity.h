//
//  AIRequestEntity.h
//  ApiAI
//
//  Created by Kuragin Dmitriy on 22/05/15.
//  Copyright (c) 2015 Kuragin Dmitriy. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AIRequestEntry.h"

#import "AINullabilityDefines.h"

@interface AIRequestEntity : NSObject

@property(nonatomic, copy, readonly, AI_NONNULL) NSString *name;
@property(nonatomic, copy, readonly, AI_NONNULL) NSArray AI_GENERICS_1(AIRequestEntry *) *entries;

- (AI_NONNULL instancetype)initWithName:(NSString * __AI_NONNULL)name
                             andEntries:(NSArray AI_GENERICS_1(AIRequestEntry *) * __AI_NONNULL)entries;

@end
