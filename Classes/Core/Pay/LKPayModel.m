//
//  LKPayModel.m
//  Luckeys
//
//  Created by lishaowei on 15/11/26.
//  Copyright © 2015年 Luckeys. All rights reserved.
//

#import "LKPayModel.h"

@implementation LKPayModel
{
    LKPayData *_data;
    LKAliPayData *_aliPayData;
}

@synthesize payData = _data;
@synthesize aliPayData = _aliPayData;

- (void) handleSucessData:(id)dataSource messageID:(int)msgID {
    NSDictionary *dict = [dataSource objectFromJSONString];
    //    NSDictionary *dict = [PADataObject jsonDataToObject:dataSource];
    if (dict) {
        NSInteger code = [dict[@"code"] integerValue];
        if (code == eCodeSuccess)
        {
            if ([[dict objectForKey:@"body"] isKindOfClass:[NSDictionary class]])
            {
                _isTimeOut = [[dict objectForKey:@"body"] objectForKey:@"isTimeOut"];
                if(msgID == kWXPayRequestTag)
                {
                    _data=[LKPayData makeDataModel:[dict objectForKey:@"body"]];
                }
                else if (msgID == kAliPayRequestTag)
                {
                    _isTimeOut = [[dict objectForKey:@"body"] objectForKey:@"isTimeOut"];
                    _aliPayData = [LKAliPayData makeDataModel:[dict objectForKey:@"body"]];
                }
                [self update:self msgID:msgID errCode:eDataCodeSuccess];

            }else{
                [self update:self msgID:msgID errCode:eDataCodeFaild];
            }
        }
        else {
            [self update:self msgID:msgID errCode:eDataCodeFaild];
        }
    }
    else {
        [self update:self msgID:msgID errCode:eDataCodeFaild];
    }
    
}

- (void) handleError:(NSString *)errorMsg errCode:(int)code messageID:(int)msgID
{
    [self update:self msgID:msgID errCode:eDataCodeFaild];
}
@end
