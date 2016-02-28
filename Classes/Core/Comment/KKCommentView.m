//
//  KKCommentView.m
//  KaiKaiBa
//
//  Created by lishaowei on 15/9/26.
//  Copyright © 2015年 battery. All rights reserved.
//

#import "KKCommentView.h"

@interface KKCommentView ()
{
    UIButton *_sendButton;
}

@end

@implementation KKCommentView

- (instancetype)init
{
    self = [super init];
    if (self) {
        _viewHeight = 0;
        [self addView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addView];
    }
    return self;
}

- (void)addView
{
    self.backgroundColor = UIColorRGB(0xf0f0f0);
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, BoundsOfScale(5), UI_IOS_WINDOW_WIDTH-30, BoundsOfScale(30))];
    imageView.image = [UIImage imageScaleNamed:@"Public_comment_inpout_ frame#3_3_3_3#"];
    [self addSubview:imageView];
    
    _commentTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, BoundsOfScale(5), UI_IOS_WINDOW_WIDTH-BoundsOfScale(30)-38, BoundsOfScale(30))];
    _commentTextField.placeholder = @"写评论，我来说两句...";
    [self addSubview:_commentTextField];
    
    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_commentTextField.frame)-2, 12, 1, BoundsOfScale(40)-1-24)];
    line.image = [UIImage imageNamed:@"Public_comment_inpout_line"];
    [self addSubview:line];
    
    _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _sendButton.frame = CGRectMake(CGRectGetMaxX(_commentTextField.frame), BoundsOfScale(5), BoundsOfScale(30), BoundsOfScale(30));
    [_sendButton setImage:[UIImage imageNamed:@"Public_comment_send_nor"] forState:UIControlStateNormal];
//    [_sendButton setImage:[UIImage imageNamed:@"Public_comment_send_press"] forState:UIControlStateHighlighted];
    [self addSubview:_sendButton];
    [_sendButton addTarget:self action:@selector(sendButtonChange) forControlEvents:UIControlEventTouchUpInside];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShowFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];//在这里注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHideFrame:) name:UIKeyboardWillHideNotification object:nil];//在这里注册通知
    
}

#pragma mark - 监听方法
- (void)keyboardShowFrame:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    [UIView animateWithDuration:duration animations:^{
        self.y = UI_IOS_WINDOW_HEIGHT- keyboardF.size.height-self.height;
    }];
}

- (void)keyboardHideFrame:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        self.y = UI_IOS_WINDOW_HEIGHT - self.height + _viewHeight;
    }];
}

- (void)sendButtonChange
{
    if ([self.delegate respondsToSelector:@selector(sendChange:)]) {
        [self hiddenKeyboard];
        [self performSelector:@selector(sendComment) withObject:nil afterDelay:0.6];
    }
}

- (void)sendComment
{
    [self.delegate sendChange:_commentTextField.text];
    _commentTextField.text = @"";
    _commentTextField.placeholder = @"写评论，我来说两句...";
}

- (void)hiddenKeyboard
{
    [_commentTextField resignFirstResponder];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
