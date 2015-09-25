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

@property(nonatomic, strong) AIVoiceRequest *request;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)startListening:(id)sender
{
    AIVoiceRequest *request = [[ApiAI sharedApiAI] voiceRequest];
    
    [request setCompletionBlockSuccess:^(AIRequest *request, id response) {
        NSLog(@"");
    } failure:^(AIRequest *request, NSError *error) {
        NSLog(@"");
    }];
    
    self.request = request;
    
    [[ApiAI sharedApiAI] enqueue:request];
}

- (IBAction)stopListening:(id)sender
{
    [self.request commitVoice];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

@end
