//
//  OPRequest.h
//  OpenAPI
//
//  Created by Kuragin Dmitriy on 20/06/14.
//  Copyright (c) 2014 Kuragin Dmitriy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AIDataService;
@class AFHTTPRequestOperation;
@class AIRequest;

typedef void(^SuccesfullResponceBlock)(AIRequest *request, id responce);
typedef void(^FailureResponceBlock)(AIRequest *request, NSError *error);

@protocol AIRequest <NSObject>

@property(nonatomic, strong) AFHTTPRequestOperation *HTTPRequestOperation;
@property(nonatomic, weak) AIDataService *dataService;

@end

@interface AIRequest : NSOperation <AIRequest>
{
    @protected
    AFHTTPRequestOperation *_HTTPRequestOperation;
}

@property(nonatomic, copy) NSError *error;
@property(nonatomic, strong) id responce;

- (instancetype)init __unavailable;
- (instancetype)initWithDataService:(AIDataService *)dataService;

- (void)setCompletionBlockSuccess:(SuccesfullResponceBlock)succesfullBlock failure:(FailureResponceBlock)failureBlock;

- (void)configureHTTPRequest;

- (void)handleResponce:(id)responce;
- (void)handleError:(NSError *)error;

@end
