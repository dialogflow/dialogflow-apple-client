//
//  AIVoiceRequestButton.m
//  MicButtonProject
//
//  Created by Kuragin Dmitriy on 19/11/14.
//  Copyright (c) 2014 Kuragin Dmitriy. All rights reserved.
//

#import "AIVoiceRequestButton.h"
#import "AIVoiceLevelView.h"
#import "AIVoiceContainerView.h"
#import "AIEllipseView.h"
#import "AIProgressView.h"

#import "ApiAI.h"
#import "AIVoiceRequest.h"

#import <CoreGraphics/CoreGraphics.h>

@interface AIVoiceRequestButton()

@property(nonatomic, weak) IBOutlet UIButton *button;

@property(nonatomic, weak) IBOutlet AIEllipseView *ellipseView;

@property(nonatomic, weak) IBOutlet AIVoiceLevelView *levelView;
@property(nonatomic, weak) IBOutlet AIVoiceContainerView *containerView;

@property(nonatomic, weak) IBOutlet AIProgressView *progressView;

@property(nonatomic, weak) IBOutlet AIVoiceRequest *request;

@property(nonatomic, strong) UIImage *defaultStateNormalImage;
@property(nonatomic, strong) UIImage *defaultStateHighlightedImage;

@property(nonatomic, strong) UIImage *sendingStateNormalImage;
@property(nonatomic, strong) UIImage *sendingStateHighlightedImage;

@end

@implementation AIVoiceRequestButton

@synthesize color=_color, iconColor=_iconColor;

- (IBAction)clicked:(id)sender
{
    if (self.request && ![self.request isFinished]) {
        [self.request cancel];
    } else {
        AIEllipseView *ellipseView = _ellipseView;
        AIVoiceLevelView *levelView = _levelView;
        AIProgressView *progressView = _progressView;
        
        progressView.color = self.color;
        ellipseView.color = self.color;
        
        
        [levelView setHidden:NO];
        
        
        
        AIVoiceRequest *request = (AIVoiceRequest *)[[ApiAI sharedApiAI] requestWithType:AIRequestTypeVoice];
        
        __weak typeof(self) selfWeak = self;
        
        __block float prevValue = 0.f;
        
        [request setSoundLevelHandleBlock:^(AIRequest *request, float level) {
            float prepared = MIN(level * 2.f, 1.f);
            prepared = MAX(prevValue * 0.96f, prepared);
            
            prevValue = prepared;
            selfWeak.levelView.level = prepared;
        }];
        
        [request setSoundRecordBeginBlock:^(AIRequest *request){
            
        }];
        
        [request setSoundRecordEndBlock:^(AIRequest *request){
            [UIView transitionWithView:self.containerView
                              duration:0.2f
                               options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionTransitionFlipFromLeft
                            animations:^{
                                [selfWeak setupSendingButtonImages];
                            } completion:^(BOOL finished) {
                                
                            }];
            [selfWeak setupSendingButtonImages];
            [levelView setHidden:YES];
            [progressView startAnimating];
        }];
        
        [request setCompletionBlockSuccess:^(AIRequest *request, id response) {
            if (selfWeak.successCallback) {
                selfWeak.successCallback(response);
            }
            
            [self restoreStateAnimated];
        } failure:^(AIRequest *request, NSError *error) {
            if (selfWeak.failureCallback) {
                selfWeak.failureCallback(error);
            }
            
            [self restoreStateAnimated];
        }];
        
        self.request = request;
        
        [[ApiAI sharedApiAI] enqueue:request];
        
        [ellipseView setRadius:1.f animated:YES];
    }
}

- (void)restoreStateAnimated
{
    AIEllipseView *ellipseView = _ellipseView;
    AIVoiceLevelView *levelView = _levelView;
    AIProgressView *progressView = _progressView;
    
    [ellipseView setRadius:0.f animated:NO];
    
    [UIView transitionWithView:self.containerView
                      duration:0.2f
                       options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionTransitionFlipFromRight
                    animations:^{
                        [levelView setHidden:YES];
                        [levelView setLevel:0.f];
                        
                        [self setupDefaultButtonImages];
                        [progressView stopAnimating];
                    } completion:^(BOOL finished) {
                        
                    }];
}

- (void)setColor:(UIColor *)color
{
    _color = color;
    
    _progressView.color = _color;
    
    [self updateButtonImages];
    [self setupDefaultButtonImages];
}

- (UIColor *)color
{
    if (!_color) {
        _color = [UIColor orangeColor];
        _progressView.color = _color;
    }
    return _color;
}

- (void)setIconColor:(UIColor *)iconColor
{
    _iconColor = iconColor;
    
    [self updateButtonImages];
    [self setupDefaultButtonImages];
}

- (UIColor *)iconColor
{
    if (!_iconColor) {
        _iconColor = [UIColor whiteColor];
    }
    
    return _iconColor;
}

- (void)updateButtonImages
{
    UIImage *originalMicImage = [UIImage imageNamed:@"AIMicrophoneControlImage"];
    
    UIImage *overlayMicIconImage = [self image:originalMicImage withColor:self.iconColor];
    UIImage *overlayMicImage = [self image:originalMicImage withColor:self.color];
    
    self.defaultStateNormalImage = overlayMicIconImage;
    self.defaultStateHighlightedImage = overlayMicImage;
    
    UIImage *originalBoxImage = [UIImage imageNamed:@"AICubeIconImage"];
    
    UIImage *overlayBoxIconImage = [self image:originalBoxImage withColor:self.iconColor];
    UIImage *overlayBoxImage = [self image:originalBoxImage withColor:self.color];
    
    self.sendingStateNormalImage = overlayBoxIconImage;
    self.sendingStateHighlightedImage = overlayBoxImage;
}

- (void)setupDefaultButtonImages
{
    [_button setImage:self.defaultStateNormalImage forState:UIControlStateNormal];
    [_button setImage:self.defaultStateHighlightedImage forState:UIControlStateHighlighted];
}

- (void)setupSendingButtonImages
{
    [_button setImage:self.sendingStateNormalImage forState:UIControlStateNormal];
    [_button setImage:self.sendingStateHighlightedImage forState:UIControlStateHighlighted];
}

- (UIImage *)image:(UIImage *)img withColor:(UIColor *)color
{
    UIGraphicsBeginImageContextWithOptions(img.size, NO, img.scale);
    
    CGRect bounds = CGRectMake(0.f, 0.f, img.size.width, img.size.height);
    [color set];
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(context, 0, img.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGContextClipToMask(context, bounds, [img CGImage]);
    CGContextFillRect(context, bounds);

    UIImage *coloredImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return coloredImg;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        NSMutableArray *constraits = [NSMutableArray array];
        
        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        
        UIView *view = [[bundle loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] firstObject];
        NSDictionary *views = NSDictionaryOfVariableBindings(view);
        
        [self addSubview:view];
        
        [constraits addObjectsFromArray:
         [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[view]-0-|"
                                                 options:0
                                                 metrics:nil
                                                   views:views]];
        
        [constraits addObjectsFromArray:
         [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[view]-0-|"
                                                 options:0
                                                 metrics:nil
                                                   views:views]];
        
        [self addConstraints:constraits];
        
        self.backgroundColor = [UIColor clearColor];
        
        [self updateButtonImages];
        [self setupDefaultButtonImages];
    }
    return self;
}

@end
