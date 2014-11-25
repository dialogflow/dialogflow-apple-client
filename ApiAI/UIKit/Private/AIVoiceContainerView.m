//
//  AIVoiceContainerView.m
//  MicButtonProject
//
//  Created by Kuragin Dmitriy on 19/11/14.
//  Copyright (c) 2014 Kuragin Dmitriy. All rights reserved.
//

#import "AIVoiceContainerView.h"

@implementation AIVoiceContainerView

@synthesize color=_color;

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(context);
    
    [self.color setFill];
    
    CGContextFillEllipseInRect(context, rect);
    
    CGContextRestoreGState(context);
}

- (UIColor *)color
{
    if (!_color) {
        _color = [UIColor clearColor];
    }
    
    return _color;
}

- (void)setColor:(UIColor *)color
{
    _color = color;
    [self setNeedsDisplay];
}

@end
