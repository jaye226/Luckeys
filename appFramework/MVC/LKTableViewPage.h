//
//  LKTableViewPage.h
//  Luckeys
//
//  Created by lishaowei on 15/12/29.
//  Copyright © 2015年 Luckeys. All rights reserved.
//

#import "LKBaseViewPage.h"

@interface LKTableViewPage : LKBaseViewPage <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, readonly) UITableView  *tableView;

/*
 *是否开启列表的下拉刷新,默认是NO
 */
@property (nonatomic, assign) BOOL enablePullToRefresh;

/*
 *是否开启列表的上拉加载,默认是NO
 */
@property (nonatomic, assign) BOOL enablePullToLoadMore;

/*
 *用户【下拉刷新】操作触发，子类重载方法
 */
- (void)pullToRefreshDidTrigger;

/*
 *触发自动【下拉刷新】，而且上面的pullToRefreshDidTrigger也会被调用
 */
- (void)triggerPullToRefresh;

/*
 *调用此方法让【下拉刷新】相关控件回复原来的状态
 */
- (void)pullToRefreshDidFinish;


/*
 *用户上拉【加载更多】操作触发，子类重载方法
 */
- (void)pullToLoadMoreDidTrigger;

///*
// *触发自动【加载更多】，而且上面的pullToLoadMoreDidTrigger也会被调用
// */
//- (void)triggerPullToLoadMore;

/*
 *调用此方法让【加载更多】相关控件回复到原来的状态
 */
- (void)pullToLoadMoreDidFinish;

@end
