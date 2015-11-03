//
//  AIRequestContext.h
//  ApiAI
//
//  Created by Kuragin Dmitriy on 20/09/15.
//  Copyright © 2015 Kuragin Dmitriy. All rights reserved.
//

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
