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

typedef void(^SuccesfullResponseBlock)(OPRequest *request, id response);
typedef void(^FailureResponseBlock)(OPRequest *request, NSError *error);

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
@property(nonatomic, strong) id response;

- (instancetype)init __unavailable;
- (instancetype)initWithDataService:(OPDataService *)dataService;

- (void)setCompletionBlockSuccess:(SuccesfullResponseBlock)succesfullBlock failure:(FailureResponseBlock)failureBlock;

- (void)configureHTTPRequest;

- (void)handleResponse:(id)response;
- (void)handleError:(NSError *)error;

@end
