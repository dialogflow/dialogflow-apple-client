//
//  AIResponse.h
//  AIWrapRespProject
//
//  Created by Kuragin Dmitriy on 06/05/15.
//  Copyright (c) 2015 Kuragin Dmitriy. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AIRequest+AIMappedResponse.h"

#import "AIResponseStatus.h"
#import "AIResponseResult.h"

@interface AIResponse : NSObject

- (instancetype)init __unavailable;
- (instancetype)initWithResponse:(id)responseObject;

@property(nonatomic, copy, readonly) NSString *identifier;
@property(nonatomic, copy, readonly) NSDate *timestamp;

@property(nonatomic, strong, readonly) AIResponseStatus *status;
@property(nonatomic, strong, readonly) AIResponseResult *result;

@end
