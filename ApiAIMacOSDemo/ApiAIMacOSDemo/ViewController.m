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
