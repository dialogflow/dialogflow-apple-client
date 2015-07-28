/***********************************************************************************************************************
 *
 * API.AI iOS SDK - client-side libraries for API.AI
 * ==========================================
 *
 * Copyright (C) 2015 by Speaktoit, Inc. (https://www.speaktoit.com)
 * https://www.api.ai
 *
 ***********************************************************************************************************************
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with
 * the License. You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on
 * an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the
 * specific language governing permissions and limitations under the License.
 *
 ***********************************************************************************************************************/

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
    
    AIVoiceRequest *request = [apiai voiceRequest];
    
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
