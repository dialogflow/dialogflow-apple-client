//
//  SendFileViewController.m
//  ApiAIDemo
//
//  Created by Kuragin Dmitriy on 30/07/15.
//  Copyright © 2015 Kuragin Dmitriy. All rights reserved.
//

#import "SendFileViewController.h"
#import <ApiAI/ApiAI.h>
#import <MBProgressHUD/MBProgressHUD.h>

#import "ResultNavigarionController.h"

@implementation SendFileViewController

- (IBAction)send:(id)sender
{
    MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSURL *fileURL = [[NSBundle bundleForClass:[self class]] URLForResource:@"ann_smith" withExtension:@"wav"];
    
    ApiAI *apiai = [ApiAI sharedApiAI];
    
    AIVoiceFileRequest *request = [apiai voiceFileRequestWithFileURL:fileURL];
    
    __weak typeof(self) selfWeak = self;
    
    [request setCompletionBlockSuccess:^(AIRequest *request, id response) {
        __strong typeof(selfWeak) selfStrong = selfWeak;
        
        ResultNavigarionController *resultNavigarionController = [selfStrong.storyboard instantiateViewControllerWithIdentifier:@"ResultNavigarionController"];
        resultNavigarionController.response = response;
        
        [selfStrong presentViewController:resultNavigarionController
                                 animated:YES
                               completion:NULL];
        
        [progressHUD hide:YES];
    } failure:^(AIRequest *request, NSError *error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
        
        [progressHUD hide:YES];
    }];
    
    [apiai enqueue:request];
}

@end
