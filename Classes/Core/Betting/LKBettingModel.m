//
//  LKBettingModel.m
//  Luckeys
//
//  Created by lishaowei on 15/11/1.
//  Copyright © 2015年 Luckeys. All rights reserved.
//

#import "LKBettingModel.h"
#import "LKBettingData.h"

@implementation LKBettingModel

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
            
            if (msgID == 1000) {
                NSDictionary * body = dict[@"body"];
                for (NSDictionary *dic in body) {
                    LKBettingData *data = [LKBettingData makeDataModel:dic];
                    [self.listData addObject:data];
                }
            }else{
                if ([[dict[@"body"] objectForKey:@"listCode"] count] > 0)
                {
                    self.failureListData = [NSMutableArray arrayWithArray:[dict[@"body"] objectForKey:@"listCode"]];
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
    [self update:self msgID:msgID errCode:eDataCodeFaild];
}

@end
