//
//  LKNotOrderCell.m
//  Luckeys
//
//  Created by lishaowei on 16/1/18.
//  Copyright © 2016年 Luckeys. All rights reserved.
//

#import "LKNotOrderCell.h"

@interface LKNotOrderCell ()
{
    UIImageView *_imageView;
    UILabel *_nameLabel;
    UILabel *_moneyLabel;
    UILabel *_contentLable;    
    UIView *_lineView;
}

@end

@implementation LKNotOrderCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createView];
    }
    return self;
}

-(void)createView
{

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
    _moneyLabel.textColor = UIColorRGB(0x999999);
    _moneyLabel.font = [UIFont systemFontOfSize:FontOfScale(13)];
    [self.contentView addSubview:_moneyLabel];
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(BoundsOfScale(10), BoundsOfScale(100)-SINGLE_LINE_BOUNDS, UI_IOS_WINDOW_WIDTH-BoundsOfScale(10)*2 -SINGLE_LINE_ADJUST_OFFSET, SINGLE_LINE_BOUNDS)];
    _lineView.backgroundColor = UIColorMakeRGB(233.0, 233.0, 233.0);
    [self.contentView addSubview:_lineView];
}

- (void)updateWithData:(LKNotOrderData *)data
{
    [_imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@%@",SeverHost,data.imageUrl]] placeholderImage:[UIImage imageWithName:@"moren"]];
    _nameLabel.text = data.activityName;
    _contentLable.text = [NSString stringWithFormat:@"单价：%@    数量：%ld",data.unitPrice,(long)data.listCodes.count];
    _moneyLabel.text = @"未开奖";
}


+ (CGFloat)getCellHeight
{
    return BoundsOfScale(100);
}

@end
