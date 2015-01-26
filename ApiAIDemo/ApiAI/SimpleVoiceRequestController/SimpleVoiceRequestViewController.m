//
//  SimpleVoiceRequestViewController.m
//  ApiAIDemo
//
//  Created by Kuragin Dmitriy on 26/01/15.
//  Copyright (c) 2015 Kuragin Dmitriy. All rights reserved.
//

#import "SimpleVoiceRequestViewController.h"
#import "ResultNavigarionController.h"

#import <ApiAI/ApiAI.h>

@interface SimpleVoiceRequestViewController ()

@property(nonatomic, strong) AIVoiceRequest *currentVoiceRequest;

@end

@implementation SimpleVoiceRequestViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self changeStateToStop];
}

- (IBAction)startListening:(id)sender
{
    [self changeStateToListening];
    
    ApiAI *apiai = [ApiAI sharedApiAI];
    
    AIVoiceRequest *request = (AIVoiceRequest *)[apiai requestWithType:AIRequestTypeVoice];
    
    __weak typeof(self) selfWeak = self;
    
    [request setCompletionBlockSuccess:^(AIRequest *request, id response) {
        __strong typeof(selfWeak) selfStrong = selfWeak;
        
        ResultNavigarionController *resultNavigarionController = [selfStrong.storyboard instantiateViewControllerWithIdentifier:@"ResultNavigarionController"];
        resultNavigarionController.response = response;
        
        [selfStrong presentViewController:resultNavigarionController
                                 animated:YES
                               completion:NULL];
        
        [selfStrong changeStateToStop];
    } failure:^(AIRequest *request, NSError *error) {
        __strong typeof(selfWeak) selfStrong = selfWeak;
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
        
        [selfStrong changeStateToStop];
    }];
    
    self.currentVoiceRequest = request;
    [apiai enqueue:request];
}

- (void)changeStateToListening
{
    [_activity startAnimating];
    
    [_startListeningButton setEnabled:NO];
    [_stopListeningButton setEnabled:YES];
    [_useVAD setEnabled:NO];
}

- (void)changeStateToStop
{
    [_activity stopAnimating];
    
    [_startListeningButton setEnabled:YES];
    [_stopListeningButton setEnabled:NO];
    
    [_useVAD setEnabled:YES];
}

- (IBAction)stopListening:(id)sender
{
    [self changeStateToStop];
    
    [_currentVoiceRequest commitVoice];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [_currentVoiceRequest cancel];
}

@end
