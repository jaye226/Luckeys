//
//  LKNotOrderModel.h
//  Luckeys
//
//  Created by lishaowei on 16/1/17.
//  Copyright © 2016年 Luckeys. All rights reserved.
//

#import "NBaseModel.h"

#define kRefreshTag    2006
#define kLoadMoreTag   2007

#define kPageCoutTag    @"10"
#define kNoCurPage      -1


@interface LKNotOrderModel : NBaseModel

@property (nonatomic,strong) NSMutableArray *list;

@end
