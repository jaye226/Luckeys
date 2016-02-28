//
//  LKHistoryBettingCell.m
//  Luckeys
//
//  Created by 李锦华 on 15/10/12.
//  Copyright © 2015年 Luckeys. All rights reserved.
//

#import "LKHistoryBettingCell.h"
#import "LKHistoryBettingData.h"
#import "LKShowBettingListView.h"

@interface LKHistoryBettingCell () <MZTimerLabelDelegate>
{
    UIImageView *_prizeImageView;//主题图
    UIView *_backView;
    UILabel *_prizeNumLabel; //中奖号码
    UIImageView *_timeImageView; //时效图标
    UIImageView *_typetimeImageView;
    UILabel *_statusLabel; //开奖状态
    UILabel *_titleLabel;
    UIImageView *_addressImageView;
    UILabel *_addressLabel;
    UIImageView *_deadlineImageView;
    UILabel *_deadlineLabel;
    MZTimerLabel *_timer;
    
    LKHistoryBettingData* _historyBettingData;
    
    int _hours;
    
    int _minutes;
    
    int _seconds;
}

@end

@implementation LKHistoryBettingCell

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
    [_prizeImageView setContentMode:UIViewContentModeScaleAspectFill];
    _prizeImageView.clipsToBounds = YES;
    [_prizeImageView setImage:[UIImage imageNamed:@"moren"]];
    [self.contentView addSubview:_prizeImageView];
    
    _likeBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _likeBtn.frame=CGRectMake(UI_IOS_WINDOW_WIDTH-BoundsOfScale(27),BoundsOfScale(14), BoundsOfScale(17), BoundsOfScale(15.5));
    [_likeBtn setImage:[UIImage imageNamed:@"betting_heart"] forState:UIControlStateNormal];
    [_likeBtn addTarget:self action:@selector(clickLikeBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_likeBtn];
    
    _backView=[[UIView alloc] initWithFrame:CGRectMake(0, _prizeImageView.maxY-BoundsOfScale(30), UI_IOS_WINDOW_WIDTH, BoundsOfScale(30))];
    [_backView setBackgroundColor:UIColorRGBA(0x000000, 0.6)];
    [self.contentView addSubview:_backView];
    
    _prizeNumLabel=[[UILabel alloc] initWithFrame:CGRectMake(BoundsOfScale(12),_prizeImageView.maxY-BoundsOfScale(30) , UI_IOS_WINDOW_WIDTH/2-BoundsOfScale(12), BoundsOfScale(30))];
    _prizeNumLabel.backgroundColor=[UIColor clearColor];
    _prizeNumLabel.font=[UIFont systemFontOfSize:14];
    _prizeNumLabel.textColor=UIColorRGB(0xffffff);
    //_prizeNumLabel.text=@"我的奖券:06033";
    [self.contentView addSubview:_prizeNumLabel];
    _prizeNumLabel.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizerInside)];
    [_prizeNumLabel addGestureRecognizer:tapGestureRecognizer];
    
    CGSize statusSize=[LKTools getStringSize:@"距离开奖00:00:09" fontSize:14];
    _timeImageView=[[UIImageView alloc] initWithFrame:CGRectMake(UI_IOS_WINDOW_WIDTH-BoundsOfScale(19)-statusSize.width-15, _prizeImageView.maxY-BoundsOfScale(30)+(BoundsOfScale(30)-15.5)/2,15.5, 15.5)];
    [_timeImageView setBackgroundColor:[UIColor clearColor]];
    [_timeImageView setImage:[UIImage imageNamed:@"history_time"]];
    [self.contentView addSubview:_timeImageView];
    
    _statusLabel=[[UILabel alloc] initWithFrame:CGRectMake(_timeImageView.maxX+BoundsOfScale(7), _prizeImageView.maxY-BoundsOfScale(30), statusSize.width+15, BoundsOfScale(30))];
    _statusLabel.backgroundColor=[UIColor clearColor];
    _statusLabel.font=[UIFont systemFontOfSize:14];
    _statusLabel.textColor=UIColorRGB(0xffffff);
    _statusLabel.textAlignment = NSTextAlignmentLeft;
    _statusLabel.text=@"00:00:00";
    [self.contentView addSubview:_statusLabel];
        
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(14,CGRectGetMaxY(_prizeImageView.frame)+BoundsOfScale(10), 300, 20)];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.textColor = UIColorRGB(0x666666);
    _titleLabel.font = [UIFont systemFontOfSize:17];
    _titleLabel.text = @"[电影票] 大圣归来";
    [self.contentView addSubview:_titleLabel];
    
    _addressImageView  = [[UIImageView alloc] initWithFrame:CGRectMake(_titleLabel.x, _titleLabel.maxY + 20, BoundsOfScale(11), BoundsOfScale(15))];
    _addressImageView.image = [UIImage imageWithName:@"betting_num"];
    [self.contentView addSubview:_addressImageView];
    
    _addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(_addressImageView.maxX + 7, _addressImageView.y, 300, _addressImageView.height)];
    _addressLabel.width = UI_IOS_WINDOW_WIDTH/2.0 - _addressLabel.x;
    _addressLabel.backgroundColor = [UIColor clearColor];
    _addressLabel.textColor = UIColorRGB(0x999999);
    _addressLabel.font = [UIFont systemFontOfSize:FontOfScale(12)];
    _addressLabel.text = @"开奖号码:06034";
    [self.contentView addSubview:_addressLabel];
    
    _typetimeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(UI_IOS_WINDOW_WIDTH/2.0+5, _addressImageView.y, _addressImageView.width, _addressImageView.height)];
    _typetimeImageView.image = [UIImage imageWithName:@"type_time_small"];
    [self.contentView addSubview:_typetimeImageView];
    
    _deadlineLabel = [[UILabel alloc] initWithFrame:CGRectMake(_typetimeImageView.maxX + 7, _typetimeImageView.y, 300, _typetimeImageView.height)];
    _deadlineLabel.width = UI_IOS_WINDOW_WIDTH/2.0;
    _deadlineLabel.backgroundColor = [UIColor clearColor];
    _deadlineLabel.textColor = _addressLabel.textColor;
    _deadlineLabel.font = _addressLabel.font;
    _deadlineLabel.text = @"中奖者:巴宝利";
    [self.contentView addSubview:_deadlineLabel];
}

