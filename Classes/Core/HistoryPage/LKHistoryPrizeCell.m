//
//  LKHistoryCell.m
//  Luckeys
//
//  Created by 李锦华 on 15/10/12.
//  Copyright © 2015年 Luckeys. All rights reserved.
//

#import "LKHistoryPrizeCell.h"
#import "LKTools.h"
#import "LKHistoryBettingData.h"

@implementation LKHistoryPrizeCell{
    UIImageView *_prizeImageView;//主题图
    UIView *_backView;
    UILabel *_prizeNumLabel; //中奖号码
    UIImageView *_timeImageView; //时效图标
    UILabel *_statusLabel; //开奖状态
    UILabel *_titleLabel;
    UIImageView *_addressImageView;
    UILabel *_addressLabel;
    UIImageView *_deadlineImageView;
    UILabel *_deadlineLabel;
    UIView *_sepLine1;//分割线
    UILabel *_passwordTitleLabel;
    UILabel *_passwordLabel;//密码
    UIView *_sepLine2;
    UILabel *_shareLabel;
    UILabel *_shareNumLabel;
    UIButton *_shareBtn;
    UIImageView *_sepImageView;
    
    LKHistoryBettingData *_data;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createView];
    }
    return self;
}

-(void)createView{
    _prizeImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0,0,UI_IOS_WINDOW_WIDTH, BoundsOfScale(200))];
    [_prizeImageView setBackgroundColor:[UIColor clearColor]];
    [_prizeImageView setImage:[UIImage imageNamed:@"moren"]];
    [_prizeImageView setContentMode:UIViewContentModeScaleAspectFill];
    _prizeImageView.clipsToBounds = YES;
    [self.contentView addSubview:_prizeImageView];
    
    _backView=[[UIView alloc] initWithFrame:CGRectMake(0, _prizeImageView.maxY-BoundsOfScale(30), UI_IOS_WINDOW_WIDTH, BoundsOfScale(30))];
    [_backView setBackgroundColor:UIColorRGBA(0x000000, 0.6)];
    [self.contentView addSubview:_backView];
    
    CGSize prizeSize=[LKTools getStringSize:@"中奖号码:szdy20150101111221" fontSize:14];
    _prizeNumLabel=[[UILabel alloc] initWithFrame:CGRectMake(BoundsOfScale(12),_prizeImageView.maxY-BoundsOfScale(30) , prizeSize.width, BoundsOfScale(30))];
    _prizeNumLabel.backgroundColor=[UIColor clearColor];
    _prizeNumLabel.font=[UIFont systemFontOfSize:14];
    _prizeNumLabel.textColor=UIColorRGB(0xffffff);
    _prizeNumLabel.text=@"中奖号码:06033";
    [self.contentView addSubview:_prizeNumLabel];
    
    CGSize statusSize=[LKTools getStringSize:@"已开奖" fontSize:14];
    _timeImageView=[[UIImageView alloc] initWithFrame:CGRectMake(UI_IOS_WINDOW_WIDTH-BoundsOfScale(19)-statusSize.width-BoundsOfScale(10), _prizeImageView.maxY-BoundsOfScale(30)+(BoundsOfScale(30)-15.5)/2,15.5, 15.5)];
    [_timeImageView setBackgroundColor:[UIColor clearColor]];
    [_timeImageView setImage:[UIImage imageNamed:@"history_time"]];
    [self.contentView addSubview:_timeImageView];
    
    _statusLabel=[[UILabel alloc] initWithFrame:CGRectMake(_timeImageView.maxX+BoundsOfScale(7), _prizeImageView.maxY-BoundsOfScale(30), statusSize.width, BoundsOfScale(30))];
    _statusLabel.backgroundColor=[UIColor clearColor];
    _statusLabel.font=[UIFont systemFontOfSize:14];
    _statusLabel.textColor=UIColorRGB(0xffffff);
    _statusLabel.text=@"已开奖";
    [self.contentView addSubview:_statusLabel];
    
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(14,CGRectGetMaxY(_prizeImageView.frame)+BoundsOfScale(10), 300, 20)];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.textColor = UIColorRGB(0x666666);
    _titleLabel.font = [UIFont systemFontOfSize:17];
    _titleLabel.text = @"[电影票] 大圣归来";
    [self.contentView addSubview:_titleLabel];
    
    _addressImageView  = [[UIImageView alloc] initWithFrame:CGRectMake(_titleLabel.x, _titleLabel.maxY + 10, BoundsOfScale(11), BoundsOfScale(15))];
    _addressImageView.image = [UIImage imageWithName:@"type_place_small"];
    [self.contentView addSubview:_addressImageView];
    
    _addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(_addressImageView.maxX + 7, _addressImageView.y, 300, _addressImageView.height)];
    _addressLabel.width = UI_IOS_WINDOW_WIDTH/2.0 - _addressLabel.x;
    _addressLabel.backgroundColor = [UIColor clearColor];
    _addressLabel.textColor = UIColorRGB(0x999999);
    _addressLabel.font = [UIFont systemFontOfSize:FontOfScale(12)];
    _addressLabel.text = @"深圳保利影院(大中华店)";
    [self.contentView addSubview:_addressLabel];
    
    _timeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(UI_IOS_WINDOW_WIDTH/2.0+5, _addressImageView.y, _addressImageView.width, _addressImageView.height)];
    _timeImageView.image = [UIImage imageWithName:@"type_time_small"];
    [self.contentView addSubview:_timeImageView];
    
    _deadlineLabel = [[UILabel alloc] initWithFrame:CGRectMake(_timeImageView.maxX + 7, _timeImageView.y, 300, _timeImageView.height)];
    _deadlineLabel.width = UI_IOS_WINDOW_WIDTH/2.0;
    _deadlineLabel.backgroundColor = [UIColor clearColor];
    _deadlineLabel.textColor = _addressLabel.textColor;
    _deadlineLabel.font = _addressLabel.font;
    _deadlineLabel.text = @"2015.12.10至2015.12.31";
    [self.contentView addSubview:_deadlineLabel];
    
    _sepLine1=[[UIView alloc] initWithFrame:CGRectMake(BoundsOfScale(12), _prizeImageView.maxY+BoundsOfScale(67.5), UI_IOS_WINDOW_WIDTH-BoundsOfScale(24), 0.5)];
    [_sepLine1 setBackgroundColor:UIColorRGB(0xe9e9e9)];
    [self.contentView addSubview:_sepLine1];
    
    _showBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _showBtn.frame=CGRectMake(UI_IOS_WINDOW_WIDTH-BoundsOfScale(76), _sepLine1.maxY+BoundsOfScale(35/2), BoundsOfScale(64), BoundsOfScale(30));
    _showBtn.layer.borderColor=[[UIColor redColor] CGColor];
    _showBtn.layer.cornerRadius=2.f;
    _showBtn.layer.borderWidth=0.5f;
    _showBtn.titleLabel.font = [UIFont systemFontOfSize:BoundsOfScale(14)];
    [_showBtn setTitle:@"晒一晒" forState:UIControlStateNormal];
    [_showBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_showBtn addTarget:self action:@selector(showBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_showBtn];
    
    CGSize passwordTitleSize=[LKTools getStringSize:@"兑换密码:" fontSize:13];
    
    _passwordTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(BoundsOfScale(15), _sepLine1.maxY+(BoundsOfScale(65)-passwordTitleSize.height)/2, passwordTitleSize.width+5, passwordTitleSize.height)];
    _passwordTitleLabel.backgroundColor = [UIColor clearColor];
    _passwordTitleLabel.textColor = UIColorRGB(0xf75347);
    _passwordTitleLabel.font = [UIFont systemFontOfSize:13];
    _passwordTitleLabel.text = @"兑换密码:";
    [self.contentView addSubview:_passwordTitleLabel];
    
    _passwordLabel = [[UILabel alloc] initWithFrame:CGRectMake(_passwordTitleLabel.maxX+3,_passwordTitleLabel.origin.y-5, _showBtn.origin.x-_passwordTitleLabel.maxX, passwordTitleSize.height+8)];
    _passwordLabel.backgroundColor = [UIColor clearColor];
    _passwordLabel.textColor = UIColorRGB(0xf75347);
    _passwordLabel.font = [UIFont systemFontOfSize:19];
    _passwordLabel.text = @"0973 3666 4148";
    [self.contentView addSubview:_passwordLabel];
    
    _sepLine2=[[UIView alloc] initWithFrame:CGRectMake(BoundsOfScale(12), _sepLine1.maxY+BoundsOfScale(64.5), UI_IOS_WINDOW_WIDTH-BoundsOfScale(24), 0.5)];
    [_sepLine2 setBackgroundColor:UIColorRGB(0xe9e9e9)];
    [self.contentView addSubview:_sepLine2];
    
    _shareBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _shareBtn.frame=CGRectMake(UI_IOS_WINDOW_WIDTH-BoundsOfScale(76), _sepLine1.maxY+BoundsOfScale(35/2), BoundsOfScale(64), BoundsOfScale(30));
    _shareBtn.center=CGPointMake(_showBtn.center.x, _showBtn.center.y+65+8);
    [_shareBtn setTitle:@"分享" forState:UIControlStateNormal];
    [_shareBtn setBackgroundColor:UIColorRGB(0xf75347)];
    _shareBtn.layer.cornerRadius=2.f;
    [_shareBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.contentView addSubview:_shareBtn];
    
    
    _shareLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0, passwordTitleSize.width, passwordTitleSize.height)];
    _shareLabel.center=CGPointMake(_passwordTitleLabel.center.x, _passwordTitleLabel.centerY+BoundsOfScale(58));
    _shareLabel.backgroundColor = [UIColor clearColor];
    _shareLabel.textColor = UIColorRGB(0xf75347);
    _shareLabel.font = [UIFont systemFontOfSize:13];
    _shareLabel.text = @"分享码 :";
    [self.contentView addSubview:_shareLabel];
    
    _shareBtn.center=CGPointMake(_shareBtn.center.x, _shareLabel.center.y);
    
    _shareNumLabel= [[UILabel alloc] initWithFrame:CGRectMake(0,0,_passwordLabel.frame.size.width,_passwordLabel.frame.size.height)];
    _shareNumLabel.center=CGPointMake(_passwordLabel.center.x, _passwordLabel.centerY+BoundsOfScale(58));
    _shareNumLabel.backgroundColor = [UIColor clearColor];
    _shareNumLabel.textColor = UIColorRGB(0xf75347);
    _shareNumLabel.font = [UIFont systemFontOfSize:19];
    _shareNumLabel.text = @"0973 3666 4148";
    [self.contentView addSubview:_shareNumLabel];
    
    _sepImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0,BoundsOfScale(392)-6,UI_IOS_WINDOW_WIDTH, 6)];
    [_sepImageView setBackgroundColor:[UIColor clearColor]];
    [_sepImageView setImage:[UIImage imageNamed:@"sep_image"]];
    [self.contentView addSubview:_sepImageView];
}


