//
//  LKBaseViewPage.m
//  Luckeys
//
//  Created by BearLi on 15/10/2.
//  Copyright © 2015年 Luckeys. All rights reserved.
//

#import "LKBaseViewPage.h"
#import "LKLoadMoreCell.h"

@interface LKBaseViewPage ()<EGORefreshTableHeaderDelegate,UIScrollViewDelegate,LKNavigationViewDelegate>
{
    UILabel *_placeholderLabel;
    UIView *_placeholderInfoView;
    UIImageView *_placeholderimage;
    UILabel *_secondPlaceholderLabel;
    NSString * _newTitle;       //防止title为空,赋新值

}

@property (nonatomic,weak) UITableView * tableView;

@end

@implementation LKBaseViewPage

@synthesize placeholderInfoView = _placeholderInfoView;
@synthesize navigationView = _navigationView;

- (void)dealloc
{
    if (_tableView) {
        [_tableView removeObserver:self forKeyPath:kKeyPathContentOffSet];
    }
    _refreshView.delegate = nil;

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    if (self.title)
    {
        [_navigationView setNavigationTitle:self.title titleColor:nil titleFont:nil];
    }
    else
    {
        [_navigationView setNavigationTitle:_newTitle titleColor:nil titleFont:nil];
    }
    
    [self.view bringSubviewToFront:_navigationView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.currentPage = 1;
    
    self.navigationController.navigationBarHidden = YES;
    
    _navigationView = [[LKNavigationView alloc] initWithFrame:CGRectMake(0, 0, UI_IOS_WINDOW_WIDTH, UI_NavView_height)];
    [self.view addSubview:_navigationView];
    
    if (self.navigationController.viewControllers.count > 1) {
        [_navigationView addLeftButtonImageWith:@"nav_back" selectdWith:@"nav_back_pressed"];
        //[UIImage imageWithName:@"nav_back"] highlightImage:[UIImage imageWithName:@"nav_back_pressed"]
    }
    _navigationView.delegate = self;
    [self.view addSubview:_navigationView];
    
//    if (self.navigationController.viewControllers.count > 1) {
//        [self setLeftItem];
//    }
    
    [self addShowPlaceholderView];
}

- (void)setTitle:(NSString *)title
{
    [super setTitle:title];
    if (_navigationView) {
        [_navigationView setNavigationTitle:title titleColor:nil titleFont:nil];
    }
    else
    {
        _newTitle = title;
    }
}

- (void)hiddenNavgationView
{
    _navigationView.hidden = YES;
}

- (void)addShowPlaceholderView
{
    _placeholderInfoView = [[UIView alloc] initWithFrame:self.view.bounds];
    _placeholderInfoView.userInteractionEnabled = NO;

    UIImage * image = [UIImage imageWithName:@"placeholderimage"];
    _placeholderimage = [[UIImageView alloc] initWithFrame:CGRectMake((UI_IOS_WINDOW_WIDTH - image.size.width)/2, 140, image.size.width, image.size.height)];

    [_placeholderimage setImage:image];
    _placeholderimage.contentMode = UIViewContentModeScaleAspectFill;
    [_placeholderInfoView addSubview:_placeholderimage];
    
    _placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, _placeholderimage.frame.origin.y + CGRectGetMidY(_placeholderimage.bounds)+image.size.height/2.0+20, UI_IOS_WINDOW_WIDTH - 40, 40)];
    _placeholderLabel.textColor = UIColorRGB(0x999999);
    _placeholderLabel.backgroundColor = [UIColor clearColor];
    _placeholderLabel.font = [UIFont systemFontOfSize:16];
    _placeholderLabel.textAlignment = NSTextAlignmentCenter;
    
    
    [_placeholderInfoView addSubview:_placeholderLabel];
    
    CGRect frames = _placeholderLabel.frame;
    frames.origin.y += 20;
    frames.size.height = 20;
    
    _secondPlaceholderLabel = [[UILabel alloc]initWithFrame:frames];
    _secondPlaceholderLabel.textColor = UIColorRGB(0x999999);;
    _secondPlaceholderLabel.backgroundColor = [UIColor clearColor];
    _secondPlaceholderLabel.font = [UIFont systemFontOfSize:13];
    _secondPlaceholderLabel.textAlignment = NSTextAlignmentCenter;
    [_placeholderInfoView addSubview:_secondPlaceholderLabel];
    
    [self.view addSubview:_placeholderInfoView];
    _placeholderInfoView.hidden = YES;
}

- (void)showPlaceholderViewState:(NSString *)showString{
    _placeholderInfoView.hidden = NO;
    [self.view bringSubviewToFront:_placeholderInfoView];
    _placeholderLabel.text = showString;
}

