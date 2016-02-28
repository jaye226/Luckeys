//
//  LKFriendLikeCell.m
//  Luckeys
//
//  Created by 李锦华 on 15/10/17.
//  Copyright © 2015年 Luckeys. All rights reserved.
//

#import "LKFriendLikeCell.h"

@implementation LKFriendLikeCell{
    UIImageView *phoImageView;
    UILabel *nameLabel;
    UILabel *timeLabel;
    
    LKPersonLikeData *_likeData;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createView];
    }
    return self;
}

-(void)createView{
    phoImageView=[[UIImageView alloc] initWithFrame:CGRectMake(BoundsOfScale(12), BoundsOfScale(22)/2, BoundsOfScale(50), BoundsOfScale(50))];
    phoImageView.userInteractionEnabled=YES;
    [phoImageView setContentMode:UIViewContentModeScaleAspectFill];
    phoImageView.clipsToBounds = YES;
    phoImageView.layer.cornerRadius = CGRectGetMidX(phoImageView.bounds);
    phoImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:phoImageView];
    phoImageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headBtnUpInside)];
    [phoImageView addGestureRecognizer:tapGestureRecognizer];
    
    nameLabel=[[UILabel alloc] initWithFrame:CGRectZero];
    [nameLabel setTextColor:UIColorRGB(0x333333)];
    [nameLabel setFont:[UIFont systemFontOfSize:FontOfScale(14)]];
    nameLabel.textAlignment=NSTextAlignmentLeft;
    nameLabel.backgroundColor=[UIColor clearColor];
    [self.contentView addSubview:nameLabel];
    
    
    timeLabel=[[UILabel alloc] initWithFrame:CGRectZero];
    [timeLabel setTextColor:UIColorRGB(0x999999)];
    timeLabel.textAlignment=NSTextAlignmentRight;
    [timeLabel setFont:[UIFont systemFontOfSize:FontOfScale(13)]];
    timeLabel.backgroundColor=[UIColor clearColor];
    [self.contentView addSubview:timeLabel];
    
    UIView *sepLine=[[UIView alloc] initWithFrame:CGRectMake(0,BoundsOfScale(71.5),UI_IOS_WINDOW_WIDTH, BoundsOfScale(0.5))];
    [sepLine setBackgroundColor:UIColorRGB(KSepLineColor_e)];
    [self.contentView addSubview:sepLine];
}

- (void)headBtnUpInside
{
    if ([self.delegate respondsToSelector:@selector(changeHeadBtnUpInside:)]) {
        [self.delegate changeHeadBtnUpInside:_likeData];
    }
}

-(void)setContent:(LKPersonLikeData*)likeData{
    
    _likeData = likeData;
    
    if (likeData.nickName.length <= 0) {
        likeData.nickName = @"匿名";
    }
    
    CGSize nameSize=[LKTools getStringSize:likeData.nickName fontSize:16];
    nameLabel.frame=CGRectMake(phoImageView.maxX+BoundsOfScale(12), (BoundsOfScale(72)-nameSize.height)/2,nameSize.width+10, nameSize.height);
    nameLabel.text=likeData.nickName;
    
    NSString *date = [LKTools transTime:likeData.createDate dateFormat:@"yyyy-MM-dd"];
    CGSize timeSize=[LKTools getStringSize:date fontSize:16];
    timeLabel.frame=CGRectMake(UI_IOS_WINDOW_WIDTH-BoundsOfScale(15)-timeSize.width-10, (BoundsOfScale(72)-timeSize.height)/2,timeSize.width+10, timeSize.height);
    timeLabel.text=date;
    
    [phoImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@%@",SeverHost,likeData.userHead]] placeholderImage:[UIImage imageWithName:@"defaulthead"]];
}

@end
