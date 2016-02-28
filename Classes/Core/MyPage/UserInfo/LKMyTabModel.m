//
//  LKMyTabModel.m
//  Luckeys
//
//  Created by 李锦华 on 15/10/24.
//  Copyright © 2015年 Luckeys. All rights reserved.
//

#import "LKMyTabModel.h"
#import "LKTypeData.h"
#import "LKUserData.h"

@implementation LKMyTabModel
{
    NSMutableArray * _arrays;
}

@synthesize dataArray=_arrays;

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.curPage = 1;
        _arrays = [NSMutableArray arrayWithCapacity:0];
    }
    return self;
}

- (void) handleSucessData:(id)dataSource messageID:(int)msgID
{
    NSDictionary *dict = nil;
    dict=[PADataObject jsonDataToObject:dataSource];
    if (dict)
    {
        NSInteger code = [dict[@"code"] integerValue];
        if (code == eCodeSuccess)
        {
            if(msgID==10010)
            {
                [_arrays removeAllObjects];
                NSArray * datas = dict[@"body"];
                for (NSDictionary *  item in datas)
                {
                    [_arrays addObject:[LKTypeData makeDataModel:item]];
                }
                if (_arrays.count == [kPageCoutTag integerValue]) {
                    self.curPage = 2;
                }else{
                    self.curPage = kNoCurPage;
                }
            }
            else if (msgID == kPersonWinUserBtnTag)
            {
                _codeUuid = [dict[@"body"] objectForKey:@"codeUuid"];
            }
            else if (msgID == kLoadMoreTag)
            {
                NSArray * datas = dict[@"body"];
                for (NSDictionary *  item in datas)
                {
                    [_arrays addObject:[LKTypeData makeDataModel:item]];
                }
                if (datas.count == [kPageCoutTag integerValue])
                {
                    self.curPage += 1;
                }else{
                    self.curPage = kNoCurPage;
                }
            }
            else
            {
                if ([dict[@"body"] isKindOfClass:[NSDictionary class]]) {
                    _userData=[LKUserData makeDataModel:dict[@"body"]];
                }else{
                    [self update:self msgID:msgID errCode:eDataCodeFaild];
                    return;
                }
                
            }
            [self update:self msgID:msgID errCode:eDataCodeSuccess];
        }
        else
        {
            if (msgID == kPersonWinUserBtnTag)
            {
                _codeUuid = @"";
            }
            [self update:self msgID:msgID errCode:eDataCodeFaild];
        }
    }
    else
    {
        if (msgID == kPersonWinUserBtnTag)
        {
            _codeUuid = @"";
        }
        [self update:self msgID:msgID errCode:eDataCodeFaild];
    }
    
}

- (void) handleError:(NSString *)errorMsg errCode:(int)code messageID:(int)msgID
{
    [self update:self msgID:msgID errCode:eDataCodeFaild];
}
@end
