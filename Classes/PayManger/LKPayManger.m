//
//  LKPayManger.m
//  Luckeys
//
//  Created by 李锦华 on 15/11/29.
//  Copyright © 2015年 Luckeys. All rights reserved.
//

#import "LKPayManger.h"
#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>

#define kALipaykeyResultSuccess 9000

@implementation LKPayManger

+(instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static LKPayManger *instance;
    dispatch_once(&onceToken, ^{
        instance = [[LKPayManger alloc] init];
    });
    return instance;
}


-(void)payMent:(PayType)payType goods:(LKPayData*)model{
    if(!model){
        return;
    }
    switch (payType) {
        case PayType_Weixin:
            [self weixinPay:(LKPayData*)model];
            break;
        case PayType_Ali:
            [self aliPay:(LKAliPayData*)model];
            break;
        case PayType_Union:
            //[self unionPay:model];
            break;
        default:
            break;
    }
}

//微信支付
-(void)weixinPay:(LKPayData*)model{
    if([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi])
    {
        PayReq *request = [[PayReq alloc] init];
        request.partnerId = model.mch_id;
        request.prepayId= model.prepay_id;
        request.package = @"Sign=WXPay";
        request.nonceStr= model.payNoncestr;
        request.timeStamp= [model.payTimestamp intValue];
        request.sign = model.paySign;
        [WXApi sendReq:request];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"对不起，您未安装微信或微信版本过低" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }
}

//支付宝支付
-(void)aliPay:(LKAliPayData*)model{
    
      NSString *appScheme = @"Luckeys";

        [[AlipaySDK defaultService] payOrder:model.payInfo fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            //支付宝支付回调
            NSLog(@"reslut = %@",resultDic);
            int resultSuccess = [[resultDic objectForKey:@"resultStatus"] intValue];
            //是9000代表支付成功
            if (resultSuccess == kALipaykeyResultSuccess)
            {
                NSLog(@"支付成功");
                if (_delegate
                    && [_delegate respondsToSelector:@selector(managerDidRecvAlipayResponse:)]) {
                    [_delegate managerDidRecvAlipayResponse:YES];
                }
            }else{
                NSLog(@"支付失败");
                if (_delegate
                    && [_delegate respondsToSelector:@selector(managerDidRecvAlipayResponse:)]) {
                    [_delegate managerDidRecvAlipayResponse:NO];
                }
            }
        }];
}

//银联支付
-(void)unionPay:(LKPayData*)model
{

}

//微信支付回调
-(void)onResp:(BaseResp*)resp{
    if ([resp isKindOfClass:[PayResp class]]){
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvPayResponse:)]) {
            [_delegate managerDidRecvPayResponse:(PayResp*)resp];
        }
    }
}
@end
