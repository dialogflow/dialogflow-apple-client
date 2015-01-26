//
//  AIVoiceRequestButton.h
//  MicButtonProject
//
//  Created by Kuragin Dmitriy on 19/11/14.
//  Copyright (c) 2014 Kuragin Dmitriy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AIVoiceRequestButtonSuccess)(id response);
typedef void(^AIVoiceRequestButtonFailure)(NSError *error);

//IB_DESIGNABLE
@interface AIVoiceRequestButton : UIControl

@property(nonatomic, copy) IBInspectable UIColor *color;
@property(nonatomic, copy) IBInspectable UIColor *iconColor;

@property(nonatomic ,copy) AIVoiceRequestButtonSuccess successCallback;
@property(nonatomic ,copy) AIVoiceRequestButtonFailure failureCallback;

@end
