//
//  LKNotOrderData.m
//  Luckeys
//
//  Created by lishaowei on 16/1/18.
//  Copyright © 2016年 Luckeys. All rights reserved.
//

#import "LKNotOrderData.h"

@implementation LKNotOrderData

+(id)makeDataModel:(id)properties
{
    LKNotOrderData *list = [super makeDataModel:properties];
    list.listCodes = [self makeClassWithProperties:list.listCodes customClassName:@"LKNotCodesData"];
    return list;
}

@end
