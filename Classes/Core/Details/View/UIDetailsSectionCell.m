//
//  UIDetailsSectionCell.m
//  Luckeys
//
//  Created by lishaowei on 15/10/12.
//  Copyright © 2015年 Luckeys. All rights reserved.
//

#import "UIDetailsSectionCell.h"

@interface UIDetailsSectionCell ()
{
    UILabel *_nameLabel;
    UILabel *_moneyLabel;
    UIImageView *_arrowImageView;
    
    BOOL _selectd;
}

@end

@implementation UIDetailsSectionCell

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
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(BoundsOfScale(15), BoundsOfScale(15), UI_IOS_WINDOW_WIDTH-BoundsOfScale(15)*2, BoundsOfScale(20))];
    _nameLabel.font = [UIFont systemFontOfSize:FontOfScale(15)];
    _nameLabel.textColor = UIColorRGB(0x333333);
    [self.contentView addSubview:_nameLabel];
    
    _moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(BoundsOfScale(15), BoundsOfScale(15), UI_IOS_WINDOW_WIDTH-BoundsOfScale(15)*2, BoundsOfScale(20))];
    _moneyLabel.font = [UIFont systemFontOfSize:FontOfScale(12)];
    _moneyLabel.textColor = UIColorRGB(0xfe696d);
    _moneyLabel.textAlignment = NSTextAlignmentRight;
    _moneyLabel.text = @"查看更多";
    [self.contentView addSubview:_moneyLabel];
    
    _arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(UI_IOS_WINDOW_WIDTH-BoundsOfScale(15)*3, BoundsOfScale(15)+BoundsOfScale(5), BoundsOfScale(15), BoundsOfScale(10))];
    _arrowImageView.image = [UIImage imageNamed:@"detalis_arrow_down"];
    //[self.contentView addSubview:_arrowImageView];
}

- (void)setNameWith:(NSString *)nameStr withHidden:(BOOL)hiddenBool
{
    _nameLabel.text = nameStr;
    _moneyLabel.hidden = hiddenBool;
    _arrowImageView.hidden = hiddenBool;
    
    self.userInteractionEnabled = !hiddenBool;
}

+ (CGFloat)getCellHeight
{
    return BoundsOfScale(50);
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
