//
//  LKTypeListTableViewCell.m
//  Luckeys
//
//  Created by BearLi on 15/9/29.
//  Copyright © 2015年 Luckeys. All rights reserved.
//

#import "LKTypeListTableViewCell.h"
#import "PBArrowMarkView.h"

@interface LKTypeListTableViewCell ()

@property (nonatomic,strong) UIImageView * detailImage;

@property (nonatomic,strong) PBArrowMarkView * arrowView;
@property (nonatomic,strong) UILabel * priceLabel;

@property (nonatomic,strong) UIProgressView * progressView;
@property (nonatomic,strong) UILabel * titleLabel;
@property (nonatomic,strong) UILabel * addressLabel;
@property (nonatomic,strong) UILabel * dateLabel;
@end

@implementation LKTypeListTableViewCell

- (void)dealloc
{
    _delegate = nil;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.width = UI_IOS_WINDOW_WIDTH;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createView];
    }
    return self;
}

- (void)createView
{
    _detailImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, BoundsOfScale(200))];
    [_detailImage setContentMode:UIViewContentModeScaleAspectFill];
    [_detailImage setClipsToBounds:YES];
    [self.contentView addSubview:_detailImage];
    
    _likeImage = [[UIButton alloc] initWithFrame:CGRectMake(0, kTypeLikeButtonY+BoundsOfScale(10), BoundsOfScale(19), BoundsOfScale(16.5))];
    _likeImage.x = _detailImage.width - BoundsOfScale(12) - _likeImage.width;
    [_likeImage setImage:[UIImage imageWithName:@"home_heart"] forState:UIControlStateNormal];
    [_likeImage addTarget:self action:@selector(likeAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_likeImage];
    
    _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, _detailImage.maxY, _detailImage.width, 4)];
    _progressView.progressTintColor =UIColorRGB(0x36e07b);
    _progressView.trackTintColor = UIColorRGB(0x7b7b7b);
    [self.contentView addSubview:_progressView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, _progressView.maxY+7, BoundsOfScale(300-33), 20)];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.textColor = UIColorRGB(0x666666);
    _titleLabel.font = [UIFont systemFontOfSize:17];
    [self.contentView addSubview:_titleLabel];
    
    UIImageView * address = [[UIImageView alloc] initWithFrame:CGRectMake(_titleLabel.x, _titleLabel.maxY + 10, BoundsOfScale(11), BoundsOfScale(15))];
    address.image = [UIImage imageWithName:@"type_place_small"];
    [self.contentView addSubview:address];
    
    _addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(address.maxX + 7, address.y, BoundsOfScale(300-33), address.height)];
    _addressLabel.width = _detailImage.width/2.0 - _addressLabel.x;
    _addressLabel.backgroundColor = [UIColor clearColor];
    _addressLabel.textColor = UIColorRGB(0x999999);
    _addressLabel.font = [UIFont systemFontOfSize:FontOfScale(12)];
    [self.contentView addSubview:_addressLabel];
    
    UIImageView * date = [[UIImageView alloc] initWithFrame:CGRectMake(_detailImage.width/2.0+5, address.y, address.width, address.height)];
    date.image = [UIImage imageWithName:@"type_time_small"];
    [self.contentView addSubview:date];
    
    _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(date.maxX + 7, date.y, BoundsOfScale(300-33), date.height)];
    _dateLabel.width = _detailImage.width/2.0;
    _dateLabel.backgroundColor = [UIColor clearColor];
    _dateLabel.textColor = _addressLabel.textColor;
    _dateLabel.font = _addressLabel.font;
    [self.contentView addSubview:_dateLabel];
    
    //箭头视图
    _arrowView = [[PBArrowMarkView alloc] initWithFrame:CGRectMake(0, 0, 90, 40)];
    _arrowView.fillColor = UIColorMakeRGBA(0, 0, 0, 0.7);
    _arrowView.y = _progressView.y - _arrowView.height;
    _arrowView.arrowPoint = CGPointMake(140, _arrowView.y);
    [self.contentView addSubview:_arrowView];
    
    _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _arrowView.width, _arrowView.height-_arrowView.arrowHeight)];
    _priceLabel.backgroundColor = [UIColor clearColor];
    _priceLabel.textColor = [UIColor whiteColor];
    _priceLabel.font = [UIFont systemFontOfSize:FontOfScale(16)];
    _priceLabel.textAlignment = NSTextAlignmentCenter;
    [_arrowView addSubview:_priceLabel];
    
    _typeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _typeButton.frame = CGRectMake(0, 0, BoundsOfScale(52.5), BoundsOfScale(52.5));
    _typeButton.centerY = _progressView.centerY;
    _typeButton.x = _detailImage.width - BoundsOfScale(18) - _typeButton.width;
    [_typeButton setImage:[UIImage imageWithName:@"type_movie"] forState:UIControlStateNormal];
    [_typeButton addTarget:self action:@selector(typeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_typeButton];
    
    _arrowView.realWidth = _typeButton.x;
    
}

