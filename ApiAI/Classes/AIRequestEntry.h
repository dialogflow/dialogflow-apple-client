//
//  AIRequestContext.h
//  ApiAI
//
//  Created by Kuragin Dmitriy on 22/05/15.
//  Copyright (c) 2015 Kuragin Dmitriy. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AINullabilityDefines.h"

@interface AIRequestEntry : NSObject

@property(nonatomic, copy, readonly, AI_NONNULL) NSString *value;
@property(nonatomic, copy, readonly, AI_NONNULL) NSArray AI_GENERICS_1(NSString *) *synonyms;

- (AI_NONNULL instancetype)initWithValue:(NSString * __AI_NONNULL)value
                             andSynonims:(NSArray AI_GENERICS_1(NSString *) * __AI_NONNULL)synonims;

@end