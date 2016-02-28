//
//  UITableView+LoadFooter.m
//  TestLoadMoreFooter
//
//  Created by BearLi on 15/11/18.
//  Copyright © 2015年 llx. All rights reserved.
//

#import "UITableView+LoadFooter.h"
#import <objc/runtime.h>

@implementation UITableView (LoadFooter)

static const char  kLoadMoreFooterKey = '\0';

- (void)setLoadMoreView:(PBLoadMoreFooterView *)loadMoreView {
    if (loadMoreView && self.loadMoreView != loadMoreView) {
        
        [self.loadMoreView removeFromSuperview];
        [self addSubview:loadMoreView];
        
        [self willChangeValueForKey:@"loadMoreView"];
        objc_setAssociatedObject(self, &kLoadMoreFooterKey,loadMoreView, OBJC_ASSOCIATION_ASSIGN);
        [self didChangeValueForKey:@"loadMoreView"];
    }
}

- (PBLoadMoreFooterView*)loadMoreView {
    return objc_getAssociatedObject(self, &kLoadMoreFooterKey);;
}

- (void)endLoadMoreData {
    [self.loadMoreView endLoadMoreData];
}

- (void)noMoreData {
    [self.loadMoreView noMoreData];
}
@end

