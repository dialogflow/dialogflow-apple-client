//
//  AIWatchKitRequest.h
//  WatchKitExample
//
//  Created by Kuragin Dmitriy on 10/04/15.
//  Copyright (c) 2015 Kuragin Dmitriy. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^AIWatchKitRequestSuccesfull)(id response);
typedef void(^AIWatchKitRequestFailur)(NSError *respose);

@interface AIWatchKitRequest : NSObject

@property(nonatomic, copy) AIWatchKitRequestSuccesfull succesfull;
- (void)setSuccesfull:(AIWatchKitRequestSuccesfull)succesfull;

@property(nonatomic, copy) AIWatchKitRequestFailur failure;
- (void)setFailure:(AIWatchKitRequestFailur)failure;

- (void)setCompletionWithSuccesfull:(AIWatchKitRequestSuccesfull)succesfull
                         andFailure:(AIWatchKitRequestFailur)failure;

- (void)runWithCompletionWithSuccesfull:(AIWatchKitRequestSuccesfull)succesfull
                             andFailure:(AIWatchKitRequestFailur)failure;

- (void)run;

- (NSDictionary *)userInfoForRequest;

@end