- (void)tapGestureRecognizerInside
{
    if (_historyBettingData.listCode.count > 0)
    {
        [LKShowBettingListView showListView:_historyBettingData.listCode];
    }
}

-(void)setBettingCellData:(LKHistoryBettingData*)data{
    
    if (_timer) {
        [_timer pause];
        [_timer removeFromSuperview];
        _timer = nil;
    }
    
    _historyBettingData = data;
    if ([data.chipsStatus integerValue] == 1 && [data.countDown integerValue] >= 1) {
        if (!_timer) {
            _timer = [[MZTimerLabel alloc] initWithLabel:_statusLabel andTimerType:MZTimerLabelTypeTimer];
            _timer.timeLabel.textColor = [UIColor redColor];
            _timer.timeLabel.textAlignment = NSTextAlignmentCenter;
            _timer.timeFormat = @"HH:mm:ss SS";
            _timer.delegate = self;
            [_timer setCountDownTime:[data.countDown integerValue]];
            [_timer start];
        }else{
            [_timer setCountDownTime:[data.countDown integerValue]];
            [_timer start];
        }
        
    }
    if([data.chipsStatus integerValue] == 1 && [data.countDown integerValue] >= 1)
    {
        _addressLabel.text=[NSString stringWithFormat:@"未开奖"];//开奖号码:
    }else if ([data.chipsStatus integerValue] == 1 && [data.countDown integerValue] == 0)
    {
        _statusLabel.text=@"已开奖";
        _addressLabel.text=[NSString stringWithFormat:@"%@", data.userCode];//开奖号码:
    }else{
        _statusLabel.text=@"未开奖";
        _addressLabel.text=[NSString stringWithFormat:@"未开奖"];//开奖号码:
    }
    
    CGSize statusSize=[LKTools getStringSize:_statusLabel.text fontSize:14];
    _timeImageView.frame = CGRectMake(UI_IOS_WINDOW_WIDTH-BoundsOfScale(19)-statusSize.width-BoundsOfScale(10), _prizeImageView.maxY-BoundsOfScale(30)+(BoundsOfScale(30)-15.5)/2,15.5, 15.5);
    
    _statusLabel.frame = CGRectMake(_timeImageView.maxX+BoundsOfScale(7), _prizeImageView.maxY-BoundsOfScale(30), statusSize.width, BoundsOfScale(30));
    
    NSArray *imageActitvtyArray = [data.imageUrl componentsSeparatedByString:@","];
    if (imageActitvtyArray.count > 0) {
        NSString *dityImageStr = [NSString stringWithFormat:@"http://%@%@",SeverHost,[imageActitvtyArray objectAtIndex:0]];
        [_prizeImageView sd_setImageWithURL:[NSURL URLWithString:dityImageStr] placeholderImage:[UIImage imageWithName:@"moren"]];
    }else{
        NSString *dityImageStr = [NSString stringWithFormat:@"http://%@%@",SeverHost,@""];
        [_prizeImageView sd_setImageWithURL:[NSURL URLWithString:dityImageStr] placeholderImage:[UIImage imageWithName:@"moren"]];
    }
    
    [_prizeNumLabel setText:[NSString stringWithFormat:@"我的奖券"]];
    
    NSString *stratDate = [NSString stringWithFormat:@"%@", data.startDate];
    NSString *endDate = [NSString stringWithFormat:@"%@", data.startDate];
    
    _deadlineLabel.text =[NSString stringWithFormat:@"%@至%@",[LKTools transTime:stratDate dateFormat:@"YYYY.MM.dd"],[LKTools transTime:endDate dateFormat:@"YYYY.MM.dd"]];
    _titleLabel.text=data.activityName;
    
    [self resetLikeImage:data];
}

