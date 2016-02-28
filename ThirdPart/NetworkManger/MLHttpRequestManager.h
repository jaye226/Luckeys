//
//  MLHttpRequestManager.h
//  MLPlayer
//
//  Created by robin on 15/6/2.
//  Copyright (c) 2015年 w. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASINetworkQueue.h"

typedef enum {
    Request_Normal = 0, //数据请求
    Request_Login,      //登录请求
    Request_H5,         //H5相关请求
    Request_Alert,      //显示弹窗
    Request_Upload,     //上传图片
    Request_UploadHead, //上传头像
    Request_Download,   //下载文件
    Request_UpBackImage //背景图片
}Request_TYPE;          //请求的类型

typedef enum {
    Result_Fail = 0,    //请求失败
    Result_Success,     //请求成功
    Result_TimeOut      //请求超时
}Result_TYPE;           //返回结果类型


/**
 服务器定义的code返回值 。0失败，1成功
 */
typedef enum : NSUInteger {
    eCodeFailed = 0,    //服务器定义code
    eCodeSuccess,       //code = 1 成功
} Code_Type;


@interface MLHttpRequestManager : NSObject
@property (nonatomic,strong)ASINetworkQueue *networkQueue;

/**
 * 实例化 httpRequestManager 单例
 *
 */
+(id)sharedMLHttpRequestManager;

/**
 *  发送请求 PAHTTPRequest
 *
 *  @param tag                 请求的tag值
 *  @param URLString           请求的URLString
 *  @param type                请求的类型
 *  @param body                要传送的数据(NSString & NSDictionary)
 *  @param jsString            H5请求携带字符串
 *  @param finishBlock         block回调
 *
 */
- (void)sendHttpRequestWithTag:(int)tag
                     URLString:(NSString *)URLString
                   requestType:(Request_TYPE)type
                    bodyString:(id)body
                    jsCallBack:(NSString *)jsString
                      Finished:(void (^)(Result_TYPE success,int requestTag, id callbackData))finishBlock;

/**
 *  上传接口 ASIHTTPRequest
 *
 *  @param tag               请求的tag值
 *  @param URLString         请求的URLString
 *  @param type              请求的类型
 *  @param aImage            上传数据
 *  @param finishBlock       block回调
 *
 */
- (void)uploadRequestWithTag:(int)tag
                   URLString:(NSString *)URLString
                 requestType:(Request_TYPE)type
                  uploadData:(id)aImage
                    Finished:(void (^)(Result_TYPE success,int requestTag, id callbackData))finishBlock;

/**
 *  下载接口 ASIHTTPRequest 需要跟踪进度
 *
 *  @param tag                 请求的tag值
 *  @param URLStirng           请求的URLStirng
 *  @param type                请求的类型
 *  @param requestInfo         请求的信息
 *  @param startBlock          下载开始block回调
 *  @param progressBlcok       下载进度block回调
 *  @param finishBlock         下载完成block回调
 *
 */
- (void)downloadRequestWithTag:(int)tag
                     URLString:(NSString *)URLString
                   requestType:(Request_TYPE)type
                   requestInfo:(NSDictionary *)requestInfo
                       Started:(void (^)(NSDictionary *requestInfo))startBlock
                      Progress:(void (^)(float newProgress))progressBlock
                      Finished:(void (^)(Result_TYPE success,int requestTag, id callbackData))finishBlock;
/**
 *  下载接口 ASIHTTPRequest  不需要进度跟踪
 *
 *  @param tag                 请求的tag值
 *  @param URLStirng           请求的URLStirng
 *  @param type                请求的类型
 *  @param requestInfo         请求的信息
 *  @param finishBlock         下载完成block回调
 *
 */
- (void)downloadRequestWithTag:(int)tag
                     URLString:(NSString *)URLString
                   requestType:(Request_TYPE)type
                   requestInfo:(NSDictionary *)requestInfo
                      Finished:(void (^)(Result_TYPE success,int requestTag, id callbackData))finishBlock;

/**
 *  取消请求
 *
 *  @param url          请求url
 *  @param tag          请求tag
 *
 */
- (void)cancelHttpRequestWithUrl:(NSString *)url andTag:(NSInteger)tag;

/**
 *  取消所有请求
 */
- (void)removeAllHttpRequest;


@end
