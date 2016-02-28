//
//  LKCommentData.h
//  Luckeys
//
//  Created by lishaowei on 15/11/1.
//  Copyright © 2015年 Luckeys. All rights reserved.
//

#import "PADataObject.h"

@interface LKCommentData : PADataObject

@property (nonatomic, strong)NSString *userUuid;
@property (nonatomic, strong)NSString *nickName;
@property (nonatomic, strong)NSString *userHead;
@property (nonatomic, strong)NSString *descri;
@property (nonatomic, strong)NSString *used;
@property (nonatomic, strong)NSString *commentUuid;
@property (nonatomic, strong)NSString *createDate;
@end
