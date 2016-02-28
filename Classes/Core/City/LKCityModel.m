//
//  LKCityModel.m
//  Luckeys
//
//  Created by lishaowei on 15/11/25.
//  Copyright © 2015年 Luckeys. All rights reserved.
//

#import "LKCityModel.h"
#import "LKCityData.h"

@interface LKCityModel ()
{
    NSMutableArray *_list;
}

@end

@implementation LKCityModel

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

- (void) handleSucessData:(id)dataSource messageID:(int)msgID
{
    NSDictionary *dict = [PADataObject jsonDataToObject:dataSource];
    if (dict)
    {
        NSInteger code = [dict[@"code"] integerValue];
        if (code == eCodeSuccess)
        {
            NSDictionary * body = dict[@"body"];
            
            if (msgID == kRequstCityListTag)
            {
                [self.infoArray removeAllObjects];
                for (NSDictionary *dic in body) {
                    [self.infoArray addObject:[LKCityData makeDataModel:dic]];
                }
            }
            
            [self update:self msgID:msgID errCode:eDataCodeSuccess];
        }
        else
        {
            [self update:self msgID:msgID errCode:eDataCodeFaild];
        }
    }
    else
    {
        [self update:self msgID:msgID errCode:eDataCodeFaild];
    }
    
}


- (void) handleError:(NSString *)errorMsg errCode:(int)code messageID:(int)msgID
{
    [self update:self msgID:msgID errCode:eDataCodeFaild];
}

@end
