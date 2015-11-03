//
//  AIRequestContext.m
//  ApiAI
//
//  Created by Kuragin Dmitriy on 20/09/15.
//  Copyright © 2015 Kuragin Dmitriy. All rights reserved.
//

#import "AIRequestContext.h"

@implementation AIRequestContext

- (AI_NONNULL instancetype)initWithName:(NSString * __AI_NONNULL)name
                          andParameters:(NSDictionary AI_GENERICS_2(NSString *, id) * __AI_NULLABLE)parameters
{
    self = [super init];
    if (self) {
        _name = [name copy];
        _parameters = [parameters copy];
    }
    
    return self;
}

- (AI_NONNULL instancetype)initWithName:(NSString * __AI_NONNULL)name
                            andLifespan:(NSNumber *)lifespan
                          andParameters:(NSDictionary AI_GENERICS_2(NSString *, id) * __AI_NULLABLE)parameters
{
    self = [self initWithName:name andParameters:parameters];
    if (self) {
        _lifespan = [lifespan copy];
    }
    
    return self;
}

@end
