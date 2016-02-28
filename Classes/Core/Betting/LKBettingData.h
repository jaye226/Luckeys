//
//  LKBettingData.h
//  Luckeys
//
//  Created by lishaowei on 15/11/1.
//  Copyright © 2015年 Luckeys. All rights reserved.
//

#import "PADataObject.h"

@interface LKBettingData : PADataObject

@property (nonatomic, strong)NSString *code;
@property (nonatomic, strong)NSString *codeUuid;
@property (nonatomic)BOOL isSelect;

@end
