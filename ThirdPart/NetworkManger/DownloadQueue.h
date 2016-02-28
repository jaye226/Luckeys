//
//  DownloadQueue.h
//  MLPlayer
//
//  Created by lilixiong on 14/11/4.
//  Copyright (c) 2014年 w. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"

@interface DownloadQueue : ASINetworkQueue
<ASIHTTPRequestDelegate,ASIProgressDelegate,NSURLConnectionDataDelegate,NSURLConnectionDelegate>
@property (nonatomic) int count;
@property (nonatomic,assign) double totleSize;
@property (nonatomic,assign) float downloadSize;
@property (nonatomic,strong) NSString *trackFrom;
+ (id)shareDownloadQueue;

//- (void)downloadWithInfo:(DownloadInfo *)info;

@end