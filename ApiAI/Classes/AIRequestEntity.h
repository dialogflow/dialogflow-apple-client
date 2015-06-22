//
//  AIRequestEntity.h
//  ApiAI
//
//  Created by Kuragin Dmitriy on 22/05/15.
//  Copyright (c) 2015 Kuragin Dmitriy. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AIRequestEntry.h"

#import "NullabilityDefines.h"

@interface AIRequestEntity : NSObject

@property(nonatomic, copy, readonly, nonnull) NSString *name;
@property(nonatomic, copy, readonly, nonnull) NSArray *entries;

- (nonnull instancetype)initWithName:(NSString * __nonnull)name
                          andEntries:(NSArray * __nonnull)entries;

@end
