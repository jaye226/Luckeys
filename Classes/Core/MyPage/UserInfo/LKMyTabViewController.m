//
//  LKMyTabViewController.m
//  Luckeys
//
//  Created by 李锦华 on 15/10/17.
//  Copyright © 2015年 Luckeys. All rights reserved.
//

#import "LKMyTabViewController.h"
#import "LKMyTabModel.h"

@implementation LKMyTabViewController{
     LKMyTabModel *_infoModel;
}

-(void)initController
{
    _infoModel=[[LKMyTabModel alloc] init];
    [self registerModel:_infoModel];
}

-(void)sendMessageID:(int)msgID messageInfo:(id)msgInfo
{
    if ([msgInfo isKindOfClass:[NSDictionary class]] && msgInfo) {
        
        if (msgID == kPersonWinUserBtnTag || msgID == 10010 || msgID == kLoadMoreTag) {
            NSString * url = msgInfo[kRequestUrl];
            id body = msgInfo[kRequestBody];
            [[MLHttpRequestManager sharedMLHttpRequestManager] sendHttpRequestWithTag:msgID URLString:url requestType:Request_Normal bodyString:body jsCallBack:nil Finished:^(Result_TYPE success, int requestTag, id callbackData) {
                if (success == Result_Success) {
                    [_infoModel handleSucessData:callbackData messageID:requestTag];
                }
                else {
                    [_infoModel handleError:nil errCode:Result_Fail messageID:requestTag];
                }
            }];
        }else{
            
            NSDictionary *info = (NSDictionary *)msgInfo;
            
            NSString *bodyString = [info objectForKey:kRequestBody];
            NSString *URLString = [info objectForKey:kRequestUrl];
            
            NSString *url=[NSString stringWithFormat:@"%@?userUuid=%@",URLString,bodyString];
            
            [[MLHttpRequestManager sharedMLHttpRequestManager] sendHttpRequestWithTag:msgID URLString:url requestType:Request_Normal bodyString:nil jsCallBack:nil Finished:^(Result_TYPE success, int requestTag, id callbackData) {
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
}
@end
