//
//  LKWalletTableViewCell.m
//  Luckeys
//
//  Created by lishaowei on 15/11/29.
//  Copyright © 2015年 Luckeys. All rights reserved.
//

#import "LKPayWalletTableViewCell.h"

@interface LKPayWalletTableViewCell ()
{
    UIView *_bgView;
    
    UILabel *_balanceLabel;
}

@end

@implementation LKPayWalletTableViewCell

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
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_bgView.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerTopLeft cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = _bgView.bounds;
    maskLayer.path = maskPath.CGPath;
    _bgView.layer.mask = maskLayer;
    [self.contentView addSubview:_bgView];
    
    CGSize size = [LKTools getStringSize:@"钱包余额:" fontSize:14];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(BoundsOfScale(10), 0, size.width, _bgView.height)];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.textColor = [UIColor blackColor];
    nameLabel.font = [UIFont systemFontOfSize:14];
    nameLabel.text = @"钱包余额:";
    [_bgView addSubview:nameLabel];
    
    _balanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.maxX, 0, _bgView.width-nameLabel.maxX-BoundsOfScale(10), _bgView.height)];
    _balanceLabel.backgroundColor = [UIColor clearColor];
    _balanceLabel.textColor = [UIColor blackColor];
    _balanceLabel.font = [UIFont systemFontOfSize:14];
    _balanceLabel.textAlignment = NSTextAlignmentRight;
    _balanceLabel.text = @"0元";
    [_bgView addSubview:_balanceLabel];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(BoundsOfScale(10), _bgView.maxY-SINGLE_LINE_ADJUST_OFFSET-1, _bgView.width-BoundsOfScale(10)*2, SINGLE_LINE_BOUNDS)];
    lineView.backgroundColor = UIColorRGB(0xe9e9e9);
    [_bgView addSubview:lineView];
}

@end
