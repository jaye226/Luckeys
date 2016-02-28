//
//  LKDetailsHeadView.m
//  Luckeys
//
//  Created by lishaowei on 15/10/12.
//  Copyright © 2015年 Luckeys. All rights reserved.
//

#import "LKDetailsHeadView.h"
#import "PBArrowMarkView.h"

@interface LKDetailsHeadView () <MZTimerLabelDelegate>
{
    NSInteger timerInteger;
    
    NSTimer * _totleTimer;
    NSTimeInterval _runTime;
    
    LKDetailsData *_detailsData;
}

@property (nonatomic,strong) UIImageView * detailImage;

@property (nonatomic,strong) PBArrowMarkView * arrowView;
@property (nonatomic,strong) UILabel * priceLabel;

@property (nonatomic,strong) UIProgressView * progressView;
@property (nonatomic,strong) UILabel * titleLabel;
@property (nonatomic,strong) UILabel * addressLabel;
@property (nonatomic,strong) UILabel * dateLabel;
@property (nonatomic,strong) UILabel * contentLabel;
@property (nonatomic,strong) UIView * lineView;
@property (nonatomic,strong) UILabel * timerLabel;//倒计时
@property (nonatomic,strong) UIImageView * gunImageView; //滚奖背景
@property (nonatomic,strong) MZTimerLabel *timer;
@property (nonatomic,strong) UIImageView *address;
@property (nonatomic,strong) UIImageView * date;
@property (nonatomic,strong) UIImageView *timeImageView;
@property (nonatomic,strong) UILabel * statusLabel;
@property (nonatomic,strong) UIView * winUserView;
@property (nonatomic,strong) UIImageView *headImage;
@property (nonatomic,strong) UILabel *praisesLabel;
@property (nonatomic,strong) UIButton *winButton;
@property (nonatomic,strong) UIButton *likeImage;
                                                                       
@end

@implementation LKDetailsHeadView

- (void)dealloc
{
    self.timer.delegate = nil;
    self.delegate = nil;
    if (_totleTimer) {
        [_totleTimer invalidate];
    }
}

- (id)initWithData:(LKDetailsData *)detailsData
{
    self = [super init];
    if (self) {
        _detailsData = detailsData;
        [self addView:detailsData];
        timerInteger = 0;

    }
    return self;
}

