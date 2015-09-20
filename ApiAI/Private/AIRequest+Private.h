//
//  AIRequest+Private.h
//  ApiAI
//
//  Created by Kuragin Dmitriy on 28/07/15.
//  Copyright © 2015 Kuragin Dmitriy. All rights reserved.
//

#import "AIRequest.h"

@interface AIRequest (Private)

- (NSDictionary *)defaultHeaders;
- (NSDictionary *)requestBodyDictionary;

- (NSMutableURLRequest *)prepareDefaultRequest;

- (NSArray *)contextsRequestPresentation;

@end