-(void)setPrizeCellData:(LKHistoryBettingData*)data{

    _data = data;
    
    NSArray *imageActitvtyArray = [data.imageUrl componentsSeparatedByString:@","];
    if (imageActitvtyArray.count > 0) {
        NSString *dityImageStr = [NSString stringWithFormat:@"http://%@%@",SeverHost,[imageActitvtyArray objectAtIndex:0]];
        [_prizeImageView sd_setImageWithURL:[NSURL URLWithString:dityImageStr] placeholderImage:[UIImage imageWithName:@"moren"]];
    }else{
        NSString *dityImageStr = [NSString stringWithFormat:@"http://%@%@",SeverHost,@""];
        [_prizeImageView sd_setImageWithURL:[NSURL URLWithString:dityImageStr] placeholderImage:[UIImage imageWithName:@"moren"]];
    }
    
    [_prizeNumLabel setText:[NSString stringWithFormat:@"中奖号码:%@",data.userCode]];
    
    NSString *stratDate = [NSString stringWithFormat:@"%@", data.startDate];
    NSString *endDate = [NSString stringWithFormat:@"%@", data.startDate];
    
    _deadlineLabel.text =[NSString stringWithFormat:@"%@至%@",[LKTools transTime:stratDate dateFormat:@"YYYY.MM.dd"],[LKTools transTime:endDate dateFormat:@"YYYY.MM.dd"]];
    _passwordLabel.text= data.winCode;
    _shareNumLabel.text=@"";
    _addressLabel.text=data.locationName;
    _titleLabel.text=data.activityName;
    
    _sepLine2.hidden = YES;
    _shareLabel.hidden = YES;
    _shareBtn.hidden = YES;
    _shareNumLabel.hidden = YES;
    _sepImageView.frame = CGRectMake(0,BoundsOfScale(332)-3,UI_IOS_WINDOW_WIDTH, 6);

}

- (void)showBtnAction:(UIButton*)button {
    if (_delegate && [_delegate respondsToSelector:@selector(handleShowButton:)]) {
        [_delegate handleShowButton:_data];
    }
}

+ (CGFloat)getHistoryCellHeight:(LKHistoryBettingData *)data
{
    return BoundsOfScale(332);
    //return BoundsOfScale(392);
}

@end
