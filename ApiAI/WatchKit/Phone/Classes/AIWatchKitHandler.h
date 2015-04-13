//
//  AIWatchKitHandler.h
//  WatchKitExample
//
//  Created by Kuragin Dmitriy on 10/04/15.
//  Copyright (c) 2015 Kuragin Dmitriy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AIWatchKitHandler : NSObject

+ (BOOL)handleWatchKitRequest:(NSDictionary *)userInfo andReply:(void(^)(NSDictionary *replyInfo))reply;

@end
