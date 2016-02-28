//
//  LKRegisterInfoCell.m
//  Luckeys
//
//  Created by 李锦华 on 15/10/4.
//  Copyright © 2015年 Luckeys. All rights reserved.
//

#import "LKRegisterInfoCell.h"
#import "LKPersonInfoData.h"

@implementation LKRegisterInfoCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.width = UI_IOS_WINDOW_WIDTH;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createView];
    }
    return self;
}

-(void)createView{
    _nickNameLabel=[[UILabel alloc] initWithFrame:CGRectZero];
    _nickNameLabel.backgroundColor=[UIColor clearColor];
    _nickNameLabel.font=[UIFont systemFontOfSize:25];
    _nickNameLabel.textColor=UIColorRGB(kContentColor_three);
    [self.contentView addSubview:_nickNameLabel];
    
    _addressLabel=[[UILabel alloc] initWithFrame:CGRectZero];
    _addressLabel.backgroundColor=[UIColor clearColor];
    _addressLabel.font=[UIFont systemFontOfSize:14];
    _addressLabel.textColor=UIColorRGB(kContentColor_six);
    [self.contentView addSubview:_addressLabel];
    
    _registerTimeLabel=[[UILabel alloc] initWithFrame:CGRectZero];
    _registerTimeLabel.backgroundColor=[UIColor clearColor];
    _registerTimeLabel.font=[UIFont systemFontOfSize:14];
    _registerTimeLabel.textColor=UIColorRGB(kContentColor_six);
    [self.contentView addSubview:_registerTimeLabel];
    
    _sepLine=[[UIView alloc] initWithFrame:CGRectMake(18, 114.5, UI_IOS_WINDOW_WIDTH-36, 0.5)];
    _sepLine.backgroundColor=UIColorRGB(KSepLineColor_e);
    [self.contentView addSubview:_sepLine];
}

-(void)setViewsFrame:(LKUserData*)personData{
    NSString *nickStr;
    if(!personData.nickName||personData.nickName.length==0){
        nickStr=@"昵称:未设置";
    }else{
        nickStr=STR_IS_NULL(personData.nickName);
    }
    
    CGSize nickNameSize=[LKTools getStringSize:nickStr fontSize:25];
    _nickNameLabel.frame=CGRectMake(18, 25, nickNameSize.width, nickNameSize.height);
    _nickNameLabel.text=nickStr;
    
    _selectButton.frame=CGRectMake(CGRectGetMaxX(_nickNameLabel.frame)+12, 31, 30, 30);
    
    NSString *addStr;
    if(!personData.address||personData.address.length==0){
        addStr=@"地址:未设置";
    }else{
        addStr=STR_IS_NULL(personData.address);
    }
    CGSize addressSize=[LKTools getStringSize:addStr fontSize:14];
    _addressLabel.frame=CGRectMake(18, CGRectGetMaxY(_nickNameLabel.frame)+12,addressSize.width+20 ,addressSize.height);
    _addressLabel.text=addStr;
    
    NSDate *currentDate = [[NSDate alloc]initWithTimeIntervalSince1970:[personData.createDate longLongValue]/1000.0];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy.MM.dd"];
    //用[NSDate date]可以获取系统当前时间
    NSString *registerStr=[NSString stringWithFormat:@"注册时间:%@",[dateFormatter stringFromDate:currentDate]];
    
    CGSize registerTimeSize=[LKTools getStringSize:STR_IS_NULL(registerStr) fontSize:14];
    _registerTimeLabel.frame=CGRectMake(18, CGRectGetMaxY(_addressLabel.frame)+3, registerTimeSize.width, registerTimeSize.height);
    _registerTimeLabel.text=registerStr;

}
@end
