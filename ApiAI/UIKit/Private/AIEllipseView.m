/***********************************************************************************************************************
 *
 * API.AI iOS SDK - client-side libraries for API.AI
 * ==========================================
 *
 * Copyright (C) 2015 by Speaktoit, Inc. (https://www.speaktoit.com)
 * https://www.api.ai
 *
 ***********************************************************************************************************************
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with
 * the License. You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on
 * an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the
 * specific language governing permissions and limitations under the License.
 *
 ***********************************************************************************************************************/

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
