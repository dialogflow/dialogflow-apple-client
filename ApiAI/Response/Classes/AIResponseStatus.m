//
//  AIResponseStatus.m
//  AIWrapRespProject
//
//  Created by Kuragin Dmitriy on 06/05/15.
//  Copyright (c) 2015 Kuragin Dmitriy. All rights reserved.
//

#import "AIResponseStatus.h"

NSInteger const kAISuccessfullCode = 200;
NSString *const kAISuccessfullErrorType = @"success";

@implementation AIResponseStatus

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        _code = [dictionary[@"code"] integerValue];
        _errorType = [dictionary[@"errorType"] copy];
    }
    return self;
}

- (BOOL)isSuccess
{
    return _code == kAISuccessfullCode && [_errorType isEqualToString:kAISuccessfullErrorType];
}

- (NSError *)error
{
    if (!self.isSuccess) {
        NSDictionary *userInfo = @{
                                   @"code": @(_code),
                                   @"errorType": [_errorType copy],
                                   };
        
        return [NSError errorWithDomain:AIErrorDomain
                                   code:AIWrongStatusCodeErrorCode
                               userInfo:userInfo];
    }
    return nil;
}

@end
