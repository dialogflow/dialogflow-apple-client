//
//  OPRequest.h
//  OpenAPI
//
//  Created by Kuragin Dmitriy on 20/06/14.
//  Copyright (c) 2014 Kuragin Dmitriy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OPDataService;
@class AFHTTPRequestOperation;
@class OPRequest;

typedef void(^SuccesfullResponceBlock)(OPRequest *request, id responce);
typedef void(^FailureResponceBlock)(OPRequest *request, NSError *error);

@protocol OPRequest <NSObject>

@property(nonatomic, strong) AFHTTPRequestOperation *HTTPRequestOperation;
@property(nonatomic, weak) OPDataService *dataService;

@end

@interface OPRequest : NSOperation <OPRequest>
{
    @protected
    AFHTTPRequestOperation *_HTTPRequestOperation;
}

@property(nonatomic, copy) NSError *error;
@property(nonatomic, strong) id responce;

- (instancetype)init __unavailable;
- (instancetype)initWithDataService:(OPDataService *)dataService;

- (void)setCompletionBlockSuccess:(SuccesfullResponceBlock)succesfullBlock failure:(FailureResponceBlock)failureBlock;

- (void)configureHTTPRequest;

- (void)handleResponce:(id)responce;
- (void)handleError:(NSError *)error;

@end
