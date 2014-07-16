//
//  OPVoiceRequest.h
//  OpenAPI
//
//  Created by Kuragin Dmitriy on 25/06/14.
//  Copyright (c) 2014 Kuragin Dmitriy. All rights reserved.
//

#import "OPRequest.h"

@interface OPVoiceRequest : OPRequest

@property(nonatomic, assign) BOOL useVADForAutoCommit;

- (void)commitVoice;

@end
