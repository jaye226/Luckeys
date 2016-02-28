//
//  LKBetUserData.h
//  Luckeys
//
//  Created by lishaowei on 15/11/1.
//  Copyright © 2015年 Luckeys. All rights reserved.
//

#import "PADataObject.h"

@interface LKBetUserData : PADataObject

@property (nonatomic, strong)NSString *userUuid;
@property (nonatomic, strong)NSString *userName;
@property (nonatomic, strong)NSString *userHead;
@property (nonatomic, strong)NSString *betNumber;
@property (nonatomic, strong)NSString *codes;
@property (nonatomic, assign)BOOL isShow;

@end
