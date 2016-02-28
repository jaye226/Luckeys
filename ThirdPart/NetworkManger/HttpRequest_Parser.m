//
//  HttpRequest_Parser.m
//  MLPlayer
//
//  Created by robin on 15/6/3.
//  Copyright (c) 2015年 w. All rights reserved.
//

#import "HttpRequest_Parser.h"
#import "HttpDataTool.h"
#import "DownloadQueue.h"

@interface HttpRequest_Parser()
@property (nonatomic, assign) double totleSize;            //下载文件的大小
@property (nonatomic, assign) NSTimeInterval startTime;    //请求开始时间
@end

@implementation HttpRequest_Parser

@synthesize engine;
@synthesize op;

- (id)initWithTag:(int)tag
        URLString:(NSString *)URLString
      requestType:(Request_TYPE)type
       bodyString:(id)body
       jsCallBack:(NSString *)jsString
      andCallBack:(id<HttpRequest_Parser_Delegate>)callback
         Finished:(void (^)(Result_TYPE success,int requestTag, id callbackData))finishBlock
{
    self = [super init];
    if (self) {
        manager = [MLHttpRequestManager sharedMLHttpRequestManager];
        
        self.finishBlock = finishBlock;
        self.requestTag = tag;
        self.requestUrl = URLString;
        self.requestBody = body;
        self.parserDelegate = callback;
        self.requestType = type;
        
        __weak HttpRequest_Parser *callbackSelf = self;
        
        self.requestBody = [LKTools addRequestBody:body];

        NSMutableDictionary *header = [[NSMutableDictionary alloc] init];
        [header setValue:@"application/json;charset=utf-8" forKey:@"Content-Type"];
        engine = [[MKNetworkEngine alloc] initWithHostName:SeverHost customHeaderFields:header];
        op = [engine operationWithPath:URLString params:self.requestBody httpMethod:@"POST"];
        op.postDataEncoding = MKNKPostDataEncodingTypeJSON;
        [engine emptyCache];
        NSLog(@"请求>>>>>>>>>>>%@",op.readonlyRequest);
            
        [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
            
            NSData *data = [completedOperation.responseString dataUsingEncoding:NSUTF8StringEncoding];
            if (data.length > 0) {
                
                [callbackSelf requestFinished:completedOperation withResult:completedOperation.responseString];
            }
            else
            {
                [callbackSelf requestFailed:completedOperation error:nil];
            }
            
        } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
            NSLog(@"请求失败error： %@", [error localizedDescription]);
            [callbackSelf requestTimeout:completedOperation];
        }];
        [engine enqueueOperation:op];//这里是入列

        self.startTime = [NSDate date].timeIntervalSince1970;
    }
    return self;
}

- (id)initWithTag:(int)tag
        URLString:(NSString *)URLString
      requestType:(Request_TYPE)type
       uploadData:(id)aImage
      andCallBack:(id<HttpRequest_Parser_Delegate>)callback
         Finished:(void (^)(Result_TYPE success,int requestTag, id callbackData))finishBlock
{
    self = [super init];
    if (self) {
        manager = [MLHttpRequestManager sharedMLHttpRequestManager];
        
        self.finishBlock = finishBlock;
        self.requestTag = tag;
        self.requestUrl = URLString;
        self.parserDelegate = callback;
        self.requestType = type;
        
        [self createASIFormDataRequest:URLString
                           requestType:type
                                 image:aImage];
        
        self.startTime = [NSDate date].timeIntervalSince1970;
        
        NSLog(@"client>>>> http image upload [url=%@]",URLString);
    }
    return  self;
}

- (id)initWithTag:(int)tag
        URLString:(NSString *)URLString
      requestType:(Request_TYPE)type
      requestInfo:(NSDictionary *)requestInfo
      andCallBack:(id<HttpRequest_Parser_Delegate>)callback
          Started:(void (^)(NSDictionary *requestInfo))startBlock
         Progress:(void (^)(float newProgress))progressBlock
         Finished:(void (^)(Result_TYPE success,int requestTag, id callbackData))finishBlock{
    
    self = [super init];
    if (self) {
        manager = [MLHttpRequestManager sharedMLHttpRequestManager];
        
        self.startBlock = startBlock;
        self.progressBlock = progressBlock;
        self.finishBlock = finishBlock;
        self.requestTag = tag;
        self.parserDelegate = callback;
        self.requestType = type;
        self.requestUrl = URLString;
        
        [self downloadWithURL:URLString
                  requestInfo:requestInfo];
        
        self.startTime = [NSDate date].timeIntervalSince1970;
        
        NSLog(@"client>>>> http download start [url=%@]",URLString);
    }
    return  self;
}

