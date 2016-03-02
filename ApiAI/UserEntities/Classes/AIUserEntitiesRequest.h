//
//  AIUserEntitiesRequest.h
//  ApiAI
//
//  Created by Kuragin Dmitriy on 11/01/16.
//  Copyright © 2016 Kuragin Dmitriy. All rights reserved.
//

#import "AIRequest.h"
#import "AIUserEntity.h"

@interface AIUserEntitiesRequest : AIRequest

@property(nonatomic, copy) NSString *sessionId;
@property(nonatomic, strong) NSArray AI_GENERICS_1(AIUserEntity *) *entities;

@end
