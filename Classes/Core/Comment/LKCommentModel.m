//
//  LKCommentModel.m
//  Luckeys
//
//  Created by lishaowei on 15/11/15.
//  Copyright © 2015年 Luckeys. All rights reserved.
//

#import "LKCommentModel.h"
#import "LKCommentData.h"

@interface LKCommentModel ()
{
    NSMutableArray *_list;
}
@end

@implementation LKCommentModel

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
            
            if (msgID == kRequstCommentListTag) {
                if ([body objectForKey:@"data"] > 0) {
                    [_list removeAllObjects];
                }
                for (NSDictionary *dic in [body objectForKey:@"data"]) {
                    [_list addObject:[LKCommentData makeDataModel:dic]];
                }
            }else if (msgID == kRequstCommentMoreTag)
            {
                _loadMoreArray = [body objectForKey:@"data"];
                
                for (NSDictionary *dic in [body objectForKey:@"data"]) {
                    [_list addObject:[LKCommentData makeDataModel:dic]];
                }
            }else if (msgID == kRequstCommentUsefulTag)
            {
                [self setUsed:[body objectForKey:@"commentUuid"]];
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

- (void)setUsed:(NSString *)commentUuid
{
    for (LKCommentData *data in _list) {
        if ([data.commentUuid isEqualToString:commentUuid]) {
            data.used = @"1";
        }
    }
}

- (void) handleError:(NSString *)errorMsg errCode:(int)code messageID:(int)msgID
{
    [self update:self msgID:msgID errCode:eDataCodeFaild];
}

@end