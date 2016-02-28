//
//  HttpRequest_Parser.h
//  MLPlayer
//
//  Created by robin on 15/6/3.
//  Copyright (c) 2015年 w. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MLHttpRequestManager.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "ASIDownloadCache.h"

@protocol HttpRequest_Parser_Delegate;

@interface HttpRequest_Parser : NSObject<ASIHTTPRequestDelegate,ASIProgressDelegate,NSURLConnectionDataDelegate,NSURLConnectionDelegate,NSXMLParserDelegate>
{
    __unsafe_unretained MLHttpRequestManager *manager;  //请求统一管理器
}
@property (nonatomic, strong) id             requestBody;                    //请求post数据
@property (nonatomic, assign) int            requestTag;                     //请求Tag
@property (nonatomic, strong) NSString     * requestUrl;                     //请求的URL
@property (nonatomic, strong) NSString     * jsCallBack;                     //请求的URL
@property (nonatomic, strong) NSDictionary * requestHeadInfo;                //请求head信息
@property (nonatomic, strong) NSDictionary * otherInfo;                      //请求的其他信息
@property (nonatomic, strong) id             request;                        //请求
@property (nonatomic, assign) Request_TYPE   requestType;                    //请求类型
@property (nonatomic, assign) id<HttpRequest_Parser_Delegate>parserDelegate; //代理
@property (strong) void (^startBlock)(NSDictionary * requestInfo);
@property (strong) void (^progressBlock)(float newProgress);
@property (strong) void (^finishBlock)(Result_TYPE success,int requestTag, id callbackData);

@property (nonatomic,strong) MKNetworkEngine *engine;
@property (nonatomic,strong) MKNetworkOperation *op;

/**
 *  发送请求 PAHTTPRequest
 *
 *  @param tag               请求的tag值
 *  @param URLString         请求的URLString
 *  @param type              请求的类型
 *  @param body              要传送的数据(NSString & NSDictionary)
 *  @param jsString          H5请求携带字符串
 *  @param callback          回调代理
 *  @param finishBlock       block回调
 *
 */
- (id)initWithTag:(int)tag
        URLString:(NSString *)URLString
      requestType:(Request_TYPE)type
       bodyString:(id)body
       jsCallBack:(NSString *)jsString
      andCallBack:(id<HttpRequest_Parser_Delegate>)callback
         Finished:(void (^)(Result_TYPE success,int requestTag, id callbackData))finishBlock;

/**
 *  上传图片 ASIHTTPRequest
 *
 *  @param tag               请求的tag值
 *  @param URLString         请求的URLString
 *  @param type              请求的类型
 *  @param aImage            要传送的数据
 *  @param callback          回调代理
 *  @param finishBlock       block回调
 *
 */
- (id)initWithTag:(int)tag
        URLString:(NSString *)URLString
      requestType:(Request_TYPE)type
       uploadData:(id)aImage
      andCallBack:(id<HttpRequest_Parser_Delegate>)callback
         Finished:(void (^)(Result_TYPE success,int requestTag, id callbackData))finishBlock;

/**
 *  下载文件 ASIHTTPRequest   进度跟踪
 *
 *  @param tag               请求的tag值
 *  @param URLString         请求的URLString
 *  @param type              请求的类型
 *  @param requestInfo       请求的文件信息
 *  @param startBlock        下载开始block回调
 *  @param progressBlock     下载进度block回调
 *  @param finishBlock       下载完成block回调
 *
 */
- (id)initWithTag:(int)tag
        URLString:(NSString *)URLString
      requestType:(Request_TYPE)type
      requestInfo:(NSDictionary *)requestInfo
      andCallBack:(id<HttpRequest_Parser_Delegate>)callback
          Started:(void (^)(NSDictionary *requestInfo))startBlock
         Progress:(void (^)(float newProgress))progressBlock
         Finished:(void (^)(Result_TYPE success,int requestTag, id callbackData))finishBlock;
/**
 *  下载文件 ASIHTTPRequest   不需要进度跟踪
 *
 *  @param tag               请求的tag值
 *  @param URLString         请求的URLString
 *  @param type              请求的类型
 *  @param requestInfo       请求的文件信息
 *  @param finishBlock       下载完成block回调
 *
 */
- (id)initWithTag:(int)tag
        URLString:(NSString *)URLString
      requestType:(Request_TYPE)type
      requestInfo:(NSDictionary *)requestInfo
      andCallBack:(id<HttpRequest_Parser_Delegate>)callback
         Finished:(void (^)(Result_TYPE success,int requestTag, id callbackData))finishBlock;
@end

@protocol HttpRequest_Parser_Delegate <NSObject>

/**
 *  HttpRequest_Parser_Delegate
 *
 *  @param url              请求对象url
 *  @param resultDict       得到的数据
 *  @param statu            请求的状态
 *  @param error            错误信息
 *
 */
- (void)httpRequest_ParserRequestFinished:(NSString *)url
                               resultData:(id)resultDict
                                   status:(Result_TYPE)statu
                                    error:(NSError *) error;
@end
