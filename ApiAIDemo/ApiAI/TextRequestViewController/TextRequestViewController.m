//
//  TextRequestViewController.m
//  ApiAIDemo
//
//  Created by Kuragin Dmitriy on 26/01/15.
//  Copyright (c) 2015 Kuragin Dmitriy. All rights reserved.
//

#import "TextRequestViewController.h"
#import "ResultNavigarionController.h"

#import <ApiAI/ApiAI.h>

#import <MBProgressHUD/MBProgressHUD.h>

@interface TextRequestViewController () <UITextFieldDelegate>

@end

@implementation TextRequestViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

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
    
    [request setCompletionBlockSuccess:^(AIRequest *request, id response) {
        __strong typeof(selfWeak) selfStrong = selfWeak;
        
        ResultNavigarionController *resultNavigarionController = [selfStrong.storyboard instantiateViewControllerWithIdentifier:@"ResultNavigarionController"];
        resultNavigarionController.response = response;
        
        [selfStrong presentViewController:resultNavigarionController
                                 animated:YES
                               completion:NULL];
        
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
