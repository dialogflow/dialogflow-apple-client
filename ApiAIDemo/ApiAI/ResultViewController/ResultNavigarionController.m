//
//  ResultNavigarionController.m
//  ApiAIDemo
//
//  Created by Kuragin Dmitriy on 26/01/15.
//  Copyright (c) 2015 Kuragin Dmitriy. All rights reserved.
//

#import "ResultNavigarionController.h"
#import "ResultViewController.h"

@interface ResultNavigarionController ()

@end

@implementation ResultNavigarionController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    ResultViewController *resultViewController = [self.viewControllers firstObject];
    resultViewController.response = _response;
}

@end
