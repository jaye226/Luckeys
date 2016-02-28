//
//  LKShareMsgController.m
//  Luckeys
//
//  Created by BearLi on 15/11/1.
//  Copyright © 2015年 Luckeys. All rights reserved.
//

#import "LKShareMsgController.h"
#import "LKShareMsgModel.h"

@implementation LKShareMsgController
{
    LKShareMsgModel * _model;
}

- (void)initController {
    _model = [[LKShareMsgModel alloc] init];
    [self registerModel:_model];
}

- (void)sendMessageID:(int)msgID messageInfo:(id)msgInfo
{
    if (msgInfo && IsDictionaryClass(msgInfo)) {
        NSString * url = msgInfo[kRequestUrl];
        id body = msgInfo[kRequestBody];
        
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
