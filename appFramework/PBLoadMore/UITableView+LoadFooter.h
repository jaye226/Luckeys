//
//  UITableView+LoadFooter.h
//  TestLoadMoreFooter
//
//  Created by BearLi on 15/11/18.
//  Copyright © 2015年 llx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBLoadMoreFooterView.h"

@interface UITableView (LoadFooter)

@property (nonatomic, strong) PBLoadMoreFooterView * loadMoreView;

/**
 *  加载结束后调用
 */
- (void)endLoadMoreData;


- (void)noMoreData;

@end
