//
//  ViewController.m
//  ApiAIMacOSDemo
//
//  Created by Kuragin Dmitriy on 25/09/15.
//  Copyright © 2015 Kuragin Dmitriy. All rights reserved.
//

#import "ViewController.h"

#import <ApiAI/ApiAI.h>

@interface ViewController ()

@property(nonatomic, weak) IBOutlet NSButton *button;
@property(nonatomic, strong) AIVoiceRequest *request;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)startListening:(id)sender
{
    self.button.enabled = NO;
    AIVoiceRequest *request = [[ApiAI sharedApiAI] voiceRequest];
    
    __weak typeof(self) selfWeak = self;
    
    [request setCompletionBlockSuccess:^(AIRequest *request, id response) {
        selfWeak.button.enabled = YES;
        
        NSAlert *alert = [[NSAlert alloc] init];
        
        alert.informativeText = [NSString stringWithFormat:@"%@", response];
        [alert setAlertStyle:NSInformationalAlertStyle];
        [alert runModal];
        
    } failure:^(AIRequest *request, NSError *error) {
        selfWeak.button.enabled = YES;
    }];
    
    self.request = request;
    
    [[ApiAI sharedApiAI] enqueue:request];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

@end
