//
//  LKTools.h
//  Luckeys
//
//  Copyright © 2015年 Luckeys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LKTools : NSObject

+ (CGSize)getStringSize:(NSString *)string fontSize:(float)font;

/**
 *  时间戳转换日期
 *
 *  @param longTime 时间戳字符串
 *  @param format   日期格式,@"yyyy"  yyyy:年 | MM:月 | dd:日 | hh:时 | mm:分 | ss:秒
 *
 *  @return 返回日期格式对应的日期
 */
+(NSString *)transTime:(NSString *)longTime dateFormat:(NSString *)format;


/**
 *  给基类请求增加 userUuid
 *
 *  @param body 请求原始body
 *
 *  @return 完整body
 */
+ (NSDictionary*)addRequestBody:(NSDictionary*)body;

@end
