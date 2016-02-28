//
//  LKShareMsgModel.m
//  Luckeys
//
//  Created by BearLi on 15/11/1.
//  Copyright © 2015年 Luckeys. All rights reserved.
//

#import "LKShareMsgModel.h"
#import "LKFriendsData.h"

@interface LKShareMsgModel ()
{
    NSMutableArray * _collArray;
    NSMutableArray * _shareArray;
}
@end

@implementation LKShareMsgModel

@synthesize collectionArray = _collArray;
@synthesize shareArray = _shareArray;

- (instancetype)init
{
    self = [super init];
    if (self) {
        _shareNextPage = 0;
        _collectionNextPage = 0;
        _shareArray = [NSMutableArray arrayWithCapacity:0];
        _collArray = [NSMutableArray arrayWithCapacity:0];
    }
    return self;
}

- (void)handleSucessData:(id)dataSource messageID:(int)msgID {
    NSDictionary * dict = [PADataObject jsonDataToObject:dataSource];
    if (dict) {
        NSInteger code = [dict[@"code"] integerValue];
        if (code == eCodeSuccess) {
            NSDictionary * body = dict[@"body"];
            
            if (msgID == kQuerySharePageRefshTag)
            {
                NSArray * datas = body[@"data"];
                
                [_shareArray removeAllObjects];
                
                if (datas.count == [kLKPageSize integerValue])
                {
                    self.shareNextPage +=1;
                }
                else
                {
                    self.shareNextPage =0;
                }
                
                for (NSDictionary *  item in datas)
                {
                    [_shareArray addObject:[LKFriendsData makeDataModel:item]];
                }
            }
            else if (msgID == kQueryShareMoreRefshTag)  //朋友圈加载更多
            {
                NSArray * datas = body[@"data"];
                if (datas.count == [kLKPageSize integerValue])
                {
                    self.shareNextPage +=1;
                }
                else
                {
                    self.shareNextPage =0;
                }
                for (NSDictionary *  item in datas) {
                    [_shareArray addObject:[LKFriendsData makeDataModel:item]];
                }
            }
            else if (msgID == kCollectionTag)
            {
                NSArray * datas = body[@"data"];
                if (datas.count == [kLKPageSize integerValue])
                {
                    self.collectionNextPage +=1;
                }
                else
                {
                    self.collectionNextPage =0;
                }
                for (NSDictionary *  item in datas) {
                    [_collArray addObject:[LKTypeData makeDataModel:item]];
                }
            }
            else if (msgID == kLikeTag) {
                NSString * uuid = body[@"activityUuid"];
                
                for (LKTypeData * data in _collArray) {
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
            }else if (msgID == kCollectionRefshTag)
            {
                NSArray * datas = body[@"data"];
                
                [_collArray removeAllObjects];
                
                if (datas.count == [kLKPageSize integerValue])
                {
                    self.collectionNextPage +=1;
                }
                else
                {
                    self.collectionNextPage =0;
                }
                
                for (NSDictionary *  item in datas) {
                    [_collArray addObject:[LKTypeData makeDataModel:item]];
                }

            }else if (msgID == kRequstCommentTag)
            {
                
            }
            else if (msgID == kWinUserBtn)
            {
                
            }
            [self update:self msgID:msgID errCode:eDataCodeSuccess];
        }
        else {
            [self update:self msgID:msgID errCode:eDataCodeFaild];
        }

    }
    else
    {
        [self update:self msgID:msgID errCode:eDataCodeFaild];
    }
}

- (void)handleError:(NSString *)errorMsg errCode:(int)code messageID:(int)msgID {
    [self update:self msgID:msgID errCode:eDataCodeFaild];
}

@end