- (void)adjustPlaceHolderFrame:(BOOL)isLow{
    int offY = 0;
    if (UI_IOS_WINDOW_HEIGHT < 500) {
        offY = 25;
    }
    if (isLow) {
        _placeholderimage.frame = CGRectMake((UI_IOS_WINDOW_WIDTH - 100)/2, (UI_IOS_WINDOW_HEIGHT - 310)/2 + 120 + offY, 100, 100);
    }else{
        _placeholderimage.frame = CGRectMake((UI_IOS_WINDOW_WIDTH - 100)/2, (UI_IOS_WINDOW_HEIGHT-310)/2, 100, 100);
    }
    _placeholderLabel.frame = CGRectMake(20, _placeholderimage.frame.origin.y + CGRectGetMidY(_placeholderimage.bounds)+_placeholderimage.image.size.height/2.0, UI_IOS_WINDOW_WIDTH - 40, 40);
    CGRect frames = _secondPlaceholderLabel.frame;
    frames.origin.y = CGRectGetMaxY(_placeholderLabel.frame);
    _secondPlaceholderLabel.frame = frames;
}

- (void)setLeftItem
{
    [self setLeftBarButtonItemImage:[UIImage imageWithName:@"nav_back"] highlightImage:[UIImage imageWithName:@"nav_back_pressed"]];
}

- (void)handlerLeftAction:(UIButton *)button
{
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (void)addRefreshViewToTableView:(UITableView *)parentView {
    if (!parentView) {
        return;
    }
    
    if (!_refreshView) {
        _refreshView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, -CGRectGetHeight(parentView.bounds), CGRectGetWidth(parentView.bounds), CGRectGetHeight(parentView.bounds))];
        _refreshView.delegate = self;
        [_refreshView refreshLastUpdatedDate];
    }
    [_refreshView removeFromSuperview];
    [parentView addSubview:_refreshView];
    if (_tableView) {
        [_tableView removeObserver:self forKeyPath:kKeyPathContentOffSet];
        _tableView = nil;
    }
    _tableView = parentView;
    NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
    [_tableView addObserver:self forKeyPath:kKeyPathContentOffSet options:options context:NULL];
    
}

- (void)addLoadMoreCellToTableView:(UITableView*)parentView{
    if (!parentView) {
        return;
    }
    if (_loadMoreCell == nil) {
        _loadMoreCell = [[LKLoadMoreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LoadMoreCell"];
        _loadMoreCell.contentView.backgroundColor = [UIColor clearColor];
        _loadMoreCell.backgroundColor = [UIColor clearColor];
    }
    _currentPage = 1;
    _isLoading = NO;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:kKeyPathContentOffSet]) {
        [self egoRefreshViewDidScroll:_tableView];
    }
}

- (void)egoRefreshViewDidScroll:(UIScrollView*)scrollView {
    if (_tableView && scrollView == _tableView) {
        [_refreshView egoRefreshScrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (_tableView && scrollView == _tableView) {
        [_refreshView egoRefreshScrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    if (_tableView && scrollView == _tableView) {
        [_refreshView egoRefreshScrollViewDidEndDragging:scrollView];
    }
}

#pragma mark - LKNavigationViewDelegate
- (void)changeNavLeftBtnInside
{
    if (self.navigationController.viewControllers.count > 1) {
        [self popViewPageAnimated:YES];
    }
}

- (void)changeNavRightBtnInside
{
    
}

#pragma mark - EGO RefreshView
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
    [self refreshDatasource];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
    return _isRefreshing;
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
    return [NSDate date];
}

//子类实现
- (void)refreshDatasource {
    self.isRefreshing = YES;
    _isLoading=NO;
    _currentPage=1;
}

- (void)stopRefreshData {
    if (self.isRefreshing) {
       self.isRefreshing = NO;
    }
}

- (void)setIsRefreshing:(BOOL)isRefreshing
{
    _isRefreshing = isRefreshing;
    if (_isRefreshing == NO) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [_refreshView egoRefreshScrollViewDataSourceDidFinishedLoading:_tableView];
        });
    }
}

/**
 *  下拉加载数据
 */
-(void)loadMoreData{
    _isLoading=YES;
    if(_isRefreshing){
        _isRefreshing=NO;
    }
}

/**
 *  加载结束调用
 *
 *  @param dataArr 加载回调数据
 */
-(void)stopLoadMoreData:(NSArray*)dataArr{
    if (_currentPage == 0)
    {
        _isLoading = NO;
        return;
    }
    
    if (_currentPage*[kLKPageSize intValue] > dataArr.count)
    {
        _currentPage = 0;
        _isLoading = NO;
        return;
    }
    
    NSInteger index = [dataArr count]%[kLKPageSize integerValue];
    if (index)
    {
        _isLoading = NO;
    }
    else
    {
        _currentPage = ([dataArr count]/[kLKPageSize integerValue])+1;
        _isLoading = YES;
    }
}
@end
