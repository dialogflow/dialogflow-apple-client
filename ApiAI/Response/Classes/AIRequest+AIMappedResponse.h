//
//  AIRequest+AIMappedResponse.h
//  ApiAI
//
//  Created by Kuragin Dmitriy on 07/05/15.
//  Copyright (c) 2015 Kuragin Dmitriy. All rights reserved.
//

#import "AIRequest.h"

@interface AIRequest (AIMappedResponse)

- (void)setMappedCompletionBlockSuccess:(SuccesfullResponseBlock)succesfullBlock failure:(FailureResponseBlock)failureBlock;

@end
