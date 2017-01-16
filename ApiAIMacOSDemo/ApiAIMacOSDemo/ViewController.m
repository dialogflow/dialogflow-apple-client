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

@property(nonatomic, weak) IBOutlet NSButton *sendButton;
@property(nonatomic, weak) IBOutlet NSTextField *textField;
@property(nonatomic, weak) IBOutlet NSProgressIndicator *progress;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)sendRequest:(id)sender
{
    [_sendButton setEnabled:NO];
    [_textField setEnabled:NO];
    
    [_progress startAnimation:self];
    
    
    AITextRequest *request = [[ApiAI sharedApiAI] textRequest];
    request.query = @[
                      [_textField stringValue] ?: @""
                      ];
    
    _textField.stringValue = @"";
    
    __weak typeof(self) selfWeak = self;
    
    [request setCompletionBlockSuccess:^(AIRequest *request, id response) {
        typeof(selfWeak) sself = selfWeak;
        
        NSAlert *alert = [[NSAlert alloc] init];
        
        alert.informativeText = [NSString stringWithFormat:@"%@", response];
        [alert setAlertStyle:NSInformationalAlertStyle];
        [alert runModal];
        
        [sself.progress stopAnimation:sself];
        
        [_sendButton setEnabled:YES];
        [_textField setEnabled:YES];
    } failure:^(AIRequest *request, NSError *error) {
        typeof(selfWeak) sself = selfWeak;
        
        NSAlert *alert = [[NSAlert alloc] init];
        
        alert.informativeText = [NSString stringWithFormat:@"%@", error.localizedDescription];
        [alert setAlertStyle:NSInformationalAlertStyle];
        [alert runModal];
        
        [sself.progress stopAnimation:sself];
        
        [_sendButton setEnabled:YES];
        [_textField setEnabled:YES];
    }];
    
    [[ApiAI sharedApiAI] enqueue:request];
}

@end
