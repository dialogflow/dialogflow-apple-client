//
//  VoiceButtonViewController.m
//  ApiAIDemo
//
//  Created by Kuragin Dmitriy on 26/01/15.
//  Copyright (c) 2015 Kuragin Dmitriy. All rights reserved.
//

#import "VoiceButtonViewController.h"
#import "ResultNavigarionController.h"

@interface VoiceButtonViewController ()

@end

@implementation VoiceButtonViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    __weak typeof(self) selfWeak = self;
    
    [_voiceRequestButton setSuccessCallback:^(id response) {
        __strong typeof(selfWeak) selfStrong = selfWeak;
        
        ResultNavigarionController *resultNavigarionController = [selfStrong.storyboard instantiateViewControllerWithIdentifier:@"ResultNavigarionController"];
        resultNavigarionController.response = response;
        
        [selfStrong presentViewController:resultNavigarionController
                                 animated:YES
                               completion:NULL];
    }];
    
    [_voiceRequestButton setFailureCallback:^(NSError *error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Dismiss"
                                                  otherButtonTitles:nil];
        [alertView show];
    }];
    
}

@end