- (void)setTypeData:(LKTypeData *)typeData
{
    _typeData = typeData;
    _titleLabel.text = [NSString stringWithFormat:@"[%@] %@",_typeData.activityTypeName,_typeData.activityName];
    _addressLabel.text = _typeData.locationName;
    CGFloat price = [_typeData.unitPrice floatValue] * [_typeData.betNumber floatValue];
    CGFloat totalPrice = [_typeData.totalPrice floatValue];
    _priceLabel.text = [NSString stringWithFormat:@"￥%0.0f/￥%@",price,_typeData.totalPrice];
    _arrowView.width = [LKTools getStringSize:_priceLabel.text fontSize:BoundsOfScale(16)].width;
    _priceLabel.width = _arrowView.width;
    _progressView.progress = price/totalPrice;
    
    if (_typeButton.hidden) {
        _arrowView.realWidth = _progressView.width;
    }
    else {
        _arrowView.realWidth = _progressView.width;
    }
    
    NSInteger typeInteget = [typeData.activityTypeUuid integerValue];
    
    switch (typeInteget) {
        case 1:
        {
            [_typeButton setImage:[UIImage imageWithName:@"type_movie"] forState:UIControlStateNormal];
            break;
        }
        case 2:
        {
            [_typeButton setImage:[UIImage imageWithName:@"type_eat"] forState:UIControlStateNormal];
            break;
        }
        case 3:
        {
            [_typeButton setImage:[UIImage imageWithName:@"type_play"] forState:UIControlStateNormal];
            break;
        }
        case 4:
        {
            [_typeButton setImage:[UIImage imageWithName:@"type_book"] forState:UIControlStateNormal];
            break;
        }
        case 5:
        {
            [_typeButton setImage:[UIImage imageWithName:@"type_play"] forState:UIControlStateNormal];
            break;
        }
        default:
            break;
    }
    
    
    _arrowView.arrowPoint = CGPointMake(_arrowView.realWidth*_progressView.progress, _arrowView.y);
    
    NSString * startYY = [LKTools transTime:_typeData.startDate dateFormat:@"yyyy"];
    NSString * startMM = [LKTools transTime:_typeData.startDate dateFormat:@"MM"];
    NSString * startDD = [LKTools transTime:_typeData.startDate dateFormat:@"dd"];
    
    NSString * endYY = [LKTools transTime:_typeData.endDate dateFormat:@"yyyy"];
    NSString * endMM = [LKTools transTime:_typeData.endDate dateFormat:@"MM"];
    NSString * endDD = [LKTools transTime:_typeData.endDate dateFormat:@"dd"];
    _dateLabel.text = [NSString stringWithFormat:@"%@.%@.%@至%@.%@.%@",startYY,startMM,startDD,endYY,endMM,endDD];
    
    [self resetLikeImage:_typeData];
    
    NSArray *imageActitvtyArray = [_typeData.imageUrl componentsSeparatedByString:@","];
    if (imageActitvtyArray.count > 0) {
        NSString *dityImageStr = [NSString stringWithFormat:@"http://%@%@",SeverHost,[imageActitvtyArray objectAtIndex:0]];
        [_detailImage sd_setImageWithURL:[NSURL URLWithString:dityImageStr] placeholderImage:[UIImage imageWithName:@"moren"]];
    }else{
        NSString *dityImageStr = [NSString stringWithFormat:@"http://%@%@",SeverHost,@""];
        [_detailImage sd_setImageWithURL:[NSURL URLWithString:dityImageStr] placeholderImage:[UIImage imageWithName:@"moren"]];
    }
}

- (void)resetLikeImage:(LKTypeData*)data {
    if ([data.iLike boolValue]) {
        [_likeImage setImage:[UIImage imageWithName:@"home_heart_on"] forState:UIControlStateNormal];
    }
    else
    {
        [_likeImage setImage:[UIImage imageWithName:@"home_heart"] forState:UIControlStateNormal];
    }

}

- (void)likeAction:(UIButton*)button {
    if (_delegate && [_delegate respondsToSelector:@selector(likeButtonClick:)]) {
        [_delegate likeButtonClick:button];
    }
}

- (void)typeButtonAction:(UIButton*)button
{
    if (_delegate && [_delegate respondsToSelector:@selector(typeButtonClick:)]) {
        [_delegate typeButtonClick:button];
    }
}


+ (CGFloat)heightForContent:(NSString*)content
{
    CGFloat height = 0;
    return height;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
