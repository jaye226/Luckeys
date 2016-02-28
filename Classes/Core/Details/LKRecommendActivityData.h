//
//  LKRecommendActivityData.h
//  Luckeys
//
//  Created by lishaowei on 15/11/1.
//  Copyright © 2015年 Luckeys. All rights reserved.
//

#import "PADataObject.h"

@interface LKRecommendActivityData : PADataObject

@property (nonatomic, strong)NSString *activityUuid;
@property (nonatomic, strong)NSString *activityName;
@property (nonatomic, strong)NSString *descri;
@property (nonatomic, strong)NSString *totalPrice;
@property (nonatomic, strong)NSString *betNumber;
@property (nonatomic, strong)NSString *imageUrl;

@end
