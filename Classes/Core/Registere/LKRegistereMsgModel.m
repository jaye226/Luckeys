//
//  LKRegistereMsgModel.m
//  Luckeys
//
//  Created by lishaowei on 15/9/19.
//  Copyright © 2015年 Luckeys. All rights reserved.
//

#import "LKRegistereMsgModel.h"

@implementation LKRegistereMsgModel

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void) handleSucessData:(id)dataSource messageID:(int)msgID
{
    NSDictionary *dict = [PADataObject jsonDataToObject:dataSource];
    _message = @"";
    if (dict) {
        _message = dict[@"message"];
        NSInteger code = [dict[@"code"] integerValue];
        if (code == eCodeSuccess && _message.length == 0) {
            NSDictionary * body = dict[@"body"];
            [LKShareUserInfo share].userInfo = [LKUserData makeDataModel:body];

            [self update:self msgID:msgID errCode:eDataCodeSuccess];
        }
        else {
            [self update:self msgID:msgID errCode:eDataCodeFaild];
        }
        
    }
    else {
        [self update:self msgID:msgID errCode:eDataCodeFaild];
    }
}

- (void)handleError:(NSString *)errorMsg errCode:(int)code messageID:(int)msgID {
    _message = @"";
    [self update:self msgID:msgID errCode:eDataCodeFaild];
}


@end
