//
//  LKDetailsMsgModel.h
//  Luckeys
//
//  Created by lishaowei on 15/10/24.
//  Copyright © 2015年 Luckeys. All rights reserved.
//

#import "NBaseModel.h"
#import "LKDetailsData.h"

#define kWinUserBtn 1112
#define kLikeButton 10005

@interface LKDetailsMsgModel : NBaseModel

@property (nonatomic, strong, readonly) NSMutableArray *infoArray;
@property (nonatomic, strong, readonly) LKDetailsData *detailsData;

@end
