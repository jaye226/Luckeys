//
//  LKBaseViewPage.h
//  Luckeys
//
//  Created by BearLi on 15/10/2.
//  Copyright © 2015年 Luckeys. All rights reserved.
//

#import "UIBaseViewPage.h"
#import "EGORefreshTableHeaderView.h"
#import "LKLoadMoreCell.h"

@interface LKBaseViewPage : UIBaseViewPage

@property (nonatomic,assign) BOOL isRefreshing;

@property(nonatomic,assign) BOOL isLoading;

@property(nonatomic,assign) NSInteger currentPage;

@property (nonatomic,strong) EGORefreshTableHeaderView * refreshView;

@property (nonatomic,strong) LKLoadMoreCell *loadMoreCell;

@property (nonatomic, strong) UIView *placeholderInfoView;

@property (nonatomic, strong) LKNavigationView *navigationView;

/**
 *  隐藏自定义导航栏 
 */
- (void)hiddenNavgationView;

- (void)showPlaceholderViewState:(NSString *)showString;

- (void)adjustPlaceHolderFrame:(BOOL)isLow;

- (void)addRefreshViewToTableView:(UITableView *)parentView;

- (void)addLoadMoreCellToTableView:(UITableView*)parentView;

/**
 *  刷新数据,子类实现
 */
- (void)refreshDatasource;

/**
 *  刷新结束调用,也可子类实现
 */
- (void)stopRefreshData;

/**
 *  下拉加载数据
 */
-(void)loadMoreData;

/**
 *  加载结束调用
 *
 *  @param dataArr 加载回调数据
 */
-(void)stopLoadMoreData:(NSArray*)dataArr;

@end
