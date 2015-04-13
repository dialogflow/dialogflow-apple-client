//
//  AIWatchKitTextRequest.m
//  WatchKitExample
//
//  Created by Kuragin Dmitriy on 10/04/15.
//  Copyright (c) 2015 Kuragin Dmitriy. All rights reserved.
//

#import "AIWatchKitTextRequest.h"

@implementation AIWatchKitTextRequest

- (NSDictionary *)userInfoForRequest
{
    NSDictionary *userInfo = @{
                               @"apiai": @(YES),
                               @"query": self.query ?: @""
                               };
    
    return userInfo;
}

@end
