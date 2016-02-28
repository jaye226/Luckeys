//
//  LKTypeListMsgModel.h
//  Luckeys
//
//  Created by BearLi on 15/10/24.
//  Copyright © 2015年 Luckeys. All rights reserved.
//

#import "NBaseModel.h"

#define kLikeTag 22001

@interface LKTypeListMsgModel : NBaseModel
@property (nonatomic,strong,readonly) NSArray * dataArray;

@property (nonatomic,assign) NSInteger nextPage;
@property (nonatomic,strong) NSString * message;

@end
