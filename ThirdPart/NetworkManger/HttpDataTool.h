//
//  HttpDataTool.h
//  MLPlayer
//
//  Created by robin on 15/6/4.
//  Copyright (c) 2015年 w. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MLHttpRequestManager.h"

@interface HttpDataTool : NSObject

/**
 *  解析处理请求回调数据
 *
 *  @param request               请求(ASIHTTPRequest & PAHttpRequest)
 *  @param responseString        请求返回的数据
 *
 */
+ (NSDictionary *)getDictionaryFromHttpRequest:(id)request
                                   requestType:(Request_TYPE)type
                                    withResult:(NSString *)responseString;

/**
 *  UIImage转NSData 大于300KB的进行压缩
 *
 *  @param aImage               image
 *  @return                     返回NSData
 *
 */
+ (NSData *)UIImageExchangeToNSData:(UIImage *)aImage;

+ (NSString *)unzipDecodeData:(NSData *)requestData;

@end