- (id)initWithTag:(int)tag
        URLString:(NSString *)URLString
      requestType:(Request_TYPE)type
      requestInfo:(NSDictionary *)requestInfo
      andCallBack:(id<HttpRequest_Parser_Delegate>)callback
         Finished:(void (^)(Result_TYPE success,int requestTag, id callbackData))finishBlock {
    self = [super init];
    if (self) {
        manager = [MLHttpRequestManager sharedMLHttpRequestManager];
        
        self.finishBlock = finishBlock;
        self.requestTag = tag;
        self.parserDelegate = callback;
        self.requestType = type;
        self.requestUrl = URLString;
        
        self.startTime = [NSDate date].timeIntervalSince1970;
        
        [self downloadImageWithUrl:URLString requestInfo:requestInfo];
        
        NSLog(@"client>>>> http download start [url=%@]",URLString);
    }
    return  self;
}


/**
 *  发出请求 ASIFormDataRequest
 *
 *  @param url                   请求的url
 *  @param type                  请求的类型
 *  @param aImage                要传送的数据
 *
 */
- (void)createASIFormDataRequest:(NSString *)url
                     requestType:(Request_TYPE)type
                           image:(id)aImage
{
    NSData *imageData = nil;
    if ([aImage isKindOfClass:[UIImage class]]) {
        imageData = [HttpDataTool UIImageExchangeToNSData:aImage];
    }
    else if ([aImage isKindOfClass:[NSData class]]) {
        imageData = (NSData *)aImage;
    }
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    request.delegate=self;
    request.tag = self.requestTag;
    [request setTimeOutSeconds:20];
    [request setRequestMethod:@"POST"];
    [request setDidFinishSelector:@selector(uploadRequestFinished:)];
    [request setDidFailSelector:@selector(uploadRequestFailed:)];
    [request addRequestHeader:@"multipart/form-data" value:@"Content-Type"];
    
    if (type == Request_UploadHead) {
        [request setPostValue:[[LKShareUserInfo share] userInfo].userUuid forKey:@"userUuid"];
        [request setPostValue:@"1" forKey:@"userHead"];
        [request setData:imageData forKey:@"myfiles"];
    }
    else if(type == Request_Upload)
    {
        [request setPostValue:[aImage objectForKey:@"activityUuid"] forKey:@"activityUuid"];
        [request setPostValue:[aImage objectForKey:@"userUuid"] forKey:@"userUuid"];
        [request setPostValue:[aImage objectForKey:@"comment"] forKey:@"comment"];
        
        for (int i = 0;i < [(NSArray *)[aImage objectForKey:@"imageArray"] count]; i++)
        {
            //[request setData:[aImage objectForKey:@"imageArray"] withFileName:[NSString stringWithFormat:@"myfiles%d.png",i] andContentType:@"image/jpeg" forKey:[NSString stringWithFormat:@"myfiles%d",i]];
            [request addData:[[aImage objectForKey:@"imageArray"]objectAtIndex:i] withFileName:[NSString stringWithFormat:@"myfile%d.png",i] andContentType:@"image/jpeg" forKey:[NSString stringWithFormat:@"myfiles"]];
        }
    }
    else if (type == Request_UpBackImage)
    {
        [request setPostValue:[[LKShareUserInfo share] userInfo].userUuid forKey:@"userUuid"];
        [request setPostValue:@"1" forKey:@"backImage"];
        [request setData:imageData forKey:@"myfiles"];
    }
    else
    {
        NSLog(@"Error Request_TYPE:%d",type);
    }
    [request buildPostBody];
    [request startAsynchronous];
}

/**
 *  发出请求 ASIHTTPRequest
 *
 *  @param url               下载文件url
 *  @param requestInfo       下载文件信息
 *
 */
- (void)downloadWithURL:(NSString *)url
            requestInfo:(NSDictionary *)requestInfo
{
    ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request setAllowResumeForFileDownloads:YES];
    [request setShouldAttemptPersistentConnection:YES];
    [request setTimeOutSeconds:45];
    
    NSString *destinationPath = [requestInfo objectForKey:@"destinationPath"];
    NSString *temporaryPath = [requestInfo objectForKey:@"temporaryPath"];
    
    [request setTemporaryFileDownloadPath:temporaryPath];
    [request setDownloadDestinationPath:destinationPath];
    request.userInfo = requestInfo;
    request.delegate = self;
    request.downloadProgressDelegate = self;
    
    DownloadQueue *queue = [DownloadQueue shareDownloadQueue];
    [queue addOperation:request];

    NSLog(@"client>>>> http download [destinationPath=%@]",destinationPath);
}

- (void)downloadImageWithUrl:(NSString *)url
                 requestInfo:(NSDictionary *)requestInfo {
    // 新建一个请求
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request setDelegate:self];
    [request setDownloadCache:[ASIDownloadCache sharedCache]];
    [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy]; // 永久缓存
    [request setDidFinishSelector:@selector(downloadRequestFinished:)];
    [request setDidFailSelector:@selector(downloadRequestFailed:)];
    
    request.userInfo = requestInfo;
    request.downloadDestinationPath=requestInfo[@"address"];
    [manager.networkQueue addOperation:request];
}

/**
 *  请求开始统一处理
 *
 *  @param userInfo      请求携带的数据
 *
 */
- (void)httpRequestStart:(NSDictionary *)userInfo {
    
    if (self.startBlock)
    {
        self.startBlock(userInfo);
    }
}

