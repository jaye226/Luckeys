//
//  LKDetailsData.h
//  Luckeys
//
//  Created by lishaowei on 15/10/24.
//  Copyright © 2015年 Luckeys. All rights reserved.
//

#import "PADataObject.h"
#import "LKWinUserData.h"

@interface LKDetailsData : PADataObject

@property (nonatomic, strong)NSString *activityDay;
@property (nonatomic, strong)NSString *activityName;
@property (nonatomic, strong)NSString *activityStatus;
@property (nonatomic, strong)NSString *activityTypeName;
@property (nonatomic, strong)NSString *activityTypeUuid;
@property (nonatomic, strong)NSString *activityUuid;
@property (nonatomic, strong)NSString *betNumber;
@property (nonatomic, strong)NSString *bets;
@property (nonatomic, strong)NSString *chipsPercent;
@property (nonatomic, strong)NSString *chipsStatus;  //众筹状态 1成功
@property (nonatomic, strong)NSString *cityName;
@property (nonatomic, strong)NSString *cityUuid;
@property (nonatomic, strong)NSString *createDate;
@property (nonatomic, strong)NSString *descri;
@property (nonatomic, strong)NSString *endDate;
@property (nonatomic, strong)NSString *iLike;
@property (nonatomic, strong)NSString *imageUrl;
@property (nonatomic, strong)NSArray *listActivity;  //推荐活动
@property (nonatomic, strong)NSArray *listBetUser;   //投注人
@property (nonatomic, strong)NSArray *listCommentUser;   //评论
@property (nonatomic, strong)NSString *locationName;
@property (nonatomic, strong)NSString *locationUuid;
@property (nonatomic, strong)NSString *praises;
@property (nonatomic, strong)NSString *startDate;
@property (nonatomic, strong)NSString *totalPrice;
@property (nonatomic, strong)NSString *unitPrice;
@property (nonatomic, strong)NSString *userName;
@property (nonatomic, strong)NSString *userUuid;
@property (nonatomic, strong)NSString *winSum;
@property (nonatomic, strong)NSString *countDown;  //倒计时
@property (nonatomic, strong)NSString *userCode;    //中奖号码
@property (nonatomic, strong)LKWinUserData *winUserData;//中奖人
@property (nonatomic, strong)NSString *codeUuid;

@end
