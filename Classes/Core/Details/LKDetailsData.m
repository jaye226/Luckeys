//
//  LKDetailsData.m
//  Luckeys
//
//  Created by lishaowei on 15/10/24.
//  Copyright © 2015年 Luckeys. All rights reserved.
//

#import "LKDetailsData.h"

@implementation LKDetailsData

+(id)makeDataModel:(id)properties
{
    
    LKDetailsData *detailsData = [super makeDataModel:properties];
    detailsData.listBetUser = [LKDetailsData makeClassWithProperties:detailsData.listBetUser customClassName:@"LKBetUserData"];
    detailsData.listActivity = [LKDetailsData makeClassWithProperties:detailsData.listActivity customClassName:@"LKRecommendActivityData"];
    detailsData.listCommentUser = [LKDetailsData makeClassWithProperties:detailsData.listCommentUser customClassName:@"LKCommentData"];
    detailsData.winUserData = [LKWinUserData makeDataModel:[properties objectForKey:@"winUser"]];
    
    return detailsData;
}

@end
