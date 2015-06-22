//
//  AIRequestContext.h
//  ApiAI
//
//  Created by Kuragin Dmitriy on 22/05/15.
//  Copyright (c) 2015 Kuragin Dmitriy. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NullabilityDefines.h"

@interface AIRequestEntry : NSObject

@property(nonatomic, copy, readonly, nonnull) NSString *value;
@property(nonatomic, copy, readonly, nonnull) NSArray *synonyms;

- (nonnull instancetype)initWithValue:(NSString * __nonnull)value andSynonims:(NSArray * __nonnull)synonims;

@end