//
//  MappedResponseViewController.m
//  ApiAIDemo
//
//  Created by Kuragin Dmitriy on 07/05/15.
//  Copyright (c) 2015 Kuragin Dmitriy. All rights reserved.
//

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
    
    AITextRequest *request = (AITextRequest *)[apiai requestWithType:AIRequestTypeText];
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
