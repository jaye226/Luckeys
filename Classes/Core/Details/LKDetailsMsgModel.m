//
//  LKDetailsMsgModel.m
//  Luckeys
//
//  Created by lishaowei on 15/10/24.
//  Copyright © 2015年 Luckeys. All rights reserved.
//

#import "LKDetailsMsgModel.h"
#import "LKBetUserData.h"
#import "LKSectionData.h"
#import "LKCommentData.h"
#import "LKRecommendActivityData.h"
#import "LKToCommentData.h"

@interface LKDetailsMsgModel ()
{
    LKDetailsData *_data;
    NSMutableArray *_list;
}
@end

@implementation LKDetailsMsgModel

@synthesize infoArray = _list;
@synthesize detailsData = _data;

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
        NSDictionary * body = dict[@"body"];
        if (code == eCodeSuccess)
        {
            if (msgID == 1000) {
                _data = [LKDetailsData makeDataModel:body];
                
                if ([_data.listBetUser count]) {
                    LKBetUserData *betUserData = [[LKBetUserData alloc] init];
                    [_list addObject:betUserData];
                }
                
                LKSectionData *sectionData = [[LKSectionData alloc] init];
                sectionData.isComment = YES;
                [_list addObject:sectionData];
                
                if ([_data.listCommentUser count]) {
                    sectionData.isShowMore = YES;
                    [_list addObjectsFromArray:_data.listCommentUser];
                }
                
                LKToCommentData *toCommentData = [[LKToCommentData alloc] init];
                [_list addObject:toCommentData];
                
                if ([_data.listActivity count]) {
                    LKSectionData *sectionData = [[LKSectionData alloc] init];
                    sectionData.isComment = NO;
                    [_list addObject:sectionData];
                    [_list addObjectsFromArray:_data.listActivity];
                }
            }else if (msgID == 1001)
            {
                _data = [LKDetailsData makeDataModel:body];
                
                [_list removeAllObjects];
                
                if ([_data.listBetUser count]) {
                    LKBetUserData *betUserData = [[LKBetUserData alloc] init];
                    [_list addObject:betUserData];
                }
                
                if ([_data.listCommentUser count]) {
                    
                    LKSectionData *sectionData = [[LKSectionData alloc] init];
                    sectionData.isComment = YES;
                    [_list addObject:sectionData];
                    
                    [_list addObjectsFromArray:_data.listCommentUser];
                }
                
                LKToCommentData *toCommentData = [[LKToCommentData alloc] init];
                [_list addObject:toCommentData];
                
                if ([_data.listActivity count]) {
                    LKSectionData *sectionData = [[LKSectionData alloc] init];
                    sectionData.isComment = NO;
                    [_list addObject:sectionData];
                    [_list addObjectsFromArray:_data.listActivity];
                }
            }else if (msgID == 1009)
            {
                for (id object in _list) {
                    if ([object isKindOfClass:[LKCommentData class]]) {
                        LKCommentData *data = (LKCommentData *)object;
                        NSString *commentUuid = [body objectForKey:@"commentUuid"];
                        if ([data.commentUuid isEqualToString:commentUuid]) {
                            data.used = @"1";
                        }
                    }
                }
            }else if (msgID == kWinUserBtn)
            {
                NSString *praises = [NSString stringWithFormat:@"%ld", [self.detailsData.winUserData.praises integerValue]+1];
                self.detailsData.winUserData.isPraises = @"1";
                self.detailsData.winUserData.praises = praises;
            }else if (msgID == kLikeButton)
            {
                if ([self.detailsData.iLike boolValue]) {
                    self.detailsData.iLike = @"0";
                }
                else
                {
                    self.detailsData.iLike = @"1";
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
