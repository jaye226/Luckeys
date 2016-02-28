//
//  LKTools.m
//  Luckeys
//
//  Copyright © 2015年 Luckeys. All rights reserved.
//

#import "LKTools.h"

@implementation LKTools
//计算size
+ (CGSize)getStringSize:(NSString *)string fontSize:(float)font{
    CGSize size;
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:font]};
    size = [string sizeWithAttributes:attributes];
    return size;
}

+(NSString *)transTime:(NSString *)longTime dateFormat:(NSString *)format{
    double timelong = [longTime doubleValue]/1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970: timelong];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSString *dateString = [dateFormatter stringFromDate: date];
    return dateString;
}

+ (NSDictionary*)addRequestBody:(NSDictionary*)body {
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    if ([LKShareUserInfo share].userInfo.userUuid.length == 0) {
        [LKShareUserInfo share].userInfo.userUuid = @"";
    }
    
    if (body) {
        dict = [NSMutableDictionary dictionaryWithDictionary:body];
    }
    
    [dict setValue:[LKShareUserInfo share].userInfo.userUuid forKey:@"userUuid"];
    return dict;
}

@end
