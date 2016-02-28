//
//  MLHttpRequestManager.m
//  MLPlayer
//
//  Created by robin on 15/6/2.
//  Copyright (c) 2015年 w. All rights reserved.
//

#import "MLHttpRequestManager.h"
#import "HttpRequest_Parser.h"

static MLHttpRequestManager *httpRequestManager = nil;
@interface MLHttpRequestManager()<HttpRequest_Parser_Delegate> {
    NSMutableArray *requestArray;
}

@end

@implementation MLHttpRequestManager
@synthesize networkQueue;

#pragma mark -
#pragma mark Singleton Methods
+ (id)sharedMLHttpRequestManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        httpRequestManager = [[MLHttpRequestManager alloc] init];
    });
    
    return httpRequestManager;
}

- (id)init {
    if (self = [super init]) {
        requestArray = [[NSMutableArray alloc]init];
        networkQueue = [[ASINetworkQueue alloc] init];
        [networkQueue setMaxConcurrentOperationCount:5];
        [networkQueue setShouldCancelAllRequestsOnFailure:NO];
        [networkQueue go];
    }
    return self;
}


- (void)sendHttpRequestWithTag:(int)tag
                     URLString:(NSString *)URLString
                   requestType:(Request_TYPE)type
                    bodyString:(id)body
                    jsCallBack:(NSString *)jsString
                      Finished:(void (^)(Result_TYPE success,int requestTag, id callbackData))finishBlock {
    if (requestArray && requestArray.count > 0) {
        [self cancelHttpRequestWithUrl:URLString andTag:tag];
    }
   
    HttpRequest_Parser *parser = [[HttpRequest_Parser alloc]initWithTag:(int)tag
                                                              URLString:URLString
                                                            requestType:type
                                                             bodyString:body
                                                             jsCallBack:jsString
                                                            andCallBack:self
                                                               Finished:finishBlock];
    [requestArray addObject:parser];
}

- (void)uploadRequestWithTag:(int)tag
                   URLString:(NSString *)URLString
                 requestType:(Request_TYPE)type
                  uploadData:(id)aImage
                    Finished:(void (^)(Result_TYPE success,int requestTag, id callbackData))finishBlock {
    
    HttpRequest_Parser *parser = [[HttpRequest_Parser alloc]initWithTag:(int)tag
                                                              URLString:URLString
                                                            requestType:type
                                                             uploadData:aImage
                                                            andCallBack:self
                                                               Finished:finishBlock];
    
    [requestArray addObject:parser];
}

- (void)downloadRequestWithTag:(int)tag
                     URLString:(NSString *)URLString
                   requestType:(Request_TYPE)type
                   requestInfo:(NSDictionary *)requestInfo
                       Started:(void (^)(NSDictionary *))startBlock
                      Progress:(void (^)(float newProgress))progressBlock
                      Finished:(void (^)(Result_TYPE success,int requestTag, id callbackData))finishBlock  {
    
    HttpRequest_Parser *parser = [[HttpRequest_Parser alloc]initWithTag:(int)tag
                                                              URLString:(NSString *)URLString
                                                            requestType:type
                                                            requestInfo:requestInfo
                                                            andCallBack:self
                                                                Started:startBlock
                                                               Progress:progressBlock
                                                               Finished:finishBlock];
    
    [requestArray addObject:parser];
}

- (void)downloadRequestWithTag:(int)tag
                     URLString:(NSString *)URLString
                   requestType:(Request_TYPE)type
                   requestInfo:(NSDictionary *)requestInfo
                      Finished:(void (^)(Result_TYPE success,int requestTag, id callbackData))finishBlock {
    
    HttpRequest_Parser *parser = [[HttpRequest_Parser alloc]initWithTag:tag
                                                              URLString:URLString
                                                            requestType:type
                                                            requestInfo:requestInfo
                                                            andCallBack:self
                                                               Finished:finishBlock];
    
    [requestArray addObject:parser];
}

- (void)cancelHttpRequestWithUrl:(NSString *)url andTag:(NSInteger)tag {
    if (requestArray && requestArray.count > 1) {
        for (NSInteger i = requestArray.count;i>0;i--) {
            HttpRequest_Parser *parser = requestArray[i-1];
            if ([parser.requestUrl isEqualToString:url] && tag == parser.requestTag) {
                [requestArray removeObject:parser];
            }
        }
    }
    
    NSLog(@"http cancel requestUrl:%@;",url);

}

- (void)removeAllHttpRequest {
    if (requestArray && requestArray.count > 0) {
        [requestArray removeAllObjects];
    }
}

#pragma mark - 
#pragma mark HttpRequest_Parser_Delegate
- (void)httpRequest_ParserRequestFinished:(NSString *)url
                               resultData:(id)resultDict
                                   status:(Result_TYPE)statu
                                    error:(NSError *)error {
    switch (statu) {
        case Result_Fail:
            NSLog(@"http request failed requestUrl:%@ | Error:%@",url,error.domain);
            break;
        case Result_Success:
            NSLog(@"http request successed requestUrl:%@",url);
            break;
        case Result_TimeOut:
            NSLog(@"http request timeout requestUrl:%@",url);
            break;
            
        default:
            break;
    }

}
@end
