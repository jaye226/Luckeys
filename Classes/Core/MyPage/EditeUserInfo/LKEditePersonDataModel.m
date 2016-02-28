//
//  LKEditePersonDataModel.m
//  Luckeys
//
//  Created by 李锦华 on 15/10/24.
//  Copyright © 2015年 Luckeys. All rights reserved.
//

#import "LKEditePersonDataModel.h"

@implementation LKEditePersonDataModel
- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void) handleSucessData:(id)dataSource messageID:(int)msgID {
    NSDictionary *dict = nil;
    dict=[PADataObject jsonDataToObject:dataSource];
    if (dict) {
        NSInteger code = [dict[@"code"] integerValue];
        if (code == eCodeSuccess) {
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

- (void) handleError:(NSString *)errorMsg errCode:(int)code messageID:(int)msgID {
    [self update:self msgID:msgID errCode:eDataCodeFaild];
}

@end
