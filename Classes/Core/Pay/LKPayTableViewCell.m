//
//  LKPayTableViewCell.m
//  Luckeys
//
//  Created by lishaowei on 15/11/29.
//  Copyright © 2015年 Luckeys. All rights reserved.
//

#import "LKPayTableViewCell.h"

@interface LKPayTableViewCell ()
{
    UIView *_bgView;
    UIImageView *_leftImageView;
    UILabel *_nameLable;
    UILabel *_textLabel;
    
    UIImageView *_checkImageView;
}

@end

@implementation LKPayTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addView];
    }
    return self;
}

- (void)addView
{
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(BoundsOfScale(20), 0, UI_IOS_WINDOW_WIDTH-BoundsOfScale(40), BoundsOfScale(50))];
    _bgView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_bgView];
    
    _leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(BoundsOfScale(10), BoundsOfScale(10), BoundsOfScale(50), BoundsOfScale(30))];
    [_bgView addSubview:_leftImageView];
    
    _nameLable = [[UILabel alloc] initWithFrame:CGRectMake(_leftImageView.maxX+BoundsOfScale(8), BoundsOfScale(5), _bgView.width-_leftImageView.maxX-BoundsOfScale(20), BoundsOfScale(20))];
    _nameLable.backgroundColor = [UIColor clearColor];
    _nameLable.textColor = [UIColor blackColor];
    _nameLable.font = [UIFont systemFontOfSize:14];
    [_bgView addSubview:_nameLable];
    
    _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(_leftImageView.maxX+BoundsOfScale(8), BoundsOfScale(25), _bgView.width-_leftImageView.maxX-BoundsOfScale(20), BoundsOfScale(20))];
    _textLabel.backgroundColor = [UIColor clearColor];
    _textLabel.textColor = [UIColor grayColor];
    _textLabel.font = [UIFont systemFontOfSize:12];
    [_bgView addSubview:_textLabel];
    
    _checkImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_bgView.width-BoundsOfScale(18)-BoundsOfScale(10), (_bgView.height-BoundsOfScale(18))/2, BoundsOfScale(18), BoundsOfScale(18))];
    _checkImageView.image = [UIImage imageWithName:@"checkIcon"];
    [_bgView addSubview:_checkImageView];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(_leftImageView.x, _bgView.maxY-SINGLE_LINE_ADJUST_OFFSET, _bgView.width-_leftImageView.x*2, SINGLE_LINE_BOUNDS)];
    lineView.backgroundColor = UIColorRGB(0xe9e9e9);
    [_bgView addSubview:lineView];
}

- (void)updateCell:(NSInteger)typeInt showIcon:(BOOL)isIcon
{
    _bgView.layer.mask = nil;

    switch (typeInt) {
        case 0:
        {
            _leftImageView.image = [UIImage imageWithName:@"ic_alipay"];
            _nameLable.text = @"支付宝支付";
            _textLabel.text = @"推荐有支付宝帐号的用户使用";
            break;
        }
        case 1:
        {
            _leftImageView.image = [UIImage imageWithName:@"ic_bank"];
            _nameLable.text = @"银行卡支付";
            _textLabel.text = @"支持储蓄卡信用咔，无需开用网银";
            break;
        }
        case 2:
        {
            _leftImageView.image = [UIImage imageWithName:@"ic_wechat"];
            _nameLable.text = @"微信支付";
            _textLabel.text = @"推荐安装微信5.0及以上版本使用";
            
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_bgView.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(5, 5)];
            CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
            maskLayer.frame = _bgView.bounds;
            maskLayer.path = maskPath.CGPath;
            _bgView.layer.mask = maskLayer;

            break;
        }
        default:
            break;
    }
    _checkImageView.hidden = !isIcon;
}

@end