- (void)addView:(LKDetailsData *)detailsData
{
    _detailImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, UI_IOS_WINDOW_WIDTH, BoundsOfScale(200))];
    [_detailImage setContentMode:UIViewContentModeScaleAspectFill];
    _detailImage.clipsToBounds = YES;
    [self addSubview:_detailImage];
    [_detailImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@%@",SeverHost,detailsData.imageUrl]] placeholderImage:[UIImage imageWithName:@"moren"]];
    
    self.likeImage = [[UIButton alloc] initWithFrame:CGRectMake(0, BoundsOfScale(20), BoundsOfScale(19), BoundsOfScale(16.5))];
    self.likeImage.x = _detailImage.width - BoundsOfScale(12) - _likeImage.width;
    if ([detailsData.iLike boolValue]) {
        [self.likeImage setImage:[UIImage imageWithName:@"home_heart_on"] forState:UIControlStateNormal];
    }
    else
    {
        [self.likeImage setImage:[UIImage imageWithName:@"home_heart"] forState:UIControlStateNormal];
    }
    [self.likeImage addTarget:self action:@selector(likeButtonInside) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.likeImage];
    
    _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, _detailImage.maxY, _detailImage.width, 4)];
    _progressView.progressTintColor =UIColorRGB(0x36e07b);
    _progressView.trackTintColor = UIColorRGB(0x7b7b7b);
    [self addSubview:_progressView];
    
    //箭头视图
    _arrowView = [[PBArrowMarkView alloc] initWithFrame:CGRectMake(0, 0, 90, 40)];
    _arrowView.fillColor = UIColorMakeRGBA(0, 0, 0, 0.7);
    _arrowView.y = _progressView.y - _arrowView.height;
    _arrowView.arrowPoint = CGPointMake(140, _arrowView.y);
    [self addSubview:_arrowView];

    _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _arrowView.width, _arrowView.height-_arrowView.arrowHeight)];
    _priceLabel.backgroundColor = [UIColor clearColor];
    _priceLabel.textColor = [UIColor whiteColor];
    _priceLabel.font = [UIFont systemFontOfSize:FontOfScale(16)];
    _priceLabel.textAlignment = NSTextAlignmentCenter;
    
    NSString *totalPrice = STR_IS_NULL(detailsData.totalPrice);
    NSString *betsUnitPrice = [NSString stringWithFormat:@"%ld", [detailsData.betNumber integerValue]*[detailsData.unitPrice integerValue]];
    [_arrowView addSubview:_priceLabel];
    
    _progressView.progress = [betsUnitPrice floatValue]/[totalPrice floatValue];
    
    _priceLabel.text = [NSString stringWithFormat:@"¥%@/¥%@", betsUnitPrice, totalPrice];
    _arrowView.width = [LKTools getStringSize:_priceLabel.text fontSize:BoundsOfScale(16)].width;
    _priceLabel.width = _arrowView.width;
    _arrowView.arrowPoint = CGPointMake(_arrowView.realWidth*_progressView.progress, _arrowView.y);
    
    _gunImageView = [[UIImageView alloc] initWithFrame:CGRectMake(BoundsOfScale(10), _progressView.maxY+BoundsOfScale(10), UI_IOS_WINDOW_WIDTH-BoundsOfScale(20), BoundsOfScale(60))];
    _gunImageView.image = [UIImage imageWithName:@"detailsimage_bg_gun"];
    [self addSubview:_gunImageView];
    _gunImageView.hidden = YES;
    
    CGFloat maxY = 0;
    
    if ([detailsData.chipsStatus isEqualToString:@"1"]&&(detailsData.countDown.length<=0||[detailsData.countDown integerValue]==0))
    {
        //已开奖
        _gunImageView.frame = CGRectMake(BoundsOfScale(10), _progressView.maxY+BoundsOfScale(10), UI_IOS_WINDOW_WIDTH-BoundsOfScale(20), BoundsOfScale(60));
        [self endTheLottery:detailsData];
        _arrowView.hidden = NO;
        
        _winUserView = [[UIView alloc] initWithFrame:CGRectMake(0,  _gunImageView.maxY+BoundsOfScale(10), self.width, BoundsOfScale(90))];
        _winUserView.backgroundColor = [UIColor clearColor];
        [self addSubview:_winUserView];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(BoundsOfScale(10), 0, self.width, 20)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont systemFontOfSize:FontOfScale(15)];
        titleLabel.textColor = UIColorRGB(0x333333);
        titleLabel.text = @"中奖者";
        [_winUserView addSubview:titleLabel];
        
        UIImageView *winHeadImageView = [[UIImageView alloc] initWithFrame:CGRectMake(BoundsOfScale(10), titleLabel.maxY+BoundsOfScale(10), BoundsOfScale(50), BoundsOfScale(50))];
        winHeadImageView.image = [UIImage imageNamed:@"defaulthead"];
        [winHeadImageView setContentMode:UIViewContentModeScaleAspectFill];
        winHeadImageView.clipsToBounds = YES;
        winHeadImageView.layer.cornerRadius = CGRectGetMidX(winHeadImageView.bounds);
        winHeadImageView.layer.masksToBounds = YES;
        [winHeadImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@%@",SeverHost,detailsData.winUserData.userHead]] placeholderImage:[UIImage imageWithName:@"defaulthead"]];
        winHeadImageView.userInteractionEnabled = YES;
        NSLog(@"%@", [NSString stringWithFormat:@"http://%@%@",SeverHost,detailsData.winUserData.userHead]);
        [_winUserView addSubview:winHeadImageView];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeWinHeadImageTapGestureRecognizer)];
        [winHeadImageView addGestureRecognizer:tapGesture];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(winHeadImageView.frame)+BoundsOfScale(11), titleLabel.maxY+BoundsOfScale(10), UI_IOS_WINDOW_WIDTH-(CGRectGetMaxX(winHeadImageView.frame)+BoundsOfScale(11)+BoundsOfScale(80)), BoundsOfScale(25))];
        nameLabel.font = [UIFont systemFontOfSize:15];
        nameLabel.textColor = UIColorRGB(0x333333);
        nameLabel.text = detailsData.winUserData.nickName.length>0?detailsData.winUserData.nickName:@"匿名";
        [_winUserView addSubview:nameLabel];
        _winUserView.userInteractionEnabled = YES;
        
        UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(winHeadImageView.frame)+BoundsOfScale(11), CGRectGetMaxY(nameLabel.frame)+BoundsOfScale(5), UI_IOS_WINDOW_WIDTH-(CGRectGetMaxX(winHeadImageView.frame)+BoundsOfScale(11)+BoundsOfScale(80)), BoundsOfScale(20))];
        timeLabel.font = [UIFont systemFontOfSize:FontOfScale(13)];
        timeLabel.textColor = UIColorRGB(0x999999);
        NSString *endDate = [NSString transTime:STR_IS_NULL(detailsData.endDate) Format:@"yyyy-MM-dd HH:mm:ss"];
        timeLabel.text = endDate;
        [_winUserView addSubview:timeLabel];
        
        _winButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _winButton.frame = CGRectMake(_winUserView.width-BoundsOfScale(40)-BoundsOfScale(10), (_winUserView.height-BoundsOfScale(40))/2, BoundsOfScale(40), BoundsOfScale(40));
        [_winUserView addSubview:_winButton];
        [_winButton addTarget:self action:@selector(changeWinUserBtnUpInside) forControlEvents:UIControlEventTouchUpInside];
        
        _praisesLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _winButton.width, BoundsOfScale(20))];
        _praisesLabel.backgroundColor = [UIColor clearColor];
        _praisesLabel.font = [UIFont systemFontOfSize:15];
        _praisesLabel.textColor = UIColorRGB(0x333333);
        _praisesLabel.textAlignment = NSTextAlignmentCenter;
        if (detailsData.winUserData.praises.length>0 && [detailsData.winUserData.praises integerValue] > 0) {
            _praisesLabel.text = detailsData.winUserData.praises;
        }else{
            _praisesLabel.text = @"0";
            
        }
        [_winButton addSubview:_praisesLabel];
        
        _headImage = [[UIImageView alloc] initWithFrame:CGRectMake((_winButton.width-BoundsOfScale(15))/2,20+(20-BoundsOfScale(13.5)), BoundsOfScale(15), BoundsOfScale(13.5))];
        if (detailsData.winUserData.isPraises.length <= 0 || [detailsData.winUserData.isPraises isEqualToString:@"0"]) {
            [_headImage setImage:[UIImage imageNamed:@"home_heart"]];
        }else{
            [_headImage setImage:[UIImage imageNamed:@"home_heart_on"]];
            _winButton.userInteractionEnabled = NO;
        }
        [_winButton addSubview:_headImage];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(BoundsOfScale(15), _winUserView.height-1 -SINGLE_LINE_ADJUST_OFFSET, UI_IOS_WINDOW_WIDTH-BoundsOfScale(15)*2, SINGLE_LINE_BOUNDS)];
        lineView.backgroundColor = UIColorRGB(0xe9e9e9);
        [_winUserView addSubview:lineView];
        
        maxY = _winUserView.maxY+BoundsOfScale(10);
        
    }
    else if ([detailsData.chipsStatus isEqualToString:@"1"]&&detailsData.countDown.length >0)
    {
        //倒计时
        _gunImageView.frame = CGRectMake(BoundsOfScale(10), _progressView.maxY+BoundsOfScale(7), UI_IOS_WINDOW_WIDTH-BoundsOfScale(20), BoundsOfScale(0));
        _arrowView.hidden = YES;
        [self startTheLottery:detailsData];
        
        maxY = _gunImageView.maxY+BoundsOfScale(10);

    }
    else
    {
        //未开奖
        _gunImageView.frame = CGRectMake(BoundsOfScale(10), _progressView.maxY+BoundsOfScale(7), UI_IOS_WINDOW_WIDTH-BoundsOfScale(20), BoundsOfScale(0));
        _arrowView.hidden = NO;
        
        maxY = _gunImageView.maxY+BoundsOfScale(10);

    }
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(BoundsOfScale(14), maxY, UI_IOS_WINDOW_WIDTH-BoundsOfScale(14)*2, BoundsOfScale(20))];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.textColor = UIColorRGB(0x666666);
    _titleLabel.font = [UIFont systemFontOfSize:FontOfScale(17)];
    _titleLabel.text = STR_IS_NULL(detailsData.activityName);
    [self addSubview:_titleLabel];
    
    _address = [[UIImageView alloc] initWithFrame:CGRectMake(_titleLabel.x, _titleLabel.maxY + 10, BoundsOfScale(11), BoundsOfScale(15))];
    _address.image = [UIImage imageWithName:@"type_place_small"];
    [self addSubview:_address];
    
    _addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(_address.maxX + BoundsOfScale(7), _address.y, UI_IOS_WINDOW_WIDTH- (_address.maxX + 7) -BoundsOfScale(14), _address.height)];
    _addressLabel.backgroundColor = [UIColor clearColor];
    _addressLabel.textColor = UIColorRGB(0x999999);
    _addressLabel.font = [UIFont systemFontOfSize:FontOfScale(12)];
    _addressLabel.text = STR_IS_NULL(detailsData.locationName);
    [self addSubview:_addressLabel];
    
    _date = [[UIImageView alloc] initWithFrame:CGRectMake(_titleLabel.x, _addressLabel.maxY+BoundsOfScale(10), _address.width, _address.height)];
    _date.image = [UIImage imageWithName:@"type_time_small"];
    [self addSubview:_date];
    
    _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(_address.maxX + BoundsOfScale(7), _addressLabel.maxY+BoundsOfScale(10), UI_IOS_WINDOW_WIDTH-(_address.maxX + BoundsOfScale(7)+BoundsOfScale(14)), _date.height)];
    _dateLabel.backgroundColor = [UIColor clearColor];
    _dateLabel.textColor = _addressLabel.textColor;
    _dateLabel.font = _addressLabel.font;
    NSString *strDate = [NSString transTime:STR_IS_NULL(detailsData.startDate) Format:@"yyyy-MM-dd HH:mm:ss"];
    NSString *endDate = [NSString transTime:STR_IS_NULL(detailsData.endDate) Format:@"yyyy-MM-dd HH:mm:ss"];
    _dateLabel.text = [NSString stringWithFormat:@"%@到%@", strDate, endDate];
    [self addSubview:_dateLabel];
    
    NSString *contentStr = @"";
    if (detailsData.descri.length <= 0) {
        contentStr = @"深圳地铁附属资源由资源开发分公司进行统一经营管理,现已形成商业经营、广告传媒、通信信息、文化拓展等4大核心业务,为地铁乘客提供全方位的商业服务。 商业经营广告";
    }else{
        contentStr = detailsData.descri;
    }
    
    NSMutableAttributedString *attrib = [self attributedStringWithString:contentStr withFont:[UIFont systemFontOfSize:FontOfScale(15)] withColor:UIColorRGB(0x666666) withLineSpacing:4];
    CGRect rect = [self getRectWithSize:UI_IOS_WINDOW_WIDTH-BoundsOfScale(14)*2 withAttributedString:attrib];
    
    _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(BoundsOfScale(14), _dateLabel.maxY+BoundsOfScale(10), UI_IOS_WINDOW_WIDTH-BoundsOfScale(14)*2, rect.size.height)];
    _contentLabel.numberOfLines = 0;
    _contentLabel.attributedText = attrib;
    [self addSubview:_contentLabel];
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(BoundsOfScale(15), CGRectGetMaxY(_contentLabel.frame)+BoundsOfScale(9), UI_IOS_WINDOW_WIDTH-BoundsOfScale(15)*2 -SINGLE_LINE_ADJUST_OFFSET, SINGLE_LINE_BOUNDS)];
    _lineView.backgroundColor = UIColorRGB(0xe9e9e9);
    [self addSubview:_lineView];
    
    self.frame = CGRectMake(0, 0, UI_IOS_WINDOW_WIDTH, _contentLabel.maxY+BoundsOfScale(10));
    
}

