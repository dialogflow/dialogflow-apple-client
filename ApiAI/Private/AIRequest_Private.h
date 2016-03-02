//
//  AIRequest_Private.h
//  ApiAI
//
//  Created by Kuragin Dmitriy on 02/03/16.
//  Copyright © 2016 Kuragin Dmitriy. All rights reserved.
//

#import "AIRequest.h"

@interface AIRequest ()

- (instancetype)initWithDataService:(AIDataService *)dataService;

- (void)configureHTTPRequest;

- (void)handleResponse:(id)response;
- (void)handleError:(NSError *)error;

@end
