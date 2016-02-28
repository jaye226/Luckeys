//
//  LKPrizeCell.m
//  Luckeys
//
//  Created by 李锦华 on 15/10/4.
//  Copyright © 2015年 Luckeys. All rights reserved.
//

#import "LKPrizeCell.h"
#import "LKTypeData.h"

@implementation LKPrizeCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createView];
    }
    return self;
}

-(void)createView{
    _typeImageView=[[UIImageView alloc] initWithFrame:CGRectMake(BoundsOfScale(10), BoundsOfScale(15), BoundsOfScale(50), BoundsOfScale(50))];
    [_typeImageView setBackgroundColor:[UIColor blueColor]];
    
    UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:_typeImageView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight|UIRectCornerBottomLeft|UIRectCornerBottomRight cornerRadii:CGSizeMake(BoundsOfScale(25), BoundsOfScale(25))];
    CAShapeLayer * layer = [CAShapeLayer layer];
    layer.backgroundColor = [UIColor clearColor].CGColor;
    layer.frame = _typeImageView.bounds;
    layer.path = path.CGPath;
    _typeImageView.layer.mask = layer;
    _typeImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:_typeImageView];
    
    _prizeTitleLabel=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_typeImageView.frame)+20, BoundsOfScale(20), UI_IOS_WINDOW_WIDTH-40-CGRectGetMaxX(_typeImageView.frame), 20)];
    _prizeTitleLabel.backgroundColor=[UIColor clearColor];
    _prizeTitleLabel.font=[UIFont systemFontOfSize:15];
    _prizeTitleLabel.textColor=UIColorRGB(kContentColor_three);
    [self.contentView addSubview:_prizeTitleLabel];
    
    
    _timeLabel=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_typeImageView.frame)+20, CGRectGetMaxY(_prizeTitleLabel.frame)+8, _prizeTitleLabel.frame.size.width, 18)];
    _timeLabel.backgroundColor=[UIColor clearColor];
    _timeLabel.font=[UIFont systemFontOfSize:14];
    _timeLabel.textColor=UIColorRGB(kContentColor_nine);
    [self.contentView addSubview:_timeLabel];
    
    _loveButton=[[UIButton alloc] initWithFrame:CGRectMake(UI_IOS_WINDOW_WIDTH-BoundsOfScale(40), BoundsOfScale(80)-BoundsOfScale(33.5), BoundsOfScale(17), BoundsOfScale(15.5))];
    [_loveButton setImage:[UIImage imageNamed:LoveNormalImage] forState:UIControlStateNormal];
    [self.contentView addSubview:_loveButton];
    
    _loveCountLabel=[[UILabel alloc] initWithFrame:CGRectMake(UI_IOS_WINDOW_WIDTH-BoundsOfScale(65), CGRectGetMinY(_loveButton.frame)-18, BoundsOfScale(60), 15)];
    CGPoint loveImagePoint=_loveButton.center;
    _loveCountLabel.textAlignment=NSTextAlignmentCenter;
    _loveCountLabel.center=CGPointMake(loveImagePoint.x, _loveCountLabel.center.y);
    _loveCountLabel.backgroundColor=[UIColor clearColor];
    _loveCountLabel.font=[UIFont systemFontOfSize:15];
    _loveCountLabel.textColor=UIColorRGB(kContentColor_three);
    [self.contentView addSubview:_loveCountLabel];
    
    UIView *sepLine=[[UIView alloc] initWithFrame:CGRectMake(BoundsOfScale(36+32)/2, BoundsOfScale(80)-0.5, UI_IOS_WINDOW_WIDTH-BoundsOfScale(36+32), 0.5)];
    sepLine.backgroundColor=UIColorRGB(KSepLineColor_e);
    [self.contentView addSubview:sepLine];
}

-(void)setViewsFrame:(LKTypeData *)prizeData{
    
    [_typeImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@%@",SeverHost,prizeData.imageUrl]] placeholderImage:[UIImage imageWithName:@"ll"]];
    
    _prizeTitleLabel.text=prizeData.activityName;
    _timeLabel.text=[LKTools transTime:prizeData.startDate dateFormat:@"yyyy-MM-dd"];
    NSString *praisesStr;
    if(!prizeData.praises||prizeData.praises.length==0||[prizeData.praises isEqualToString:@"0"]){
        praisesStr=@"0";
        [_loveButton setImage:[UIImage imageNamed:LoveNormalImage] forState:UIControlStateNormal];
    }else{
        praisesStr=prizeData.praises;
        [_loveButton setImage:[UIImage imageNamed:LoveHighLightImage] forState:UIControlStateNormal];
    }
    _loveCountLabel.text=praisesStr;
}
@end
