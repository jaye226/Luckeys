//
//  LKPayManger.h
//  Luckeys
//
//  Created by 李锦华 on 15/11/29.
//  Copyright © 2015年 Luckeys. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LKPayData.h"
#import "LKAliPayData.h"
#import "WXApi.h"

//支付delegate
@protocol WXApiManagerDelegate <NSObject>
@optional
- (void)managerDidRecvPayResponse:(PayResp *)response;
/**
 *  支付宝支付
 *
 *  @param isAlipay 是否支付成功
 */
- (void)managerDidRecvAlipayResponse:(BOOL )isAlipay;
@end

//支付方式
typedef NS_ENUM(NSUInteger, PayType) {
    PayType_Weixin=2,  //微信支付
    PayType_Ali=0,     //支付宝支付
    PayType_Union=1,   //银联
};

@interface LKPayManger : NSObject<WXApiDelegate>

@property (nonatomic, weak) id<WXApiManagerDelegate> delegate;

+(instancetype)sharedManager;

/**
 *  支付
 *
 *  @param payType 支付类型
 *  @param model   支付商品
 */
-(void)payMent:(PayType)payType goods:(PADataObject*)model;
@end
