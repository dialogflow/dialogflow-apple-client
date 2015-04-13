//
//  AIWatchKitHandler.m
//  WatchKitExample
//
//  Created by Kuragin Dmitriy on 10/04/15.
//  Copyright (c) 2015 Kuragin Dmitriy. All rights reserved.
//

#import "AIWatchKitHandler.h"

#import <ApiAI/ApiAI.h>

@implementation AIWatchKitHandler

+ (BOOL)handleWatchKitRequest:(NSDictionary *)userInfo andReply:(void(^)(NSDictionary *replyInfo))reply
{
    NSNumber *apiaiFlag = userInfo[@"apiai"];
    if (apiaiFlag && [apiaiFlag boolValue]) {
        ApiAI *apiai = [ApiAI sharedApiAI];
        
        AITextRequest *textRequest = (AITextRequest *)[apiai requestWithType:AIRequestTypeText];
        
        textRequest.query = userInfo[@"query"];
        
        [textRequest setCompletionBlockSuccess:^(AIRequest *request, id response) {
            reply(
                  @{
                    @"response": response,
                    }
                  );
        } failure:^(AIRequest *request, NSError *error) {
            reply(
                  @{
                    @"error": error,
                    }
                  );
        }];
        
        [apiai enqueue:textRequest];
        
        return YES;
    }
    
    return NO;
}

@end
