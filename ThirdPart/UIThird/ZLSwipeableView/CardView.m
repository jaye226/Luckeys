//
//  CardView.m
//  ZLSwipeableViewDemo
//
//  Created by Zhixuan Lai on 11/1/14.
//  Copyright (c) 2014 Zhixuan Lai. All rights reserved.
//

#import "CardView.h"

@interface CardView ()
{
    UILabel *_nameLabel;
    
    UIImageView *_imageView;
    
    UILabel *_timeLabel;
    
    UILabel *_numberLabel;
    
    LKBettingData *_bettingData;
    
    UIButton *_button;
}

@end

@implementation CardView
-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        //// Color Declarations
        UIColor* shadowColor2 = [UIColor colorWithRed: 0.209 green: 0.209 blue: 0.209 alpha: 1];
        
        //// Shadow Declarations
        UIColor* shadow = [shadowColor2 colorWithAlphaComponent: 0.73];
        CGSize shadowOffset = CGSizeMake(3.1/2.0, -0.1/2.0);
        CGFloat shadowBlurRadius = 12/2.0;
        self.layer.shadowColor = [shadow CGColor];
        self.layer.shadowOpacity = 0.73;
        self.layer.shadowOffset = shadowOffset;
        self.layer.shadowRadius = shadowBlurRadius;
        self.layer.shouldRasterize = YES;
        
        [self addView];
    }
    return self;
}

- (void)addView
{
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(BoundsOfScale(18), BoundsOfScale(20), self.width-BoundsOfScale(18)*2, 30)];
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.font = [UIFont systemFontOfSize:FontOfScale(18)];
    _nameLabel.textColor = UIColorRGB(0x333333);
    [self addSubview:_nameLabel];
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, _nameLabel.maxY+BoundsOfScale(10), self.width, BoundsOfScale(110))];
    _imageView.image = [UIImage imageNamed:@"card_money"];
    [self addSubview:_imageView];
    
    UILabel *numberLable = [[UILabel alloc] initWithFrame:CGRectMake(BoundsOfScale(20), BoundsOfScale(20), self.width-BoundsOfScale(24)*2, BoundsOfScale(20))];
    numberLable.backgroundColor = [UIColor clearColor];
    numberLable.textColor = [UIColor whiteColor];
    numberLable.font = [UIFont boldSystemFontOfSize:FontOfScale(16)];
    numberLable.text = @"抽奖券编号";
    [_imageView addSubview:numberLable];
    
    _numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(BoundsOfScale(20), numberLable.maxY+BoundsOfScale(15), self.width-BoundsOfScale(20)-BoundsOfScale(10), BoundsOfScale(30))];
    _numberLabel.backgroundColor = [UIColor clearColor];
    _numberLabel.textColor = [UIColor whiteColor];
    _numberLabel.font = [UIFont boldSystemFontOfSize:FontOfScale(28)];
    [_imageView addSubview:_numberLabel];
    
    UIImageView * date = [[UIImageView alloc] initWithFrame:CGRectMake(BoundsOfScale(10), _imageView.maxY+BoundsOfScale(20), BoundsOfScale(11), BoundsOfScale(15))];
    date.image = [UIImage imageWithName:@"type_time_small"];
    [self addSubview:date];
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(date.maxX + BoundsOfScale(7), _imageView.maxY+BoundsOfScale(20), self.width-(date.maxX +BoundsOfScale(14)), date.height)];
    _timeLabel.backgroundColor = [UIColor clearColor];
    _timeLabel.textColor = UIColorRGB(0x999999);
    _timeLabel.font = [UIFont systemFontOfSize:FontOfScale(13)];
    [self addSubview:_timeLabel];
    
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    _button.frame = CGRectMake(self.width-BoundsOfScale(20)-BoundsOfScale(15), BoundsOfScale(20), BoundsOfScale(20), BoundsOfScale(20));
    [_button setBackgroundImage:[UIImage imageNamed:@"ic_check_small_normal"] forState:UIControlStateNormal];
    [_button setBackgroundImage:[UIImage imageNamed:@"ic_check_small_on"] forState:UIControlStateSelected];
    [self addSubview:_button];
    //[_button addTarget:self action:@selector(selectButtonInside:) forControlEvents:UIControlEventTouchUpInside];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(self.width-BoundsOfScale(20)-BoundsOfScale(20), BoundsOfScale(10), BoundsOfScale(30), BoundsOfScale(30));
    [self addSubview:button];
    [button addTarget:self action:@selector(selectButtonInside:) forControlEvents:UIControlEventTouchUpInside];

    self.height = _timeLabel.maxY+BoundsOfScale(17);
}

- (void)setActivityTypeUuid:(NSString *)activityTypeUuid
{
    _activityTypeUuid = activityTypeUuid;
    switch ([self.activityTypeUuid integerValue]) {
        case 1:
        {
            _imageView.image = [UIImage imageNamed:@"card_movie"];
            break;
        }
        case 2:
        {
            _imageView.image = [UIImage imageNamed:@"card_food"];
            break;
        }
        case 3:
        {
            _imageView.image = [UIImage imageNamed:@"card_ative"];
            break;
        }
        case 4:
        {
            _imageView.image = [UIImage imageNamed:@"card_book"];
            break;
        }
        case 5:
        {
            _imageView.image = [UIImage imageNamed:@"card_other"];
            break;
        }
        default:
            break;
    }
}

- (void)selectButtonInside:(UIButton *)button
{
    _button.selected = !button.selected;
    button.selected = !button.selected;
    if ([self.delegate respondsToSelector:@selector(selectButtonInsideWithBettingData:withBool:)]) {
        [self.delegate selectButtonInsideWithBettingData:_bettingData withBool:button.selected];
    }
}

- (void)updateWith:(NSString *)nameString withTime:(NSString *)timeString WithBettingData:(LKBettingData *)data 
{
    _bettingData = data;
    
    if (data.isSelect) {
        _button.selected = YES;
    }
    
    _nameLabel.text = nameString;
    _numberLabel.text = data.code;
    _timeLabel.text = timeString;
}

-(void)drawRect:(CGRect)rect {
    
    [super drawRect:rect];
    
    CGFloat frameWidth = rect.size.width;
    CGFloat frameHeight = rect.size.height;
    CGFloat cornerRadius = 10;
    
    //// General Declarations
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIColor* cardColor = self.cardColor;
    
    //// card1
    {
        CGContextSaveGState(context);
        //        CGContextSetShadowWithColor(context, shadowOffset, shadowBlurRadius, [shadow CGColor]);
        CGContextBeginTransparencyLayer(context, NULL);
        
        //// Rectangle 4 Drawing
        UIBezierPath* rectangle4Path = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(0, 0, frameWidth, frameHeight) cornerRadius: cornerRadius];
        [cardColor setFill];
        [rectangle4Path fill];
        
        CGContextEndTransparencyLayer(context);
        CGContextRestoreGState(context);
    }
}
@end
