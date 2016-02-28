//
//  DownloadQueue.m
//  MLPlayer
//
//  Created by lilixiong on 14/11/4.
//  Copyright (c) 2014年 w. All rights reserved.
//

#import "DownloadQueue.h"

#define MAXQueue 1

static DownloadQueue * queue = nil;


@implementation DownloadQueue

+ (id)shareDownloadQueue
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (queue == nil) {
            queue = [[DownloadQueue alloc] init];
            [queue setShouldCancelAllRequestsOnFailure:NO];
            [queue setMaxConcurrentOperationCount:MAXQueue];
            [queue go];
        }
        
    });
    return queue;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self setMaxConcurrentOperationCount:MAXQueue];
        self.showAccurateProgress = YES;
        [self setShouldCancelAllRequestsOnFailure:NO];
    
    }
    return self;
}

@end
