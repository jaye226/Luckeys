//
//  LKHomeMsgModel.m
//  Luckeys
//
//  Created by BearLi on 15/10/17.
//  Copyright © 2015年 Luckeys. All rights reserved.
//

#import "LKHomeMsgModel.h"
#import "LKTypeData.h"


@implementation LKHomeMsgModel
{
    NSMutableArray * _arrays;
}

@synthesize dataArray = _arrays;

- (instancetype)init
{
    self = [super init];
    if (self) {
        _nextPage = 1;
        _arrays = [NSMutableArray arrayWithCapacity:0];
    }
    return self;
}

- (void) handleSucessData:(id)dataSource messageID:(int)msgID {
    NSDictionary *dict = [PADataObject jsonDataToObject:dataSource];
    _message = @"";
    if (dict) {
        NSInteger code = [dict[@"code"] integerValue];
         _message = dict[@"message"];
        if (code == eCodeSuccess) {
            NSDictionary * body = dict[@"body"];
            if (msgID == 1111) {
                NSArray * datas = body[@"data"];
                if (_nextPage == 1) {
                    [_arrays removeAllObjects];
                }
                for (NSDictionary *  item in datas) {
                    [_arrays addObject:[LKTypeData makeDataModel:item]];
                }
                [self update:self msgID:msgID errCode:eDataCodeSuccess];
            }
            else if (msgID == 2222) {
                NSString * uuid = body[@"activityUuid"];
                [self update:uuid msgID:msgID errCode:eDataCodeSuccess];
            }else if (msgID == 3333){
                NSArray * datas = body[@"data"];
                for (NSDictionary *  item in datas) {
                    [_arrays addObject:[LKTypeData makeDataModel:item]];
                }
                [self update:self msgID:msgID errCode:eDataCodeSuccess];
            }
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
    _message = @"";
    [self update:self msgID:msgID errCode:eDataCodeFaild];
}
@end
