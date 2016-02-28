//
//  LKFriendsData.h
//  Luckeys
//
//  Created by lishaowei on 15/12/14.
//  Copyright © 2015年 Luckeys. All rights reserved.
//

#import "PADataObject.h"

@interface LKFriendsData : PADataObject

@property(nonatomic,strong)NSString *codeUuid;
@property(nonatomic,strong)NSString *activityUuid;
@property(nonatomic,strong)NSString *code;
@property(nonatomic,strong)NSString *activityImageUrl;
@property(nonatomic,strong)NSString *userUuid;
@property(nonatomic,strong)NSString *comment;
@property(nonatomic,strong)NSString *isWin;
@property(nonatomic,strong)NSString *imageUrl;
@property(nonatomic,strong)NSString *activityName;
@property(nonatomic,strong)NSString *userHead;
@property(nonatomic,strong)NSString *nickName;
@property(nonatomic,strong)NSArray *listComment;
@property(nonatomic,strong)NSNumber *shareTime;//分享时间

@end
