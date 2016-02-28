//
//  LKForgetPasswordMsgController.m
//  Luckeys
//
//  Created by lishaowei on 15/9/19.
//  Copyright © 2015年 Luckeys. All rights reserved.
//

#import "LKForgetPasswordMsgController.h"
#import "LKForgetPasswordMsgModel.h"

@implementation LKForgetPasswordMsgController
{
    LKForgetPasswordMsgModel * _model;
}

- (void) initController
{
    _model = [[LKForgetPasswordMsgModel alloc] init];
    [self registerModel:_model];
}

- (void)sendMessageID:(int)msgID messageInfo:(id)msgInfo
{
    
    if (msgInfo && [msgInfo isKindOfClass:[NSDictionary class]]) {
        NSString * url = msgInfo[kRequestUrl];
        NSDictionary * body = msgInfo[kRequestBody];
        [[MLHttpRequestManager sharedMLHttpRequestManager] sendHttpRequestWithTag:msgID URLString:url requestType:Request_Normal bodyString:body jsCallBack:nil Finished:^(Result_TYPE success, int requestTag, id callbackData) {
            if (success == Result_Success) {
                [_model handleSucessData:callbackData messageID:requestTag];
            }
            else {
                [_model handleError:nil errCode:eDataCodeFaild messageID:requestTag];
            }
        }];
    }
}
@end