- (void)showGunView
{
    _gunImageView.frame = CGRectMake(BoundsOfScale(10), _progressView.maxY+BoundsOfScale(10), UI_IOS_WINDOW_WIDTH-BoundsOfScale(20), BoundsOfScale(60));
    _gunImageView.hidden = NO;
    
    _titleLabel.y = _gunImageView.maxY+BoundsOfScale(10);
    _address.y = _titleLabel.maxY + 10;
    _addressLabel.y = _titleLabel.maxY + 10;
    _date.y = _addressLabel.maxY+BoundsOfScale(10);
    _dateLabel.y = _addressLabel.maxY+BoundsOfScale(10);
    _contentLabel.y = _dateLabel.maxY+BoundsOfScale(10);
    _lineView.y = CGRectGetMaxY(_contentLabel.frame)+BoundsOfScale(9);
    self.frame = CGRectMake(0, 0, UI_IOS_WINDOW_WIDTH, _contentLabel.maxY+BoundsOfScale(10));

    for (NSInteger i = 0; i < 5; i++)
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(BoundsOfScale(15)+((_gunImageView.width-BoundsOfScale(30))/5)*i, 0, (_gunImageView.width-BoundsOfScale(30))/5, _gunImageView.height)];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:FontOfScale(45)];
        if (i == 1 || i == 0) {
            label.textColor = UIColorRGB(0x3b3e3f);
        }else
        {
            if (i == 2 && [_detailsData.activityTypeUuid isEqualToString:@"1"]) {
                label.textColor = UIColorRGB(0x3b3e3f);
            }else{
                label.textColor = UIColorRGB(0xc73839);
            }
        }
        label.tag = 1000+i;
        [_gunImageView addSubview:label];
    }
    
    _totleTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(handleTimer:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_totleTimer forMode:NSRunLoopCommonModes];
    
}

