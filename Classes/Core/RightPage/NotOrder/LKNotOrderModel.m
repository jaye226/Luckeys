//
//  LKNotOrderModel.m
//  Luckeys
//
//  Created by lishaowei on 16/1/17.
//  Copyright © 2016年 Luckeys. All rights reserved.
//

#import "LKNotOrderModel.h"
#import "LKNotOrderData.h"

@interface LKNotOrderModel ()
{
    NSMutableArray *_list;
}
@end

@implementation LKNotOrderModel

@synthesize list = _list;

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _list = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

- (void) handleSucessData:(id)dataSource messageID:(int)msgID {
    NSDictionary *dict = [PADataObject jsonDataToObject:dataSource];
    if (dict) {
        NSInteger code = [dict[@"code"] integerValue];
        if (code == eCodeSuccess)
        {
            NSArray * bodyArray = dict[@"body"];
            
            if (msgID == kRefreshTag)
            {
                [_list removeAllObjects];
            }
            
            for (NSDictionary *dic in bodyArray)
            {
                LKNotOrderData *data = [LKNotOrderData makeDataModel:dic];
                [_list addObject:data];
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
