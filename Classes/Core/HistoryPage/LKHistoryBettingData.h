//
//  LKHistoryBettingData.h
//  Luckeys
//
//  Created by lishaowei on 15/11/1.
//  Copyright © 2015年 Luckeys. All rights reserved.
//  

#import "PADataObject.h"

@interface LKHistoryBettingData : PADataObject
@property(nonatomic,strong) NSString *imageUrl;
@property(nonatomic,strong) NSString *activityUuid;
@property(nonatomic,strong) NSString *activityName;
@property(nonatomic,strong) NSString *activityTypeUuid;
@property(nonatomic,strong) NSString *activityTypeName;
@property(nonatomic,strong) NSString *cityUuid;
@property(nonatomic,strong) NSString *cityName;
@property(nonatomic,strong) NSString *totalPrice;
@property(nonatomic,strong) NSString *unitPrice;
@property(nonatomic,strong) NSString *bets;
@property(nonatomic,strong) NSString *betNumber;//开奖号
@property(nonatomic,strong) NSString *locationUuid;
@property(nonatomic,strong) NSString *locationName;
@property(nonatomic,strong) NSString *activityStatus;
@property(nonatomic,strong) NSString *activityDay;
@property(nonatomic,strong) NSString *chipsStatus;
@property(nonatomic,strong) NSString *countDown;
@property(nonatomic,strong) NSString *chipsPercent;
@property(nonatomic,strong) NSString *winSum;
@property(nonatomic,strong) NSString *userUuid;
@property(nonatomic,strong) NSString *userName;
@property(nonatomic,strong) NSString *createDate;
@property(nonatomic,strong) NSString *startDate;
@property(nonatomic,strong) NSString *endDate;
@property(nonatomic,strong) NSString *iLike;
@property(nonatomic,strong) NSString *praises;
@property(nonatomic,strong) NSString *descri;
@property(nonatomic,strong) NSString *winCode;//中奖码
@property(nonatomic,strong) NSDictionary *winUser;//中奖者
@property(nonatomic,strong) NSString *userCode;
@property(nonatomic,strong) NSArray *listCode;  //我的投注列表

@end

