//
//  OpenAPI.m
//  OpenAPI
//
//  Created by Kuragin Dmitriy on 06/06/14.
//  Copyright (c) 2014 Kuragin Dmitriy. All rights reserved.
//

#import "AIOpenAPI.h"
#import "AIDataService.h"
#import "AITextRequest.h"
#import "AIVoiceRequest.h"

@interface AIOpenAPI ()

@end

@implementation AIOpenAPI

- (id)init
{
    self = [super init];
    if (self) {
        self.dataService = [[AIDataService alloc] init];
    }
    
    return self;
}

- (AIRequest *)requestWithType:(AIRequestType)requestType
{
    if (requestType == AIRequestTypeText) {
        return [[AITextRequest alloc] initWithDataService:_dataService];
    } else {
        return [[AIVoiceRequest alloc] initWithDataService:_dataService];
    }
    
    return nil;
}

- (void)enqueue:(AIRequest *)request
{
    [_dataService enqueueRequest:request];
}

@end
