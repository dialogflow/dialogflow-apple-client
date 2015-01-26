//
//  SimpleVoiceRequestViewController.h
//  ApiAIDemo
//
//  Created by Kuragin Dmitriy on 26/01/15.
//  Copyright (c) 2015 Kuragin Dmitriy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SimpleVoiceRequestViewController : UIViewController

@property(nonatomic, weak) IBOutlet UISwitch *useVAD;
@property(nonatomic, weak) IBOutlet UIButton *startListeningButton;
@property(nonatomic, weak) IBOutlet UIButton *stopListeningButton;

@property(nonatomic, weak) IBOutlet UIActivityIndicatorView *activity;

@end
