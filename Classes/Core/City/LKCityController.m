//
//  LKCityController.m
//  Luckeys
//
//  Created by lishaowei on 15/11/25.
//  Copyright © 2015年 Luckeys. All rights reserved.
//

#import "LKCityController.h"
#import "LKCityModel.h"

@implementation LKCityController
{
    LKCityModel * _model;
}

- (void) initController
{
    _model = [[LKCityModel alloc] init];
    [self registerModel:_model];
}

- (void)sendMessageID:(int)msgID messageInfo:(id)msgInfo
{
    
    if (msgInfo && [msgInfo isKindOfClass:[NSDictionary class]])
    {
        NSString * url = msgInfo[kRequestUrl];
        id body = msgInfo[kRequestBody];
        [[MLHttpRequestManager sharedMLHttpRequestManager] sendHttpRequestWithTag:msgID URLString:url requestType:Request_Normal bodyString:body jsCallBack:nil Finished:^(Result_TYPE success, int requestTag, id callbackData) {
            if (success == Result_Success) {
                [_model handleSucessData:callbackData messageID:requestTag];
            }
            else {
                [_model handleError:nil errCode:Result_Fail messageID:requestTag];
            }
        }];
    }
}
@end
