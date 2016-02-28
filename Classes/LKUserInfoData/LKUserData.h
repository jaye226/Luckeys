//
//  LKUserData.h
//  Luckeys
//
//  Created by BearLi on 15/10/17.
//  Copyright © 2015年 Luckeys. All rights reserved.
//

#import "PADataObject.h"

@interface LKUserData : PADataObject

@property (nonatomic,strong) NSString * userUuid;
@property (nonatomic,strong) NSString * userName;
@property (nonatomic,strong) NSString * userPhone;
@property (nonatomic,strong) NSString * userType;
@property (nonatomic,strong) NSString * userHead;
@property (nonatomic,strong) NSString * nickName;           //昵称
@property (nonatomic,strong) NSString * createDate;
@property (nonatomic,strong) NSString * loginDate;
@property (nonatomic,strong) NSString * backImage;          //人物背景图
@property (nonatomic,strong) NSString * address;
@property (nonatomic,strong) NSString * sex;
@property (nonatomic,strong) NSString * email;
@property (nonatomic,strong) NSString * birthday;
@property (nonatomic,strong) NSString * winSum; //中奖次数

@end