-(void)timerLabel:(MZTimerLabel*)timerLabel finshedCountDownTimerWithTime:(NSTimeInterval)countTime
{
    [_timer pause];
    _timer.timeLabel = nil;
    [_timer removeFromSuperview];
    _timer = nil;
    [self performSelectorOnMainThread:@selector(timerFinshed) withObject:nil waitUntilDone:YES];
}

- (void)timerFinshed
{
    CGSize statusSize=[LKTools getStringSize:@"已开奖" fontSize:14];

    _timeImageView.frame=CGRectMake(UI_IOS_WINDOW_WIDTH-BoundsOfScale(19)-statusSize.width-BoundsOfScale(10), _prizeImageView.maxY-BoundsOfScale(30)+(BoundsOfScale(30)-15.5)/2,15.5, 15.5);
    _statusLabel.frame=CGRectMake(_timeImageView.maxX+BoundsOfScale(7), _prizeImageView.maxY-BoundsOfScale(30), statusSize.width, BoundsOfScale(30));
    _statusLabel.textColor=UIColorRGB(0xffffff);
    _statusLabel.text=@"已开奖";
    _addressLabel.text=[NSString stringWithFormat:@"开奖号码:%@",_historyBettingData.userCode];
}

- (void)resetLikeImage:(LKHistoryBettingData*)data {
    if ([data.iLike boolValue]) {
        [_likeBtn setImage:[UIImage imageWithName:@"home_heart_on"] forState:UIControlStateNormal];
    }
    else
    {
        [_likeBtn setImage:[UIImage imageWithName:@"home_heart"] forState:UIControlStateNormal];
    }
    
}

-(void)clickLikeBtn:(UIButton*)sender{
    if(_bettingDelegate&&[_bettingDelegate respondsToSelector:@selector(bettingLike:)]){
        [_bettingDelegate bettingLike:sender.tag];
    }
}

@end
