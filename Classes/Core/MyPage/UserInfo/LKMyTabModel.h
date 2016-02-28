//
//  LKMyTabModel.h
//  Luckeys
//
//  Created by 李锦华 on 15/10/24.
//  Copyright © 2015年 Luckeys. All rights reserved.
//

#import "NBaseModel.h"

#define kPersonWinUserBtnTag    20005
#define kLoadMoreTag     1021

#define kPageCoutTag    @"10"
#define kNoCurPage      -1

@class LKUserData;

@interface LKMyTabModel : NBaseModel

@property (nonatomic,strong,readonly) NSArray * dataArray;
@property (nonatomic,strong)LKUserData *userData;
@property (nonatomic,strong)NSString *codeUuid;
@property (nonatomic,assign)NSInteger curPage;

@end
