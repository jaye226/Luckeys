//
//  NSString+Extra.h
//  KaiKaiBa
//
//  Created by lishaowei on 15/8/2.
//  Copyright (c) 2015年 battery. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extra)

- (NSString*)urlEncodedString;

- (NSString*)urlDecodedString;

/**
 *  转化时间戳
 *
 */
+(NSString *)transTime:(NSString *)longTime Format:(NSString *)format;

@end
