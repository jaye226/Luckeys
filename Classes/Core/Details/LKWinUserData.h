//
//  LKWinUserData.h
//  Luckeys
//
//  Created by lishaowei on 15/11/8.
//  Copyright © 2015年 Luckeys. All rights reserved.
//

#import "PADataObject.h"

@interface LKWinUserData : PADataObject

@property (nonatomic, strong)NSString *userUuid;
@property (nonatomic, strong)NSString *nickName;
@property (nonatomic, strong)NSString *userHead;
@property (nonatomic, strong)NSString *isPraises;
@property (nonatomic, strong)NSString *praises;

@end