- (void)handleTimer:(NSTimer*)timer {
    
    NSString *showString = [_detailsData.userCode substringFromIndex:_detailsData.userCode.length-5];
    
    _runTime += timer.timeInterval;
    
    UILabel *aLale = (UILabel *)[_gunImageView viewWithTag:1000];
    UILabel *bLale = (UILabel *)[_gunImageView viewWithTag:1001];
    UILabel *cLale = (UILabel *)[_gunImageView viewWithTag:1002];
    UILabel *dLale = (UILabel *)[_gunImageView viewWithTag:1003];
    UILabel *eLale = (UILabel *)[_gunImageView viewWithTag:1004];

    aLale.text = [showString substringWithRange:NSMakeRange(0, 1)];
    bLale.text = [showString substringWithRange:NSMakeRange(1, 1)];
    
    if ([_detailsData.activityTypeUuid isEqualToString:@"1"])
    {
        cLale.text = [showString substringWithRange:NSMakeRange(2, 1)];
        if (_runTime >= 5){
            dLale.text = [showString substringWithRange:NSMakeRange(3, 1)];
        }
        if (_runTime >= 10){
            eLale.text = [showString substringWithRange:NSMakeRange(4, 1)];
        }
        
        if (_runTime > 10) {
            [_totleTimer invalidate];
            _totleTimer = nil;
            if ([self.delegate respondsToSelector:@selector(endCountdown)]) {
                for (UIView *view in [self subviews]) {
                    [view removeFromSuperview];
                }
                _detailsData.countDown = @"0";
                [self addView:_detailsData];
                [self.delegate endCountdown];
            }
            return;
        }
        
        if (_runTime >= 0 && _runTime <5) {
            dLale.text = [NSString stringWithFormat:@"%d", arc4random_uniform(10)];
            eLale.text = [NSString stringWithFormat:@"%d", arc4random_uniform(10)];
        }else if (_runTime > 5 && _runTime < 10){
            eLale.text = [NSString stringWithFormat:@"%d", arc4random_uniform(10)];
        }
        
    }else{
        if (_runTime >= 5){
            cLale.text = [showString substringWithRange:NSMakeRange(2, 1)];
        }
        if (_runTime >= 10){
            dLale.text = [showString substringWithRange:NSMakeRange(3, 1)];
        }
        if (_runTime >= 15){
            eLale.text = [showString substringWithRange:NSMakeRange(4, 1)];
        }
        
        if (_runTime > 15) {
            [_totleTimer invalidate];
            _totleTimer = nil;
            if ([self.delegate respondsToSelector:@selector(endCountdown)]) {
                for (UIView *view in [self subviews]) {
                    [view removeFromSuperview];
                }
                _detailsData.countDown = @"0";
                [self addView:_detailsData];
                [self.delegate endCountdown];
            }
            return;
        }
        
        if (_runTime >= 0 && _runTime <5) {
            cLale.text = [NSString stringWithFormat:@"%d", arc4random_uniform(10)];
            dLale.text = [NSString stringWithFormat:@"%d", arc4random_uniform(10)];
            eLale.text = [NSString stringWithFormat:@"%d", arc4random_uniform(10)];
        }else if (_runTime > 5 && _runTime < 10){
            dLale.text = [NSString stringWithFormat:@"%d", arc4random_uniform(10)];
            eLale.text = [NSString stringWithFormat:@"%d", arc4random_uniform(10)];
        }else if (_runTime > 10 && _runTime <15){
            eLale.text = [NSString stringWithFormat:@"%d", arc4random_uniform(10)];
        }
    }
    
}

