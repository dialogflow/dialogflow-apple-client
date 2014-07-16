//
//  OpenAPI.h
//  OpenAPI
//
//  Created by Kuragin Dmitriy on 06/06/14.
//  Copyright (c) 2014 Kuragin Dmitriy. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "OPConfiguration.h"
#import "OPRequest.h"

typedef NS_ENUM(NSUInteger, OPRequestType) {
    OPRequestTypeText = 0,
    OPRequestTypeVoice
};

@interface OPOpenAPI : NSObject

@property(nonatomic, strong) OPDataService *dataService;
@property(nonatomic, strong) id <OPConfiguration> configuration;

- (OPRequest *)requestWithType:(OPRequestType)requestType;
- (void)enqueue:(OPRequest *)request;

@end
