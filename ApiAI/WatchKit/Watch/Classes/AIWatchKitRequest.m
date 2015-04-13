//
//  AIWatchKitRequest.m
//  WatchKitExample
//
//  Created by Kuragin Dmitriy on 10/04/15.
//  Copyright (c) 2015 Kuragin Dmitriy. All rights reserved.
//

#import "AIWatchKitRequest.h"
#import <WatchKit/WatchKit.h>

@implementation AIWatchKitRequest

- (void)setCompletionWithSuccesfull:(AIWatchKitRequestSuccesfull)succesfull
                         andFailure:(AIWatchKitRequestFailur)failure
{
    self.succesfull = succesfull;
    self.failure = failure;
}

- (void)runWithCompletionWithSuccesfull:(AIWatchKitRequestSuccesfull)succesfull andFailure:(AIWatchKitRequestFailur)failure
{
    [self setCompletionWithSuccesfull:succesfull andFailure:failure];
    [self run];
}

- (NSDictionary *)userInfoForRequest
{
    assert(false);
    return nil;
}

- (void)run
{
    NSDictionary *userInfo = [self userInfoForRequest];
    
    [WKInterfaceController openParentApplication:userInfo
                                           reply:^(NSDictionary *replyInfo, NSError *error) {
                                               if (error && self.failure) {
                                                   self.failure(error);
                                               } else {
                                                   NSDictionary *response = replyInfo[@"response"];
                                                   if (response) {
                                                       self.succesfull(response);
                                                   } else {
                                                       NSError *replyError = replyInfo[@"error"];
                                                       self.failure(replyError);
                                                   }
                                               }
                                           }];
}

@end