//开始开奖,倒计时
- (void)startTheLottery:(LKDetailsData *)detailsData
{
    self.timerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _detailImage.maxY-BoundsOfScale(30), _detailImage.width, BoundsOfScale(30))];
    self.timerLabel.backgroundColor = [UIColor clearColor];
    self.timerLabel.font = [UIFont systemFontOfSize:FontOfScale(48)];
    self.timerLabel.textColor = [UIColor redColor];
    self.timerLabel.textAlignment = NSTextAlignmentRight;
    [_detailImage addSubview:self.timerLabel];
    
    UIView *backView=[[UIView alloc] initWithFrame:self.timerLabel.bounds];
    [backView setBackgroundColor:UIColorRGBA(0x000000, 0.6)];
    [self.timerLabel addSubview:backView];
    
    CGSize statusSize=[LKTools getStringSize:@"00:00:09" fontSize:14];

    CGSize tSize=[LKTools getStringSize:@"倒计时1" fontSize:14];
    
    _timeImageView=[[UIImageView alloc] initWithFrame:CGRectMake(self.timerLabel.width-BoundsOfScale(19)-statusSize.width-15-tSize.width-BoundsOfScale(7), (BoundsOfScale(30)-15.5)/2,15.5, 15.5)];
    [_timeImageView setBackgroundColor:[UIColor clearColor]];
    [_timeImageView setImage:[UIImage imageNamed:@"history_time"]];
    [self.timerLabel addSubview:_timeImageView];
    
    UILabel *timerLabe = [[UILabel alloc] initWithFrame:CGRectMake(_timeImageView.maxX+BoundsOfScale(5), 0, tSize.width, BoundsOfScale(30))];
    timerLabe.backgroundColor=[UIColor clearColor];
    timerLabe.font = [UIFont systemFontOfSize:FontOfScale(14)];
    timerLabe.textColor = [UIColor whiteColor];
    timerLabe.textAlignment = NSTextAlignmentLeft;
    timerLabe.text=@"倒计时";
    [self.timerLabel addSubview:timerLabe];
    
    _statusLabel=[[UILabel alloc] initWithFrame:CGRectMake(timerLabe.maxX+BoundsOfScale(5), 0, statusSize.width+10, BoundsOfScale(30))];
    _statusLabel.backgroundColor=[UIColor clearColor];
    _statusLabel.font = [UIFont systemFontOfSize:FontOfScale(14)];
    _statusLabel.textColor = [UIColor whiteColor];
    _statusLabel.textAlignment = NSTextAlignmentLeft;
    _statusLabel.text=@"00:00:00";
    [self.timerLabel addSubview:_statusLabel];
    
    _timer = [[MZTimerLabel alloc] initWithLabel:_statusLabel andTimerType:MZTimerLabelTypeTimer];
    _timer.timeLabel.textColor = [UIColor whiteColor];
    _timer.timeLabel.textAlignment = NSTextAlignmentCenter;
    [_timer setCountDownTime:[detailsData.countDown integerValue]];
    _timer.delegate = self;
    [_timer start];
    
}

