//
//  AIDefaultConfiguration.m
//  ApiAI
//
//  Created by Kuragin Dmitriy on 14/11/14.
//  Copyright (c) 2014 Kuragin Dmitriy. All rights reserved.
//

#import "AIDefaultConfiguration.h"

@implementation AIDefaultConfiguration

@synthesize baseURL=_baseURL, clientAccessToken=_clientAccessToken, subscriptionKey=_subscriptionKey;

- (NSURL *)baseURL
{
    if (!_baseURL) {
        _baseURL = [NSURL URLWithString:@"https://api.api.ai/v1/"];
    }
    
    return _baseURL;
}

@end
