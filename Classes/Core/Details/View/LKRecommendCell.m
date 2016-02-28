//
//  LKRecommendCell.m
//  nstest
//
//  Created by lishaowei on 15/10/12.
//  Copyright © 2015年 Luckeys. All rights reserved.
//

#import "LKRecommendCell.h"

@interface LKRecommendCell ()
{
    UIImageView *_imageView;
    UILabel *_nameLabel;
    UILabel *_moneyLabel;
    UILabel *_contentLable;
    UILabel *_bettingLable;
    
    UIView *_lineView;
}

@end

@implementation LKRecommendCell

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
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(BoundsOfScale(10), 0, UI_IOS_WINDOW_WIDTH-BoundsOfScale(10)*2 -SINGLE_LINE_ADJUST_OFFSET, SINGLE_LINE_BOUNDS)];
    _lineView.backgroundColor = UIColorMakeRGB(233.0, 233.0, 233.0);
    [self.contentView addSubview:_lineView];
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(BoundsOfScale(10), BoundsOfScale(14), BoundsOfScale(116), BoundsOfScale(72))];
    _imageView.image = [UIImage imageNamed:@"moren"];
    [_imageView setContentMode:UIViewContentModeScaleAspectFill];
    _imageView.clipsToBounds = YES;
    [self.contentView addSubview:_imageView];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_imageView.frame)+BoundsOfScale(15), BoundsOfScale(14), UI_IOS_WINDOW_WIDTH-CGRectGetMaxX(_imageView.frame)-BoundsOfScale(15)*2, BoundsOfScale(20))];
    _nameLabel.textColor = [UIColor blackColor];
    _nameLabel.font = [UIFont systemFontOfSize:FontOfScale(15)];
    [self.contentView addSubview:_nameLabel];
    
    _contentLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_imageView.frame)+BoundsOfScale(15), CGRectGetMaxY(_nameLabel.frame)+BoundsOfScale(6), UI_IOS_WINDOW_WIDTH-CGRectGetMaxX(_imageView.frame)-BoundsOfScale(15)*2, BoundsOfScale(20))];
    _contentLable.textColor = UIColorRGB(0x999999);
    _contentLable.font = [UIFont systemFontOfSize:FontOfScale(13)];
    [self.contentView addSubview:_contentLable];
    
    _moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_imageView.frame)+BoundsOfScale(15), CGRectGetMaxY(_contentLable.frame)+BoundsOfScale(10), UI_IOS_WINDOW_WIDTH-CGRectGetMaxX(_imageView.frame)-BoundsOfScale(15)*2, BoundsOfScale(20))];
    _moneyLabel.textColor = UIColorRGB(0xfe696d);
    _moneyLabel.font = [UIFont systemFontOfSize:FontOfScale(16)];
    [self.contentView addSubview:_moneyLabel];
    
    _bettingLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_imageView.frame)+BoundsOfScale(15), CGRectGetMaxY(_contentLable.frame)+BoundsOfScale(10), UI_IOS_WINDOW_WIDTH-CGRectGetMaxX(_imageView.frame)-BoundsOfScale(15)*2, BoundsOfScale(20))];
    _bettingLable.textColor = UIColorRGB(0x999999);
    _bettingLable.font = [UIFont systemFontOfSize:FontOfScale(14)];
    _bettingLable.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_bettingLable];

}

- (void)updateWithData:(LKRecommendActivityData *)recommendActivityData
{
    [_imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@%@",SeverHost,recommendActivityData.imageUrl]] placeholderImage:[UIImage imageWithName:@"moren"]];
    _nameLabel.text = recommendActivityData.activityName;
    _contentLable.text = recommendActivityData.descri;
    _moneyLabel.text = [NSString stringWithFormat:@"¥%@", recommendActivityData.totalPrice];
    _bettingLable.text = [NSString stringWithFormat:@"已投注%@", recommendActivityData.betNumber];
}

+ (CGFloat)getCellHeight
{
    return BoundsOfScale(100);
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