-(void)timerLabel:(MZTimerLabel*)timerLabel finshedCountDownTimerWithTime:(NSTimeInterval)countTime
{
    self.timerLabel.hidden = YES;
    _arrowView.hidden = NO;
    [self showGunView];
    if ([self.delegate respondsToSelector:@selector(endCountdown)]) {
        [self.delegate endCountdown];
    }
}

//开奖结束
- (void)endTheLottery:(LKDetailsData *)detailsData
{
    NSString *showString = @"";
    if (detailsData.userCode.length < 5) {
        showString = @"00000";
    }else{
        showString = [detailsData.userCode substringFromIndex:detailsData.userCode.length-5];
    }
    
    _gunImageView.hidden = NO;
    
    self.frame = CGRectMake(0, 0, UI_IOS_WINDOW_WIDTH, _contentLabel.maxY+BoundsOfScale(10));
    
    for (NSInteger i = 0; i < 5; i++)
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(BoundsOfScale(15)+((_gunImageView.width-BoundsOfScale(30))/5)*i, 0, (_gunImageView.width-BoundsOfScale(30))/5, _gunImageView.height)];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:FontOfScale(45)];
        if (i == 1 || i == 0) {
            label.textColor = UIColorRGB(0x3b3e3f);
        }else
        {
            if (i == 2 && [_detailsData.activityTypeUuid isEqualToString:@"1"]) {
                label.textColor = UIColorRGB(0x3b3e3f);
            }else{
                label.textColor = UIColorRGB(0xc73839);
            }
        }
        
        label.text = [showString substringWithRange:NSMakeRange(i, 1)];
        label.tag = 1000+i;
        [_gunImageView addSubview:label];
    }
}

