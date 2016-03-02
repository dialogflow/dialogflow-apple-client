//
//  AIUserEntity.m
//  ApiAI
//
//  Created by Kuragin Dmitriy on 11/01/16.
//  Copyright © 2016 Kuragin Dmitriy. All rights reserved.
//

#import "AIUserEntity.h"
#import "AIUserEntity_Private.h"
#import "AISessionIdentifierStorage.h"

@implementation AIUserEntity

- (AI_NONNULL instancetype)initWithName:(NSString * __AI_NONNULL)name
                             andEntries:(NSArray AI_GENERICS_1(AIRequestEntry *) * __AI_NONNULL)entries
                              andExtend:(BOOL)extend
{
    self = [super init];

    if (self) {
        _sessionId = [AISessionIdentifierStorage defaulSessionIdentifier];
        _name = name;
        _entries = entries;
        _extend = extend;
    }
    
    return self;
}

@end
