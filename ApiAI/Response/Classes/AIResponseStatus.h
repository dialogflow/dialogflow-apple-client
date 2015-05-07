//
//  AIResponseStatus.h
//  AIWrapRespProject
//
//  Created by Kuragin Dmitriy on 06/05/15.
//  Copyright (c) 2015 Kuragin Dmitriy. All rights reserved.
//

#import "AIResponseConstants.h"

@interface AIResponseStatus : NSObject

- (instancetype)init __unavailable;

@property(nonatomic, assign, readonly) NSInteger code;
@property(nonatomic, copy, readonly) NSString *errorType;

@end

@interface AIResponseStatus ()

@property(nonatomic, assign, readonly) BOOL isSuccess;
@property(nonatomic, copy, readonly) NSError *error;

@end
