//
//  LKHeadportraitCell.m
//  Luckeys
//
//  Created by lishaowei on 15/10/12.
//  Copyright © 2015年 Luckeys. All rights reserved.
//

#import "LKHeadportraitCell.h"

@interface LKHeadportraitCell ()
{
    UILabel *_nameLabel;
    UIView *_lineView;
    
    UIView *_headporView;
    
    NSArray *_arry;
}

@end

@implementation LKHeadportraitCell

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
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(BoundsOfScale(10), BoundsOfScale(16), UI_IOS_WINDOW_WIDTH-BoundsOfScale(10)*2, BoundsOfScale(20))];
    _nameLabel.font = [UIFont systemFontOfSize:17];
    _nameLabel.textColor = UIColorRGB(0x333333);
    [self.contentView addSubview:_nameLabel];
    
    _headporView = [[UIView alloc] initWithFrame:CGRectMake(BoundsOfScale(10), _nameLabel.maxY+BoundsOfScale(20), UI_IOS_WINDOW_WIDTH-BoundsOfScale(10)*2, BoundsOfScale(61))];
    _headporView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_headporView];
    
    for (int i = 0; i < 3; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((BoundsOfScale(24)+BoundsOfScale(56))*i, 0, BoundsOfScale(56), BoundsOfScale(56))];
        imageView.image = [UIImage imageNamed:@"defaulthead"];
        [imageView setContentMode:UIViewContentModeScaleAspectFill];
        imageView.clipsToBounds = YES;
        imageView.layer.cornerRadius = CGRectGetMidX(imageView.bounds);
        imageView.layer.masksToBounds = YES;
        [_headporView addSubview:imageView];
        
        UILabel *headporLabel = [[UILabel alloc] initWithFrame:CGRectMake((BoundsOfScale(24)+BoundsOfScale(56))*i+BoundsOfScale(5), BoundsOfScale(45), BoundsOfScale(56)-BoundsOfScale(5)*2, BoundsOfScale(20))];
        headporLabel.backgroundColor = UIColorMakeRGB(254.0, 105.0, 109.0);
        headporLabel.textColor = UIColorRGB(0xffffff);
        headporLabel.textAlignment = NSTextAlignmentCenter;
        headporLabel.font = [UIFont systemFontOfSize:FontOfScale(11)];
        headporLabel.text = @"52注";
        [_headporView addSubview:headporLabel];
    }
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(BoundsOfScale(15), _headporView.maxY+BoundsOfScale(15) -SINGLE_LINE_ADJUST_OFFSET, UI_IOS_WINDOW_WIDTH-BoundsOfScale(15)*2, SINGLE_LINE_BOUNDS)];
    _lineView.backgroundColor = UIColorRGB(0xe9e9e9);
    [self addSubview:_lineView];
}

- (void)updateWithData:(NSArray *)listdata
{
    _arry = listdata;
    _nameLabel.text = [NSString stringWithFormat:@"%ld人投注", listdata.count];
    if (_headporView) {
        [_headporView removeFromSuperview];
    }
    
    _headporView = [[UIView alloc] initWithFrame:CGRectMake(BoundsOfScale(10), _nameLabel.maxY+BoundsOfScale(20), UI_IOS_WINDOW_WIDTH-BoundsOfScale(10)*2, BoundsOfScale(61))];
    _headporView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_headporView];
    
    CGFloat x = BoundsOfScale(10);
    CGFloat y = 0;
    
    for (int i = 0; i < listdata.count; i++) {
        LKBetUserData *data = [listdata objectAtIndex:i];
        
        if (((BoundsOfScale(24)+BoundsOfScale(56))*i + BoundsOfScale(56)) > UI_IOS_WINDOW_WIDTH-BoundsOfScale(10)*2) {
            x = BoundsOfScale(10);
            y += BoundsOfScale(75);
        }else{
            x = (BoundsOfScale(24)+BoundsOfScale(56))*i;
        }
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, BoundsOfScale(56), BoundsOfScale(56))];
        imageView.image = [UIImage imageNamed:@"defaulthead"];
        [imageView setContentMode:UIViewContentModeScaleAspectFill];
        imageView.clipsToBounds = YES;
        imageView.layer.cornerRadius = CGRectGetMidX(imageView.bounds);
        imageView.layer.masksToBounds = YES;
        [imageView setImageUrl:[NSString stringWithFormat:@"http://%@%@",SeverHost,data.userHead] placeholderImage:[UIImage imageWithName:@"defaulthead"] complete:nil];
        [_headporView addSubview:imageView];
        imageView.userInteractionEnabled = YES;

        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, BoundsOfScale(56), BoundsOfScale(56));
        button.tag = i;
        [imageView addSubview:button];
        [button addTarget:self action:@selector(selectedBetUserUpInside:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *headporLabel = [[UILabel alloc] initWithFrame:CGRectMake(x+BoundsOfScale(5), imageView.maxY-BoundsOfScale(11), BoundsOfScale(56)-BoundsOfScale(5)*2, BoundsOfScale(20))];
        headporLabel.backgroundColor = UIColorMakeRGB(254.0, 105.0, 109.0);
        headporLabel.textColor = UIColorRGB(0xffffff);
        headporLabel.textAlignment = NSTextAlignmentCenter;
        headporLabel.font = [UIFont systemFontOfSize:FontOfScale(11)];
        headporLabel.text = [NSString stringWithFormat:@"%@注", data.betNumber];
        [_headporView addSubview:headporLabel];
        headporLabel.userInteractionEnabled = YES;
        
        UIButton *headporButton = [UIButton buttonWithType:UIButtonTypeCustom];
        headporButton.frame = headporLabel.bounds;
        headporButton.tag = i;
        [headporLabel addSubview:headporButton];
        [headporButton addTarget:self action:@selector(showHeadporUpInside:) forControlEvents:UIControlEventTouchUpInside];
        
        _headporView.frame = CGRectMake(BoundsOfScale(10), _nameLabel.maxY+BoundsOfScale(20), UI_IOS_WINDOW_WIDTH-BoundsOfScale(10)*2, headporLabel.maxY);
        
    }
    
    _lineView.frame = CGRectMake(BoundsOfScale(15), _headporView.maxY+BoundsOfScale(15) -SINGLE_LINE_ADJUST_OFFSET, UI_IOS_WINDOW_WIDTH-BoundsOfScale(15)*2, SINGLE_LINE_BOUNDS);
    
}

