//
//  AIVoiceLevelView.m
//  MicButtonProject
//
//  Created by Kuragin Dmitriy on 19/11/14.
//  Copyright (c) 2014 Kuragin Dmitriy. All rights reserved.
//

#import "AIVoiceLevelView.h"

@interface AIVoiceLevelLayer : CALayer

@property(nonatomic, assign) float level;

@end

@implementation AIVoiceLevelLayer

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.level = 1.f;
    }
    
    return self;
}

+ (BOOL)needsDisplayForKey:(NSString *)key
{
    if ([key isEqualToString:@"level"]) {
        return YES;
    }
    
    return [super needsDisplayForKey:key];
}

- (void)drawInContext:(CGContextRef)context
{
    CGRect rect = self.bounds;
    
    CGContextSaveGState(context);
    
    CGFloat minRadius = (rect.size.width / 2.f) / 3.f;
    CGFloat maxRadius = rect.size.width / 2.f;
    
    UIColor *color = [UIColor colorWithRed:1.f
                                     green:1.f
                                      blue:1.f
                                     alpha:0.16f];
    
    CGContextSetFillColorWithColor(context, color.CGColor);
    
    float radius = minRadius + (maxRadius - minRadius) * _level;
    
    CGContextFillEllipseInRect(context, CGRectMake(rect.size.width / 2.f - radius, rect.size.height / 2.f - radius, radius * 2.f, radius * 2.f));
    
    CGContextRestoreGState(context);
}

@end

@implementation AIVoiceLevelView

+ (Class)layerClass
{
    return [AIVoiceLevelLayer class];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setLevel:(float)level
{
    _level = level;
    
    AIVoiceLevelLayer *layer = (AIVoiceLevelLayer *)self.layer;

    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"level"];
    animation.duration = 0.2f;
    animation.fromValue = @(layer.level);
    animation.toValue = @(level);
    
    layer.level = level;

    animation.fillMode = kCAFillModeBoth;
    animation.removedOnCompletion = YES;

    [layer removeAllAnimations];

    [layer addAnimation:animation forKey:@"animatePercentage"];
}

@end
