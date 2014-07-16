//
//  OpenAPI.m
//  OpenAPI
//
//  Created by Kuragin Dmitriy on 06/06/14.
//  Copyright (c) 2014 Kuragin Dmitriy. All rights reserved.
//

#import "OPOpenAPI.h"
#import "OPDataService.h"
#import "OPTextRequest.h"
#import "OPVoiceRequest.h"

@interface OPOpenAPI ()

@end

@implementation OPOpenAPI

- (id)init
{
    self = [super init];
    if (self) {
        self.dataService = [[OPDataService alloc] init];
    }
    
    return self;
}

- (OPRequest *)requestWithType:(OPRequestType)requestType
{
    if (requestType == OPRequestTypeText) {
        return [[OPTextRequest alloc] initWithDataService:_dataService];
    } else {
        return [[OPVoiceRequest alloc] initWithDataService:_dataService];
    }
    
    return nil;
}

- (void)enqueue:(OPRequest *)request
{
    [_dataService enqueueRequest:request];
}

@end
