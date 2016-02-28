//
//  LKTableViewPage.m
//  Luckeys
//
//  Created by lishaowei on 15/12/29.
//  Copyright © 2015年 Luckeys. All rights reserved.
//

#import "LKTableViewPage.h"
#import "EGORefreshTableHeaderView.h"
#import "PBLoadMoreFooterView.h"

#define kIOS7OffHeight (kIOSVersions>=7.0 ? 64 : 0)

@interface LKTableViewPage ()

@property (nonatomic, readwrite) UITableView *tableView;

@property (nonatomic, assign) BOOL isObserving;
//@property (nonatomic, strong) EGORefreshTableHeaderView *refreshView;
@property (nonatomic, weak) PBLoadMoreFooterView *loadMoreView;

@property (nonatomic, assign) BOOL refreshing;
@property (nonatomic, assign) BOOL loadingMore;

@end

@implementation LKTableViewPage

- (void)loadView
{
    [super loadView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createTableView];
    [self addRefreshHeaderView:self.enablePullToRefresh];
}

- (void)createTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kIOS7OffHeight, UI_IOS_WINDOW_WIDTH,UI_IOS_WINDOW_HEIGHT - kIOS7OffHeight)];
    tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorColor = [UIColor clearColor];
    tableView.tableFooterView = [UIView new];
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

#pragma mark 下拉刷新
- (void)setEnablePullToRefresh:(BOOL)enable
{
    _enablePullToRefresh = enable;
    [self addRefreshHeaderView:enable];
}

- (void)addHeaderView
{
    if (self.refreshView == nil) {
        EGORefreshTableHeaderView *refreshView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - _tableView.bounds.size.height,
                                                                                                             _tableView.frame.size.width, _tableView.bounds.size.height)];
        refreshView.delegate = (id <EGORefreshTableHeaderDelegate>)self;
        [_tableView addSubview:refreshView];
        self.refreshView = refreshView;
    }
}

- (void)registerKeyPath
{
    if (self.isObserving == NO && self.tableView) {
        [self.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
        self.isObserving = YES;
    }
}

- (void)unregisterKeyPath
{
    if (self.isObserving) {
        [self.tableView removeObserver:self forKeyPath:@"contentOffset" context:nil];
        self.isObserving = NO;
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if([keyPath isEqualToString:@"contentOffset"]) {
        
        //        NSLog(@"self.refreshView.state = %d", self.refreshView.state);
        //        NSLog(@"change = %@", change);
        
        if (self.refreshView.state == EGOOPullRefreshPulling && self.tableView.isDragging == NO) {
            [self.refreshView egoRefreshScrollViewDidEndDragging:self.tableView];
        } else {
            [self.refreshView egoRefreshScrollViewDidScroll:self.tableView];
        }
        
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
    
}

- (void)pullToRefreshDidTrigger
{
}

- (void)triggerPullToRefresh
{
    self.refreshing = YES;
    [self.refreshView showLoading:self.tableView];
    [self pullToRefreshDidTrigger];
}

- (void)pullToRefreshDidFinish
{
    self.refreshing = NO;
    [self.refreshView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
    
    self.enablePullToLoadMore = (self.tableView.contentSize.height > 0);
}

- (void)addRefreshHeaderView:(BOOL)enable
{
    if (enable) {
        if ([self isViewLoaded]) {
            [self addHeaderView];
            [self registerKeyPath];
        }
    } else {
        [self.refreshView removeFromSuperview];
        self.refreshView = nil;
        [self unregisterKeyPath];
    }
}

#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view
{
    self.refreshing = YES;
    [self pullToRefreshDidTrigger];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView *)view
{
    return self.refreshing;
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView *)view
{
    return [NSDate date];
}


#pragma mark 上拉加载

- (void)pullToLoadMoreDidTrigger
{
    
}

- (void)triggerPullToLoadMore
{
    
}

- (void)pullToLoadMoreDidFinish
{
    [self.loadMoreView endLoadMoreData];
}

- (void)setEnablePullToLoadMore:(BOOL)enable
{
    _enablePullToLoadMore = enable;
    if (enable) {
        if ([self isViewLoaded]) {
            [self importLoadMoreView];
        }
    } else {
        [self.loadMoreView noMoreData];
    }
    self.loadMoreView.hidden = !enable;
}

- (void)importLoadMoreView
{
    if (self.loadMoreView) return;
    
    __weak __typeof(self)weakSelf = self;
    PBLoadMoreFooterView *footer = [PBLoadMoreFooterView loadMoreViewWithBlock:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf pullToLoadMoreDidTrigger];
    }];
    footer.loadStatus = PBLoadMoreStatusNormal;
    [self.tableView addSubview:footer];
    self.loadMoreView = footer;
}


//子类覆盖实现
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

//子类覆盖实现
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *const identifier = @"_base";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [self unregisterKeyPath];
    NSLog(@"%@ %@", NSStringFromClass(self.class), NSStringFromSelector(_cmd));
}

@end
