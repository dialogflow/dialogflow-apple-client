//
//  AIResponseResult.h
//  AIWrapRespProject
//
//  Created by Kuragin Dmitriy on 06/05/15.
//  Copyright (c) 2015 Kuragin Dmitriy. All rights reserved.
//

#import "AIResponseMetadata.h"
#import "AIResponseParameter.h"
#import "AIResponseFulfillment.h"
#import "AIResponseContext.h"

@interface AIResponseResult : NSObject

- (instancetype)init __unavailable;

@property(nonatomic, copy, readonly) NSString *source;
@property(nonatomic, copy, readonly) NSString *resolvedQuery;
@property(nonatomic, copy, readonly) NSString *action;

@property(nonatomic, copy, readonly) NSDictionary *parameters;
@property(nonatomic, copy, readonly) NSArray *contexts;

@property(nonatomic, strong, readonly) AIResponseFulfillment *fulfillment;
@property(nonatomic, strong, readonly) AIResponseMetadata *metadata;

@end
