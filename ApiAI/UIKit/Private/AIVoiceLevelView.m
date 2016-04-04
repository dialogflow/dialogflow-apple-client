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
    
    UIColor *color = [UIColor colorWithRed:0.f
                                     green:0.f
                                      blue:0.f
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
