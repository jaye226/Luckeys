//
//  LKFriendLikeListModel.m
//  Luckeys
//
//  Created by lishaowei on 15/11/21.
//  Copyright © 2015年 Luckeys. All rights reserved.
//

#import "LKFriendLikeListModel.h"
#import "LKCommentData.h"
#import "LKPersonLikeData.h"

@interface LKFriendLikeListModel ()
{
    NSMutableArray *_list;
}
@end

@implementation LKFriendLikeListModel

@synthesize infoArray = _list;

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
            NSDictionary * body = dict[@"body"];
            
            if (msgID == kRequstFriendLikeListTag) {
                if ([body objectForKey:@"data"] > 0) {
                    [_list removeAllObjects];
                }
                for (NSDictionary *dic in [body objectForKey:@"data"]) {
                    [_list addObject:[LKPersonLikeData makeDataModel:dic]];
                }
            }else if (msgID == kRequstFriendLikeMoreTag)
            {
                _loadMoreArray = [body objectForKey:@"data"];
                
                for (NSDictionary *dic in [body objectForKey:@"data"]) {
                    [_list addObject:[LKPersonLikeData makeDataModel:dic]];
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