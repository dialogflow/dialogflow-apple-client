//
//  ResultViewController.m
//  ApiAIDemo
//
//  Created by Kuragin Dmitriy on 26/01/15.
//  Copyright (c) 2015 Kuragin Dmitriy. All rights reserved.
//

#import "ResultViewController.h"

@interface ResultViewController ()

@end

@implementation ResultViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _textView.text = [_response description];
}

- (IBAction)done:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
