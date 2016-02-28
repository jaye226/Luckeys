//
//  LKShareHeadView.m
//  Luckeys
//
//  Created by lishaowei on 15/10/17.
//  Copyright © 2015年 Luckeys. All rights reserved.
//

#import "LKShareHeadView.h"
#import "UIView+additions.h"

@interface LKShareHeadView ()
{
    UIImageView *imageView;
    UIImageView *headView;
    UILabel *nameLabel;
}

@end

@implementation LKShareHeadView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addView];
    }
    return self;
}

- (void)addView
{
    UIView *bjView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UI_IOS_WINDOW_WIDTH, BoundsOfScale(225))];
    [self addSubview:bjView];
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, UI_IOS_WINDOW_WIDTH, BoundsOfScale(200))];
    NSString *backImageUrl = [NSString stringWithFormat:@"http://%@%@",SeverHost,[[LKShareUserInfo share] userInfo].backImage];
    [imageView sd_setImageWithURL:[NSURL URLWithString:backImageUrl] placeholderImage:[UIImage imageNamed:@"moren"]];
    [imageView setContentMode:UIViewContentModeScaleAspectFill];
    imageView.clipsToBounds = YES;
    [self addSubview:imageView];
    imageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBackImageGestureUpInisde)];
    [imageView addGestureRecognizer:tapGesture];

    headView = [[UIImageView alloc] initWithFrame:CGRectMake(UI_IOS_WINDOW_WIDTH-BoundsOfScale(80), BoundsOfScale(165), BoundsOfScale(60), BoundsOfScale(60))];
    headView.image = [UIImage imageNamed:@"defaulthead"];
    [headView setContentMode:UIViewContentModeScaleAspectFill];
    headView.clipsToBounds = YES;
    NSString *headImageUrl = [NSString stringWithFormat:@"http://%@%@",SeverHost,[[LKShareUserInfo share] userInfo].userHead];
    [headView sd_setImageWithURL:[NSURL URLWithString:headImageUrl] placeholderImage:[UIImage imageNamed:@"defaulthead"]];
    headView.layer.cornerRadius = CGRectGetMidX(headView.bounds);
    headView.layer.masksToBounds = YES;
    [self addSubview:headView];
    headView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapHeadGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHeadGestureUpInisde)];
    [headView addGestureRecognizer:tapHeadGesture];
    
    nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(BoundsOfScale(20), BoundsOfScale(200)-BoundsOfScale(12)-BoundsOfScale(20), UI_IOS_WINDOW_WIDTH-BoundsOfScale(85)-BoundsOfScale(32), BoundsOfScale(20))];
    nameLabel.font = [UIFont systemFontOfSize:BoundsOfScale(15)];
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.textAlignment = NSTextAlignmentRight;
    if ([[LKShareUserInfo share] userInfo].nickName.length <= 0) {
        nameLabel.text = [[LKShareUserInfo share] userInfo].userName;
    }else{
        nameLabel.text = [[LKShareUserInfo share] userInfo].nickName;
    }
    [self addSubview:nameLabel];
    
    self.frame = CGRectMake(0, 0, UI_IOS_WINDOW_WIDTH, headView.maxY);
}

/**
 *  点击背景
 */
- (void)tapBackImageGestureUpInisde
{
    if ([self.delegate respondsToSelector:@selector(changeBackgroundImage)]) {
        [self.delegate changeBackgroundImage];
    }
}

/**
 *  点击头像
 */
- (void)tapHeadGestureUpInisde
{
    if ([self.delegate respondsToSelector:@selector(changeHeadImage)]) {
        [self.delegate changeHeadImage];
    }
}

/**
 *  更新
 */
- (void)updateShareHeadeView
{
    NSString *backImageUrl = [NSString stringWithFormat:@"http://%@%@",SeverHost,[[LKShareUserInfo share] userInfo].backImage];
    [imageView sd_setImageWithURL:[NSURL URLWithString:backImageUrl] placeholderImage:[UIImage imageNamed:@"moren"]];
    
    NSString *headImageUrl = [NSString stringWithFormat:@"http://%@%@",SeverHost,[[LKShareUserInfo share] userInfo].userHead];
    [headView sd_setImageWithURL:[NSURL URLWithString:headImageUrl] placeholderImage:[UIImage imageNamed:@"defaulthead"]];
    
    if ([[LKShareUserInfo share] userInfo].nickName.length <= 0) {
        nameLabel.text = [[LKShareUserInfo share] userInfo].userName;
    }else{
        nameLabel.text = [[LKShareUserInfo share] userInfo].nickName;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
