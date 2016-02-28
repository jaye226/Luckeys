//
//  LKPayData.h
//  Luckeys
//
//  Created by lishaowei on 15/11/29.
//  Copyright © 2015年 Luckeys. All rights reserved.
//

#import "PADataObject.h"

@interface LKPayData : PADataObject
@property(nonatomic,strong)NSString *appid;       //公众账号ID
@property(nonatomic,strong)NSString *mch_id;      //商户号
@property(nonatomic,strong)NSString *prepay_id;   //预付订单号
@property(nonatomic,strong)NSString *device_info; //设备号
@property(nonatomic,strong)NSString *payNoncestr;   //随机字符串
@property(nonatomic,strong)NSString *paySign;        //签名
@property(nonatomic,strong)NSString *result_code; //业务结果
@property(nonatomic,strong)NSString *trade_type;  //交易类型
@property(nonatomic,strong)NSString *err_code;    //错误代码
@property(nonatomic,strong)NSString *err_code_des;//错误代码描述
@property(nonatomic,strong)NSNumber *payTimestamp;

@end