/**
 *  请求下载进度统一处理
 *
 *  @param progress      下载进度
 *
 */
- (void)httpRequestProgress:(float)progress {
    
    if (self.progressBlock)
    {
        self.progressBlock(progress);
    }
}

/**
 *  请求成功统一处理
 *
 *  @param resultDict      解析得到的数据
 *
 */
- (void)httpRequestSuccess:(id)resultDict {
    
    if (self.finishBlock)
    {
        self.finishBlock(Result_Success,self.requestTag,resultDict);
        self.finishBlock = nil;
    }
    
    if (self.parserDelegate && [self.parserDelegate respondsToSelector:@selector(httpRequest_ParserRequestFinished:resultData:status:error:)]) {
        
        [self.parserDelegate httpRequest_ParserRequestFinished:self.requestUrl
                                                    resultData:resultDict
                                                        status:Result_Success
                                                         error:nil];
    }
}

/**
 *  请求失败统一处理
 *
 *  @param request        请求＋请求携带的信息
 *  @param error          请求错误信息
 *
 */
- (void)httpRequestFailed:(id)request error:(NSError *)error {
    
    if (self.finishBlock)
    {
        if ([request isKindOfClass:[ASIHTTPRequest class]]) {
            ASIHTTPRequest *httpRequest = (ASIHTTPRequest *)request;
            self.finishBlock(Result_Fail,self.requestTag,httpRequest.userInfo);
            self.finishBlock = nil;
        }
        else {
            self.finishBlock(Result_Fail,self.requestTag,self.jsCallBack);
            self.finishBlock = nil;
        }
        
    }
    
    if (self.parserDelegate && [self.parserDelegate respondsToSelector:@selector(httpRequest_ParserRequestFinished:resultData:status:error:)]) {
        
        [self.parserDelegate httpRequest_ParserRequestFinished:self.requestUrl
                                                    resultData:nil
                                                        status:Result_Fail
                                                         error:error];
    }
}

/**
 *  请求超时统一处理
 *
 *  @param request         请求(PAHttpRequest)
 *
 */
- (void)httpRequestTimeout:(id)request {
    
    if (self.finishBlock)
    {
        self.finishBlock(Result_TimeOut,self.requestTag,nil);
        self.finishBlock = nil;
    }
    
    if (self.parserDelegate && [self.parserDelegate respondsToSelector:@selector(httpRequest_ParserRequestFinished:resultData:status:error:)]) {
        
        [self.parserDelegate httpRequest_ParserRequestFinished:self.requestUrl
                                                    resultData:nil
                                                        status:Result_TimeOut
                                                         error:nil];
    }
}

#pragma mark -
#pragma mark 请求返回

- (void)requestFinished:(MKNetworkOperation *)request withResult:(NSString *)responseString {

    [self httpRequestSuccess:responseString];
    
}

- (void)requestFailed:(MKNetworkOperation *)request error:(NSError *) error {
    
    [self httpRequestFailed:request error:error];
    
}

- (void)requestTimeout:(MKNetworkOperation *)request {
    
    [self httpRequestTimeout:request];
    
}

#pragma mark -
#pragma mark ASIHTTPRequest UpLoadDelegate

- (void)uploadRequestFinished:(ASIHTTPRequest *)request {
    //NSString *unPackResponse = [HttpDataTool unzipDecodeData:[request responseData]];
    [self httpRequestSuccess:[request responseString]];
    [request clearDelegatesAndCancel];
    
}

- (void)uploadRequestFailed:(ASIHTTPRequest *)request
{
    [self httpRequestFailed:request error:request.error];
    [request clearDelegatesAndCancel];
    
}

#pragma mark -
#pragma mark ASIHTTPRequest DownLoadDelegate
- (void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders
{
    
    if ([responseHeaders objectForKey:@"Content-Length"])
    {
        double size = [[responseHeaders objectForKey:@"Content-Length"] doubleValue];
        _totleSize = size/1024.0/1024.0;
        
    }
    
}

//更新进度
- (void)setProgress:(float)newProgress
{
    float progress = newProgress *100;
    [self httpRequestProgress:progress];
    
}

//开始
- (void)requestStarted:(ASIHTTPRequest *)request
{
    [self httpRequestStart:request.userInfo];
    
}

//结束
- (void)requestFinished:(ASIHTTPRequest *)request
{
    [self httpRequestSuccess:request.userInfo];
    [request clearDelegatesAndCancel];
    
}


//错误
- (void)requestFailed:(ASIHTTPRequest *)request
{
    [self httpRequestFailed:request error:request.error];
    [request clearDelegatesAndCancel];
    
}

#pragma mark -
#pragma mark ASIHTTPRequest images DownLoadDelegate
- (void)downloadRequestFinished:(ASIHTTPRequest *)request
{
    [self httpRequestSuccess:request.userInfo];
    [request clearDelegatesAndCancel];
    
}

- (void)downloadRequestFailed:(ASIHTTPRequest *)request
{
    [self httpRequestFailed:request error:request.error];
    [request clearDelegatesAndCancel];
    
}

@end