//中奖人点赞
- (void)changeWinUserBtnUpInside
{
    if ([self.delegate respondsToSelector:@selector(changeWinUserBtn:)]) {
        [self.delegate changeWinUserBtn:_detailsData];
    }
}

//更新中奖人点赞信息
- (void)updateWinUser:(LKDetailsData *)detailsData
{
    if (detailsData.winUserData.praises.length>0 && [detailsData.winUserData.praises integerValue] > 0) {
        _praisesLabel.text = detailsData.winUserData.praises;
    }else{
        _praisesLabel.text = @"0";

    }
    if ([detailsData.winUserData.isPraises isEqualToString:@"0"]) {
        [_headImage setImage:[UIImage imageNamed:@"betting_heart"]];
    }else{
        [_headImage setImage:[UIImage imageNamed:@"home_heart_on"]];
        _winButton.userInteractionEnabled = NO;
    }
}

//更新收藏
- (void)updateLike:(LKDetailsData *)detailsData
{
    if ([detailsData.iLike boolValue]) {
        [self.likeImage setImage:[UIImage imageWithName:@"home_heart_on"] forState:UIControlStateNormal];
    }
    else
    {
        [self.likeImage setImage:[UIImage imageWithName:@"home_heart"] forState:UIControlStateNormal];
    }
}

- (void)likeButtonInside
{
    if ([self.delegate respondsToSelector:@selector(changeLike)]) {
        [self.delegate changeLike];
    }
}

- (void)changeWinHeadImageTapGestureRecognizer
{
    if ([self.delegate respondsToSelector:@selector(changeWinHeadImageViewBtn:)]) {
        [self.delegate changeWinHeadImageViewBtn:_detailsData.winUserData.userUuid];
    }
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (CGRect)getRectWithSize:(CGFloat)width withAttributedString:(NSMutableAttributedString*)attrt
{
    NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    CGRect rect = [attrt boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:options context:nil];
    return rect;
}

+ (CGRect)getRectWithSize:(CGFloat)width withAttributedString:(NSMutableAttributedString*)attrt
{
    NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    CGRect rect = [attrt boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:options context:nil];
    return rect;
}

- (NSMutableAttributedString *)attributedStringWithString:(NSString *)string withFont:(UIFont *)font withColor:(UIColor *)color withLineSpacing:(CGFloat)lineSpacing
{
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:string attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:color}];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpacing];
    
    [attributedStr addAttribute:NSParagraphStyleAttributeName
                          value:paragraphStyle
                          range:NSMakeRange(0, [string length])];
    return attributedStr;
}

+ (NSMutableAttributedString *)attributedStringWithString:(NSString *)string withFont:(UIFont *)font withColor:(UIColor *)color withLineSpacing:(CGFloat)lineSpacing
{
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:string attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:color}];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpacing];
    
    [attributedStr addAttribute:NSParagraphStyleAttributeName
                          value:paragraphStyle
                          range:NSMakeRange(0, [string length])];
    return attributedStr;
}

@end
