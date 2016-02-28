//
//  PALoadHUD.m
//  MLPlayer
//
//  Created by BearLi on 15/9/11.
//  Copyright (c) 2015年 w. All rights reserved.
//

#import "PALoadHUD.h"

CGFloat kHUDDismissDuration = 0.15;       //消失动画时间
CGFloat kHUDScale = 0.5;                //消失缩放比例

@interface PALoadHUD ()
{
    UIView * _parentView;
    
    UIImageView * _backView;
    UIImageView * _circleImage;
    UIImageView * _loadImage;
    UILabel * _messageLabel;
}
@end

@implementation PALoadHUD

- (void)dealloc
{
    [self.layer removeAllAnimations];
}

+ (id)showLoadHUDWithMessage:(NSString*)message inView:(UIView*)view
{
    return [[[self class] alloc] initWithMessage:(NSString*)message inView:(UIView*)view];
}

- (id)initWithMessage:(NSString*)message inView:(UIView*)view
{
    self = [super init];
    if (self) {
        _message = message;
        _parentView = view;
        _dismissDelay = 0.5;

        self.frame = CGRectMake(0, 0, view.bounds.size.width, view.bounds.size.height);

        self.backgroundColor = [UIColor clearColor];
        
        CGFloat bgWidth = message.length ? BoundsOfScale(75.0) : BoundsOfScale(55.0);
        CGFloat circleWidth = message.length ? BoundsOfScale(35.0) : BoundsOfScale(30.0);
        _backView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, bgWidth, bgWidth)];
        _backView.image = [UIImage imageWithName:@"HUD_bg"];
        _backView.center = CGPointMake(self.bounds.size.width/2.0, self.bounds.size.height/2.0);
        _backView.clipsToBounds = YES;
        _backView.layer.cornerRadius = 8;
        [self addSubview:_backView];
        
        _circleImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, circleWidth, circleWidth)];
        _circleImage.image = [UIImage imageWithName:@"HUD_bird"];
        _circleImage.center = CGPointMake(CGRectGetMidX(_backView.bounds), 14+CGRectGetHeight(_circleImage.bounds)/2.0);
        [_backView addSubview:_circleImage];
        
        _loadImage = [[UIImageView alloc] initWithFrame:_circleImage.frame];
        _loadImage.image = [UIImage imageWithName:@"HUD_load"];
        [_backView addSubview:_loadImage];
        
        if (message.length > 0) {
            CGFloat labelHeight = (CGRectGetHeight(_backView.bounds) - CGRectGetMaxY(_loadImage.frame));
            
            _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(_backView.bounds) -labelHeight, CGRectGetWidth(_backView.bounds), labelHeight)];
            _messageLabel.backgroundColor = [UIColor clearColor];
            _messageLabel.textAlignment = NSTextAlignmentCenter;
            _messageLabel.font = [UIFont systemFontOfSize:FontOfScale(12)];
            _messageLabel.textColor = UIColorRGB(0xffffff);
            _messageLabel.text = message;
            
            CGSize size = [_messageLabel.text sizeWithFont:_messageLabel.font constrainedToSize:CGSizeMake(300, CGRectGetHeight(_messageLabel.bounds)) lineBreakMode:_messageLabel.lineBreakMode];
            
            if (size.width > CGRectGetHeight(_backView.bounds)) {
                CGRect frame = _messageLabel.frame;
                frame.size.width = size.width;
                _messageLabel.frame = frame;
                
                frame = _backView.frame;
                frame.size.width = _messageLabel.bounds.size.width+5;
                _backView.frame = frame;
                
                _backView.center = CGPointMake(self.bounds.size.width/2.0, self.bounds.size.height/2.0);
                _circleImage.center = CGPointMake(CGRectGetMidX(_backView.bounds), 14+CGRectGetHeight(_circleImage.bounds)/2.0);
                _loadImage.center = _circleImage.center;
                _messageLabel.center = CGPointMake(_circleImage.center.x, _messageLabel.center.y);
    
            }
            
            [_backView addSubview:_messageLabel];
        }
        else
        {
            _circleImage.center = CGPointMake(CGRectGetMidX(_backView.bounds), CGRectGetMidY(_backView.bounds));
            _loadImage.center = _circleImage.center;
        }
        
        [view addSubview:self];
        [view bringSubviewToFront:self];
        [self startAnimation];
    }
    return self;
}

- (void)startAnimation
{
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    animation.duration = 1;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.repeatCount = INT64_MAX;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [_loadImage.layer addAnimation:animation forKey:@"imageTransform"];
}

- (void)setMessage:(NSString *)message
{
    _messageLabel.text = message;
}


+ (void)hideLoadHUDFromView:(UIView*)view
{
    PALoadHUD * hud = [PALoadHUD hudForView:view];
    if (hud) {
        [hud.layer removeAllAnimations];
        [hud dismiss:YES afterTime:hud.dismissDelay];
    }
}

+ (void)hideLoadHUDFromView:(UIView*)view aniamtionWith:(BOOL)aniamtion
{
    PALoadHUD * hud = [PALoadHUD hudForView:view];
    if (hud) {
        [hud.layer removeAllAnimations];
        [hud dismiss:aniamtion afterTime:0];
    }
}

- (void)dismiss:(BOOL)aniamtion
{
    if (aniamtion) {
        [UIView animateWithDuration:kHUDDismissDuration animations:^{
            self.transform = CGAffineTransformMakeScale(kHUDScale, kHUDScale);
        } completion:^(BOOL finished) {
            self.alpha = 0.f;
            [self removeFromSuperview];
        }];
    }
    else
    {
        self.transform = CGAffineTransformMakeScale(kHUDScale, kHUDScale);
        self.alpha = 0.f;
        [self removeFromSuperview];
    }
}

- (void)dismiss:(BOOL)aniamtion afterTime:(CGFloat)delay
{
    if (aniamtion) {
        [UIView animateWithDuration:kHUDDismissDuration delay:delay options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.transform = CGAffineTransformMakeScale(kHUDScale, kHUDScale);
        } completion:^(BOOL finished) {
            self.alpha = 0.f;
            [self removeFromSuperview];
        }];
    }
    else
    {
        [UIView animateWithDuration:0 delay:delay options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        } completion:^(BOOL finished) {
            //self.transform = CGAffineTransformMakeScale(kHUDScale, kHUDScale);
            self.alpha = 0.f;
            [self removeFromSuperview];
        }];
    }
}

+ (PALoadHUD*)hudForView:(UIView*)view
{
    NSEnumerator * enumers = [view.subviews reverseObjectEnumerator];
    for (UIView * view in enumers) {
        if ([view isKindOfClass:[PALoadHUD class]]) {
            return (PALoadHUD*)view;
        }
    }
    return nil;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
