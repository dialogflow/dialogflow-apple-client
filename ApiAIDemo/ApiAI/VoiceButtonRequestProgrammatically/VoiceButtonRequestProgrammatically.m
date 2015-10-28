//
//  VoiceButtonRequestProgrammatically.m
//  ApiAIDemo
//
//  Created by Kuragin Dmitriy on 24/06/15.
//  Copyright (c) 2015 Kuragin Dmitriy. All rights reserved.
//

#import "VoiceButtonRequestProgrammatically.h"

#import <ApiAI/AIVoiceRequestButton.h>

@implementation VoiceButtonRequestProgrammatically

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    AIVoiceRequestButton *button = [[AIVoiceRequestButton alloc] init];
    
    [button setSuccessCallback:^(id response) {
        NSLog(@"%@", response);
    }];
    
    [button setFailureCallback:^(NSError *error) {
        NSLog(@"%@", error);
    }];
    
    [self.view addSubview:button];
    
    [self.view addConstraint:
    [NSLayoutConstraint constraintWithItem:button
                                 attribute:NSLayoutAttributeCenterX
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.view
                                 attribute:NSLayoutAttributeCenterX
                                multiplier:1.f
                                  constant:0.f]];
    
    [self.view addConstraint:
     [NSLayoutConstraint constraintWithItem:button
                                  attribute:NSLayoutAttributeCenterY
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.view
                                  attribute:NSLayoutAttributeCenterY
                                 multiplier:1.f
                                   constant:0.f]];
    
    [self.view setNeedsLayout];
}

@end
