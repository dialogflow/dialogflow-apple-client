//
//  ViewController.m
//  OpenAPIDemo
//
//  Created by Kuragin Dmitriy on 06/06/14.
//  Copyright (c) 2014 Kuragin Dmitriy. All rights reserved.
//

#import "ViewController.h"

#import <OpenAPI/OPOpenAPI.h>
#import <OpenAPI/OPTextRequest.h>
#import <OpenAPI/OPVoiceRequest.h>

#import <MBProgressHUD/MBProgressHUD.h>

@interface ViewController () <UITextFieldDelegate>

@property(nonatomic, strong) OPOpenAPI *openAPI;
@property(nonatomic, strong) OPVoiceRequest *voiceRequest;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.openAPI = [[OPOpenAPI alloc] init];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

- (IBAction)sendTextRequest:(id)sender
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    OPTextRequest *request = (OPTextRequest *)[_openAPI requestWithType:OPRequestTypeText];
    request.query = @[_textField.text?:@""];
    
    [request setCompletionBlockSuccess:^(OPRequest *request, id responce) {
        _textView.text = [responce description];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(OPRequest *request, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    
    [_openAPI enqueue:request];
}

- (IBAction)sendVoiceRequest:(id)sender
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    OPVoiceRequest *request = (OPVoiceRequest *)[_openAPI requestWithType:OPRequestTypeVoice];
    
    [request setCompletionBlockSuccess:^(OPRequest *request, id responce) {
        _textView.text = [responce description];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(OPRequest *request, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    
    self.voiceRequest = request;
    [_openAPI enqueue:request];
}

@end
