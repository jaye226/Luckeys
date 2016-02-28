//
//  LKNotOrderData.h
//  Luckeys
//
//  Created by lishaowei on 16/1/18.
//  Copyright © 2016年 Luckeys. All rights reserved.
//

#import "PADataObject.h"

@interface LKNotOrderData : PADataObject

@property (nonatomic,strong) NSString *activityName;
@property (nonatomic,strong) NSString *activityUuid;
@property (nonatomic,strong) NSString *activityTypeName;
@property (nonatomic,strong) NSString *activityTypeUuid;
@property (nonatomic,strong) NSString *unitPrice;   //单价
@property (nonatomic,strong) NSString *createDate;
@property (nonatomic,strong) NSString *endDate;
@property (nonatomic,strong) NSString *descri;
@property (nonatomic,strong) NSString *imageUrl;
@property (nonatomic,strong) NSArray *listCodes;

@end
