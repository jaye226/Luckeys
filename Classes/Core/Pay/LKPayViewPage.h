//
//  LKPayViewPage.h
//  Luckeys
//
//  Created by lishaowei on 15/11/26.
//  Copyright © 2015年 Luckeys. All rights reserved.
//

#import "LKBaseViewPage.h"
#import "LKPayManger.h"

@interface LKPayViewPage : LKBaseViewPage<WXApiManagerDelegate>

@property (nonatomic, strong)NSArray *selectArray;

@end