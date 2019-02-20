/**
 * Copyright 2017 Google Inc. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
 
#import "MappedResponseViewController.h"

#import <MBProgressHUD/MBProgressHUD.h>
#import <ApiAI/ApiAI.h>

@implementation MappedResponseViewController

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (IBAction)send:(id)sender
{
    [_textField resignFirstResponder];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    ApiAI *apiai = [ApiAI sharedApiAI];
    
    AITextRequest *request = [apiai textRequest];
    request.query = @[_textField.text?:@""];
    
    __weak typeof(self) selfWeak = self;
    
    [request setMappedCompletionBlockSuccess:^(AIRequest *request, AIResponse *response) {
        __strong typeof(selfWeak) selfStrong = selfWeak;
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:response.status.errorType
                                                            message:response.result.fulfillment.speech
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
        
        [MBProgressHUD hideHUDForView:selfStrong.view animated:YES];
    } failure:^(AIRequest *request, NSError *error) {
        __strong typeof(selfWeak) selfStrong = selfWeak;
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
        
        [MBProgressHUD hideHUDForView:selfStrong.view animated:YES];
    }];
    
    [apiai enqueue:request];
}

@end
