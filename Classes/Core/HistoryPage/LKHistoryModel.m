//
//  LKHistoryModel.m
//  Luckeys
//
//  Created by lishaowei on 15/11/1.
//  Copyright © 2015年 Luckeys. All rights reserved.
//

#import "LKHistoryModel.h"
#import "LKHistoryBettingData.h"

@implementation LKHistoryModel

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.listData = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

- (void) handleSucessData:(id)dataSource messageID:(int)msgID {
    NSDictionary *dict = [PADataObject jsonDataToObject:dataSource];
    if (dict) {
        NSInteger code = [dict[@"code"] integerValue];
        if (code == eCodeSuccess)
        {
            NSDictionary * body = dict[@"body"];
            if (msgID == 999||msgID==1111) {
                [self.listData removeAllObjects];
                for (NSDictionary *dic in body) {
                    LKHistoryBettingData *data = [LKHistoryBettingData makeDataModel:dic];
                    if (msgID == 999 && ([data.chipsStatus isEqualToString:@"1"]&&[data.countDown integerValue] > 0)) {
                        continue;
                    }else{
                        [self.listData addObject:data];
                    }
                }
            }else if (msgID == 1000)
            {
                [self.listData removeAllObjects];
                for (NSDictionary *dic in body) {
                    LKHistoryBettingData *data = [LKHistoryBettingData makeDataModel:dic];
                    if (msgID == 999 && ([data.chipsStatus isEqualToString:@"1"]&&[data.countDown integerValue] > 0)) {
                        continue;
                    }else{
                        [self.listData addObject:data];
                    }
                }
            }else{
                NSString * uuid = body[@"activityUuid"];
                
                for (LKHistoryBettingData * data in self.listData) {
                    if ([data.activityUuid isEqualToString:uuid])
                    {
                        if ([data.iLike boolValue]) {
                            data.iLike = @"0";
                        }
                        else
                        {
                            data.iLike = @"1";
                        }
                        break;
                    }
                }
            }
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

- (void) handleError:(NSString *)errorMsg errCode:(int)code messageID:(int)msgID
{
    if (msgID == 1000 || msgID == 1111 || msgID == 999)
    {
        [self.listData removeAllObjects];
    }
    [self update:self msgID:msgID errCode:eDataCodeFaild];
}

@end