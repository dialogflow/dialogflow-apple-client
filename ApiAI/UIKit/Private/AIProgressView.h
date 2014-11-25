//
//  AIProgressView.h
//  MicButtonProject
//
//  Created by Kuragin Dmitriy on 21/11/14.
//  Copyright (c) 2014 Kuragin Dmitriy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AIProgressView : UIView

@property(nonatomic, copy) UIColor *color;

- (void)startAnimating;
- (void)stopAnimating;

@end
