//
//  OPVoiceRequest.h
//  OpenAPI
//
//  Created by Kuragin Dmitriy on 25/06/14.
//  Copyright (c) 2014 Kuragin Dmitriy. All rights reserved.
//

#import "AIRequest.h"

@interface AIVoiceRequest : AIRequest

@property(nonatomic, assign) BOOL useVADForAutoCommit;

- (void)commitVoice;

@end
