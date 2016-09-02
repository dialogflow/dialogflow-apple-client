//
//  AIRequest+Private.h
//  ApiAI
//
//  Created by Kuragin Dmitriy on 28/07/15.
//  Copyright © 2015 Kuragin Dmitriy. All rights reserved.
//

#import "AIQueryRequest.h"

@interface AIQueryRequest (Private)

- (NSDictionary *)defaultHeaders;
- (NSDictionary *)requestBodyDictionary;

- (NSDictionary *)getQueryParameters;

- (NSMutableURLRequest *)prepareDefaultRequest;

- (NSArray *)contextsRequestPresentation;

@end
