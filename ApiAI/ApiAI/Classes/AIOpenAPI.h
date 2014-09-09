//
//  OpenAPI.h
//  OpenAPI
//
//  Created by Kuragin Dmitriy on 06/06/14.
//  Copyright (c) 2014 Kuragin Dmitriy. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "OPConfiguration.h"
#import "AIRequest.h"

typedef NS_ENUM(NSUInteger, AIRequestType) {
    AIRequestTypeText = 0,
    AIRequestTypeVoice
};

@interface AIOpenAPI : NSObject

@property(nonatomic, strong) AIDataService *dataService;
@property(nonatomic, strong) id <AIConfiguration> configuration;

- (AIRequest *)requestWithType:(AIRequestType)requestType;
- (void)enqueue:(AIRequest *)request;

@end
