//
//  LKControllerModel.h
//  Luckeys
//
//  Created by lishaowei on 16/1/18.
//  Copyright © 2016年 Luckeys. All rights reserved.
//

#import "NBaseModel.h"
#import "LKPayData.h"
#import "LKAliPayData.h"

#define kWXPayRequestTag    2000    //微信订单请求tag
#define kAliPayRequestTag   2001    //支付宝订单请求tag

#define kWXPaySuccess       3000    //微信支付成功

@interface LKControllerModel : NBaseModel

@property (nonatomic, strong, readonly) LKPayData *payData;

@property (nonatomic,strong) LKAliPayData *aliPayData;

@property (nonatomic, strong)NSString *isTimeOut;


@end
