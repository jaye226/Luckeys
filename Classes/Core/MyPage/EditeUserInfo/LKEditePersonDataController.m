//
//  LKEditePersonDataController.m
//  Luckeys
//
//  Created by 李锦华 on 15/10/17.
//  Copyright © 2015年 Luckeys. All rights reserved.
//

#import "LKEditePersonDataController.h"
#import "LKEditePersonDataModel.h"

@implementation LKEditePersonDataController{
    LKEditePersonDataModel *_infoModel;
}

-(void)initController
{
    _infoModel=[[LKEditePersonDataModel alloc] init];
    [self registerModel:_infoModel];
}

-(void)sendMessageID:(int)msgID messageInfo:(id)msgInfo
{
    if ([msgInfo isKindOfClass:[NSDictionary class]] && msgInfo) {
        NSDictionary *info = (NSDictionary *)msgInfo;
        
        NSString *bodyString = [info objectForKey:kRequestBody];
        NSString *URLString = [info objectForKey:kRequestUrl];
        
        [[MLHttpRequestManager sharedMLHttpRequestManager] sendHttpRequestWithTag:msgID URLString:URLString requestType:Request_Normal bodyString:bodyString jsCallBack:nil Finished:^(Result_TYPE success, int requestTag, id callbackData) {
            if (success == Result_Success) {
                [_infoModel handleSucessData:callbackData messageID:requestTag];
            }
            else if(success == Result_TimeOut){
                [_infoModel handleError:callbackData errCode:Result_TimeOut messageID:requestTag];
            }
            else if(success == Result_Fail){
                 [_infoModel handleError:callbackData errCode:eDataCodeFaild messageID:requestTag];
            }
        }];
    }
}
@end
