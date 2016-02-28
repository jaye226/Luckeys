//
//  LKTypeData.h
//  Luckeys
//
//  Created by BearLi on 15/10/2.
//  Copyright © 2015年 Luckeys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LKTypeData : PADataObject

@property (nonatomic,strong) NSString * activityUuid;
@property (nonatomic,strong) NSString * activityName;
@property (nonatomic,strong) NSString * activityTypeUuid;
@property (nonatomic,strong) NSString * activityTypeName;
@property (nonatomic,strong) NSString * imageUrl;
@property (nonatomic,strong) NSString * cityUuid;
@property (nonatomic,strong) NSString * cityName;
@property (nonatomic,strong) NSString * totalPrice;
@property (nonatomic,strong) NSString * unitPrice;
@property (nonatomic,strong) NSString * bets;
@property (nonatomic,strong) NSString * betNumber;
@property (nonatomic,strong) NSString * locationUuid;
@property (nonatomic,strong) NSString * locationName;
@property (nonatomic,strong) NSString * activityStatus;
@property (nonatomic,strong) NSString * activityDay;
@property (nonatomic,strong) NSString * chipsStatus;
@property (nonatomic,strong) NSString * chipsPercent;
@property (nonatomic,strong) NSString * winSum;
@property (nonatomic,strong) NSString * userUuid;
@property (nonatomic,strong) NSString * userName;
@property (nonatomic,strong) NSString * createDate;
@property (nonatomic,strong) NSString * startDate;
@property (nonatomic,strong) NSString * endDate;
@property (nonatomic,strong) NSString * iLike;      //是否收藏
@property (nonatomic,strong) NSString * praises;    //点赞数
@property (nonatomic,strong) NSString * isPraises;    //是否点赞
@property (nonatomic,strong) NSString * descri;     //评论
@property (nonatomic,strong) NSString * codeUuid;

@end
