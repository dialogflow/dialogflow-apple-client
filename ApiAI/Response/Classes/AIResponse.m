//
//  AIResponse.m
//  AIWrapRespProject
//
//  Created by Kuragin Dmitriy on 06/05/15.
//  Copyright (c) 2015 Kuragin Dmitriy. All rights reserved.
//

#import "AIResponse.h"
#import "AIResponseStatus_Private.h"
#import "AIResponseResult_Private.h"

@interface AIResponse ()

@property(nonatomic, copy) NSDictionary *response;

@end

@implementation AIResponse

- (instancetype)initWithResponse:(id)responseObject
{
    self = [super init];
    if (self) {
        self.response = responseObject;
        
        
        static NSDateFormatter *timestampDateFormatter = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
            [dateFormatter setLocale:locale];
            
            [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
            
            timestampDateFormatter = dateFormatter;
        });
        
        _identifier = _response[@"id"];
        _timestamp = [timestampDateFormatter dateFromString:_response[@"timestamp"]];
        
        _result = [[AIResponseResult alloc] initWithDictionary:_response[@"result"]];
        _status = [[AIResponseStatus alloc] initWithDictionary:_response[@"status"]];
    }
    
    return self;
}

@end
