//
//  LKTypeListMsgController.m
//  Luckeys
//
//  Created by BearLi on 15/10/24.
//  Copyright © 2015年 Luckeys. All rights reserved.
//

#import "LKTypeListMsgController.h"
#import "LKTypeListMsgModel.h"

@implementation LKTypeListMsgController
{
    LKTypeListMsgModel * _model;
}

- (void)initController {
    _model = [[LKTypeListMsgModel alloc] init];
    [self registerModel:_model];
}

- (void) sendMessageID:(int)msgID messageInfo:(id)msgInfo {
    if (msgInfo) {
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
