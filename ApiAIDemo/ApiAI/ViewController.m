/***********************************************************************************************************************
 *
 * API.AI iOS SDK - client-side libraries for API.AI
 * ==========================================
 *
 * Copyright (C) 2014 by Speaktoit, Inc. (https://www.speaktoit.com)
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

#import "ViewController.h"

#import <ApiAI/ApiAI.h>
#import <ApiAI/AITextRequest.h>
#import <ApiAI/AIVoiceRequest.h>
#import <ApiAI/AIDefaultConfiguration.h>

#import <MBProgressHUD/MBProgressHUD.h>

@interface ViewController () <UITextFieldDelegate>

@property(nonatomic, strong) ApiAI *openAPI;
@property(nonatomic, strong) AIVoiceRequest *voiceRequest;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.openAPI = [ApiAI sharedApiAI];
    
    // Define API.AI configuration here.
    id <AIConfiguration> configuration = [[AIDefaultConfiguration alloc] init];
    
    configuration.clientAccessToken = @"<#YOUR_CLIENT_ACCESS_TOKEN#>";
    configuration.subscriptionKey = @"<#YOUR_SUBSCRIPTION_KEY#>";
    
    self.openAPI.configuration = configuration;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

- (IBAction)sendTextRequest:(id)sender
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    AITextRequest *request = (AITextRequest *)[_openAPI requestWithType:AIRequestTypeText];
    request.query = @[_textField.text?:@""];
    
    [request setCompletionBlockSuccess:^(AIRequest *request, id response) {
        _textView.text = [response description];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(AIRequest *request, NSError *error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    [_openAPI enqueue:request];
}

- (IBAction)sendVoiceRequest:(id)sender
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AIVoiceRequest *request = (AIVoiceRequest *)[_openAPI requestWithType:AIRequestTypeVoice];
    
    [request setCompletionBlockSuccess:^(AIRequest *request, id response) {
        _textView.text = [response description];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(AIRequest *request, NSError *error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    
    MBProgressHUD *progressHUD =  [MBProgressHUD HUDForView:self.view];
    
    [request setSoundLevelHandleBlock:^(AIRequest *request, float level) {
        [progressHUD setLabelText:[NSString stringWithFormat:@"%.2f", level]];
    }];
    
    self.voiceRequest = request;
    [_openAPI enqueue:request];
}

@end
