//
//  AIEllipseView.m
//  MicButtonProject
//
//  Created by Kuragin Dmitriy on 21/11/14.
//  Copyright (c) 2014 Kuragin Dmitriy. All rights reserved.
//

#import "AIEllipseView.h"

@interface AIEllipseLayer : CALayer

@property(nonatomic, copy) UIColor *color;
@property(nonatomic, assign) CGFloat radius;

@end

@implementation AIEllipseLayer

- (instancetype)initWithLayer:(AIEllipseLayer *)layer
{
    self = [super initWithLayer:layer];
    if (self) {
        self.color = layer.color;
    }
    
    return self;
}

- (UIColor *)color
{
    if (!_color) {
        _color = [UIColor orangeColor];
    }
    
    return _color;
}

+ (BOOL)needsDisplayForKey:(NSString *)key
{
    if ([key isEqualToString:@"radius"]) {
        return YES;
    }
    
    return [super needsDisplayForKey:key];
}

- (void)drawInContext:(CGContextRef)context
{
    CGRect rect = CGContextGetClipBoundingBox(context);
    
    UIColor *color = self.color;
    
    CGContextSaveGState(context);
    
    CGContextSetFillColorWithColor(context, color.CGColor);
    
    CGPoint center = (CGPoint){.x = rect.size.width / 2.f, .y = rect.size.height / 2.f};
    CGFloat radius = _radius * MIN(center.x, center.y);
    
    CGContextFillEllipseInRect(context, CGRectMake(center.x - radius, center.y - radius, radius * 2.f, radius * 2.f));
    
    CGContextRestoreGState(context);
}

@end

@interface AIEllipseView ()

@end

@implementation AIEllipseView

@synthesize color=_color;

- (void)awakeFromNib
{
    self.layer.contentsScale = [UIScreen mainScreen].scale;
}

+ (Class)layerClass
{
    return [AIEllipseLayer class];
}

- (void)setColor:(UIColor *)color
{
    _color = color;
    
    AIEllipseLayer *layer = (AIEllipseLayer *)self.layer;
    [layer setColor:_color];
    
    [layer setNeedsDisplay];
}

- (void)setRadius:(CGFloat)radius
{
    [self setRadius:radius animated:NO];
}

- (void)setRadius:(CGFloat)radius animated:(BOOL)animated
{
    _radius = radius;
    
    AIEllipseLayer *layer = (AIEllipseLayer *)self.layer;
    
    
    if (animated) {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"radius"];
        animation.duration = .4f;
        animation.fromValue = @(layer.radius);
        animation.toValue = @(radius);
        
        layer.radius = radius;
        
        animation.fillMode = kCAFillModeBoth;
        animation.removedOnCompletion = YES;
        
        [layer removeAllAnimations];
        
        [layer addAnimation:animation forKey:@"animatePercentage"];
    } else {
        [layer removeAllAnimations];
        layer.radius = radius;
        [layer setNeedsDisplay];
    }
}

@end
