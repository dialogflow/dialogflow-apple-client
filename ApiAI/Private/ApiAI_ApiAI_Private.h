//
//  ApiAI_ApiAI_Private.h
//  ApiAI
//
//  Created by Kuragin Dmitriy on 13/09/14.
//  Copyright (c) 2014 Kuragin Dmitriy. All rights reserved.
//

#import "ApiAI.h"

@class AIDataService;
@protocol AIConfiguration;

@interface ApiAI ()

@property(nonatomic, strong) AIDataService *dataService;

@end