+ (CGFloat)getCellHeight:(NSArray *)listdata
{
     UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(BoundsOfScale(10), BoundsOfScale(16), UI_IOS_WINDOW_WIDTH-BoundsOfScale(10)*2, BoundsOfScale(20))];
    nameLabel.font = [UIFont systemFontOfSize:17];
    nameLabel.textColor = UIColorRGB(0x333333);
    nameLabel.text = @"3人投注";
    
    UIView *headporView = [[UIView alloc] initWithFrame:CGRectMake(BoundsOfScale(10), nameLabel.maxY+BoundsOfScale(20), UI_IOS_WINDOW_WIDTH-BoundsOfScale(10)*2,BoundsOfScale(61))];
    headporView.backgroundColor = [UIColor clearColor];
    
    CGFloat x = BoundsOfScale(10);
    CGFloat y = 0;
    
    for (int i = 0; i < listdata.count; i++) {
        LKBetUserData *data = [listdata objectAtIndex:i];
        
        if (((BoundsOfScale(24)+BoundsOfScale(56))*i + BoundsOfScale(56)) > UI_IOS_WINDOW_WIDTH-BoundsOfScale(10)*2) {
            x = BoundsOfScale(10);
            y += BoundsOfScale(75);
        }else{
            x = (BoundsOfScale(24)+BoundsOfScale(56))*i;
        }
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, BoundsOfScale(56), BoundsOfScale(56))];
        imageView.image = [UIImage imageNamed:@"defaulthead"];
        [imageView setContentMode:UIViewContentModeScaleAspectFill];
        imageView.clipsToBounds = YES;
        imageView.layer.cornerRadius = CGRectGetMidX(imageView.bounds);
        imageView.layer.masksToBounds = YES;
        
        UILabel *headporLabel = [[UILabel alloc] initWithFrame:CGRectMake(x+BoundsOfScale(5), imageView.maxY-BoundsOfScale(11), BoundsOfScale(56)-BoundsOfScale(5)*2, BoundsOfScale(20))];
        headporLabel.backgroundColor = UIColorMakeRGB(254.0, 105.0, 109.0);
        headporLabel.textColor = UIColorRGB(0xffffff);
        headporLabel.textAlignment = NSTextAlignmentCenter;
        headporLabel.font = [UIFont systemFontOfSize:FontOfScale(11)];
        headporLabel.text = [NSString stringWithFormat:@"%@注", data.betNumber];
        
        headporView.frame = CGRectMake(BoundsOfScale(10), nameLabel.maxY+BoundsOfScale(20), UI_IOS_WINDOW_WIDTH-BoundsOfScale(10)*2, headporLabel.maxY);
        
    }
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(BoundsOfScale(15), headporView.maxY+BoundsOfScale(15) -SINGLE_LINE_ADJUST_OFFSET, UI_IOS_WINDOW_WIDTH-BoundsOfScale(15)*2, SINGLE_LINE_BOUNDS)];
    lineView.backgroundColor = UIColorRGB(0xe9e9e9);
    
    return lineView.maxY;
}

- (void)selectedBetUserUpInside:(UIButton *)button
{
    LKBetUserData *data = [_arry objectAtIndex:button.tag];
    if ([self.delegate respondsToSelector:@selector(changeHeadportraitBet:)]) {
        [self.delegate changeHeadportraitBet:data];
    }
}

- (void)showHeadporUpInside:(UIButton *)button
{
    LKBetUserData *data = [_arry objectAtIndex:button.tag];
    if ([self.delegate respondsToSelector:@selector(changeHeadportraitBet:)]) {
        NSArray *array = [data.codes componentsSeparatedByString:@","];
        [self.delegate showHeadporInside:array];
    }
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
