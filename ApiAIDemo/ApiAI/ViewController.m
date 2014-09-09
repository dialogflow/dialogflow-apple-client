//
//  ViewController.m
//  OpenAPIDemo
//
//  Created by Kuragin Dmitriy on 06/06/14.
//  Copyright (c) 2014 Kuragin Dmitriy. All rights reserved.
//

#import "ViewController.h"

#import <ApiAI/AIOpenAPI.h>
#import <ApiAI/AITextRequest.h>
#import <ApiAI/AIVoiceRequest.h>

#import <MBProgressHUD/MBProgressHUD.h>

@interface ViewController () <UITextFieldDelegate>

@property(nonatomic, strong) AIOpenAPI *openAPI;
@property(nonatomic, strong) AIVoiceRequest *voiceRequest;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.openAPI = [[AIOpenAPI alloc] init];
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
    
    [request setCompletionBlockSuccess:^(AIRequest *request, id responce) {
        _textView.text = [responce description];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(AIRequest *request, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    
    [_openAPI enqueue:request];
}

- (IBAction)sendVoiceRequest:(id)sender
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AIVoiceRequest *request = (AIVoiceRequest *)[_openAPI requestWithType:AIRequestTypeVoice];
    
    [request setCompletionBlockSuccess:^(AIRequest *request, id responce) {
        _textView.text = [responce description];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(AIRequest *request, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    
    self.voiceRequest = request;
    [_openAPI enqueue:request];
}

@end
