//
//  LKToCommentCell.m
//  Luckeys
//
//  Created by lishaowei on 15/10/12.
//  Copyright © 2015年 Luckeys. All rights reserved.
//

#import "LKToCommentCell.h"

@implementation LKToCommentCell

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
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake((UI_IOS_WINDOW_WIDTH-BoundsOfScale(115))/2, BoundsOfScale(20), BoundsOfScale(115), BoundsOfScale(33));
    [button.layer setMasksToBounds:YES];
    [button.layer setCornerRadius:20.0];
    //设置矩形四个圆角半径
    [button.layer setBorderWidth:1.0];
    //边框宽度
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 1, 0, 0, 1 });
    [button.layer setBorderColor:colorref];
    [button setTitle:@"我要评论" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:FontOfScale(16)];
    [button setTitleColor:UIColorRGB(0xfe696d) forState:UIControlStateNormal];
    [self.contentView addSubview:button];
    [button setUserInteractionEnabled:NO];
    
}

+ (CGFloat)getCellHeight
{
    return BoundsOfScale(40)+BoundsOfScale(33);
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
