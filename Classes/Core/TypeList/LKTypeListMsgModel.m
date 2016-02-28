//
//  LKTypeListMsgModel.m
//  Luckeys
//
//  Created by BearLi on 15/10/24.
//  Copyright © 2015年 Luckeys. All rights reserved.
//

#import "LKTypeListMsgModel.h"
#import "LKTypeData.h"

@interface LKTypeListMsgModel ()
{
    NSMutableArray * _arrays;
}

@end

@implementation LKTypeListMsgModel

@synthesize dataArray = _arrays;

- (instancetype)init
{
    self = [super init];
    if (self) {
        _nextPage = 1;
        _arrays = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

- (void)handleSucessData:(id)dataSource messageID:(int)msgID {
    NSDictionary * dict = [PADataObject jsonDataToObject:dataSource];
    _message = @"";
    if (dict) {
        NSInteger code = [dict[@"code"] integerValue];
        if (code == eCodeSuccess) {
            if (msgID == kLikeTag)
            {
                NSDictionary * body = dict[@"body"];
                NSString * uuid = body[@"activityUuid"];
                [self update:uuid msgID:msgID errCode:eDataCodeSuccess];
            }else{
                NSDictionary * body = dict[@"body"];
                NSArray * datas = body[@"data"];
                _message = dict[@"message"];
                if (_nextPage == 1) {
                    [_arrays removeAllObjects];
                }
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

- (void)handleError:(NSString *)errorMsg errCode:(int)code messageID:(int)msgID {
    [self update:nil msgID:msgID errCode:eDataCodeFaild];
}

@end
