//
//  AIDataService_Private.h
//  ApiAI
//
//  Created by Kuragin Dmitriy on 13/09/14.
//  Copyright (c) 2014 Kuragin Dmitriy. All rights reserved.
//

#import "AIDataService.h"

@class AFHTTPRequestOperationManager;
@protocol AIConfiguration;

@interface AIDataService ()

@property(nonatomic, strong) AFHTTPRequestOperationManager *manager;
@property(nonatomic, strong) id <AIConfiguration> configuration;

@end
