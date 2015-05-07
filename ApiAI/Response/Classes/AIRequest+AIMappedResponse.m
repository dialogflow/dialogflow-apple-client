//
//  AIRequest+AIMappedResponse.m
//  ApiAI
//
//  Created by Kuragin Dmitriy on 07/05/15.
//  Copyright (c) 2015 Kuragin Dmitriy. All rights reserved.
//

#import "AIRequest+AIMappedResponse.h"
#import "AIResponse.h"

@implementation AIRequest (AIMappedResponse)

- (void)setMappedCompletionBlockSuccess:(SuccesfullResponseBlock)succesfullBlock failure:(FailureResponseBlock)failureBlock
{
    [self setCompletionBlockSuccess:^(AIRequest *request, id responseJSON) {
        AIResponse *response = [[AIResponse alloc] initWithResponse:responseJSON];
        succesfullBlock(request, response);
    } failure:^(AIRequest *request, NSError *error) {
        failureBlock(request, error);
    }];
}

@end
