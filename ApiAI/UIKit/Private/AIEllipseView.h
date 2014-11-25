//
//  AIEllipseView.h
//  MicButtonProject
//
//  Created by Kuragin Dmitriy on 21/11/14.
//  Copyright (c) 2014 Kuragin Dmitriy. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface AIEllipseView : UIView

@property(nonatomic, copy) IBInspectable UIColor *color;
@property(nonatomic, assign) CGFloat radius;

- (void)setRadius:(CGFloat)radius animated:(BOOL)animated;

@end
