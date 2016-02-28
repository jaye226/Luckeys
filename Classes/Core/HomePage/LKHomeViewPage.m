//
//  LKHomeViewPage.m
//  Luckeys
//
//  Created by BearLi on 15/9/26.
//  Copyright © 2015年 Luckeys. All rights reserved.
//

#import "LKHomeViewPage.h"
#import "LKTypeListTableViewCell.h"
#import "LKHomeMsgModel.h"
#import "LKLoginViewPage.h"

#define kINSSearchBarAnimationStepDuration 0.25

@interface LKHomeViewPage ()<UITableViewDelegate,UITableViewDataSource,LKTypeListTableViewCellDelegate>

{
    PBTableView * _tableView;
    BOOL _isHideNav;
    NSInteger  _nextPage;
    NSArray * _dataArray;
    LKHomeMsgModel * _msgModel;
    UIView *_searchView;
    
    UIButton *_cityBtn;
}

@end

@implementation LKHomeViewPage

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self registController:@"LKHomePageMSGController"];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        //self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self hiddenNavgationView];
    
    [self initData];
    [self initView];
    [self setNavigation];

    [ShowTipsView showLoadHUDWithMSG:nil andView:self.view];
    [self startRequest];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeCityNotificationCenter) name:kNotiLKChangeCityNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeCityNotificationCenter) name:kNotiLKBettingSuccessNotification object:nil];
}

- (void)setNavigation
{
    [self setLeftBarButtonItemImage:[UIImage imageWithName:@"home_menu"] highlightImage:nil];
    //[self setRightBarButtonItemImage:[UIImage imageWithName:@"home_ location"] highlightImage:nil];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(10, 20, 30, 30);
    [leftButton setImage:[UIImage imageWithName:@"home_menu"] forState:UIControlStateNormal];
    [self.view addSubview:leftButton];
    [leftButton addTarget:self action:@selector(handlerLeftAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _searchView = [[UIView alloc] initWithFrame:CGRectMake(leftButton.maxX+15,25, 30, 30)];
    _searchView.centerY = leftButton.centerY;
    _searchView.backgroundColor = [UIColor whiteColor];
    _searchView.opaque = NO;
    _searchView.layer.masksToBounds = YES;
    _searchView.layer.cornerRadius = _searchView.height/2.0;
    _searchView.layer.borderWidth = 0.3;
    _searchView.layer.borderColor = UIColorRGBA(0x666666, 0.5).CGColor;
    _searchView.contentMode = UIViewContentModeRedraw;
    [self.view addSubview:_searchView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 16, 16)];
    imageView.center = CGPointMake(_searchView.width/2.0, _searchView.height/2.0);
    imageView.image = [UIImage imageNamed:@"ic_search"];
    imageView.tag = 10000;
    [_searchView addSubview:imageView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = _searchView.bounds;
    button.tag = 10001;
    button.hidden = YES;
    button.backgroundColor = [UIColor clearColor];
    [_searchView addSubview:button];
    [button addTarget:self action:@selector(searchButtonInside) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSearch)];
    [_searchView addGestureRecognizer:tap];
    
    _cityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _cityBtn.frame = CGRectMake(_searchView.maxX+15, 20, 30, 30);
    [_cityBtn setImage:[UIImage imageWithName:@"home_ location"] forState:UIControlStateNormal];
    [self.view addSubview:_cityBtn];
    [_cityBtn addTarget:self action:@selector(handlerCityAction:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)searchButtonInside
{
    [self pushPageWithName:@"LKSearchViewPage" animation:YES];
}

- (void)tapSearch
{
    //[self showSearchBar];
    [self pushPageWithName:@"LKSearchViewPage" animation:YES];
}


- (void)showSearchBar
{
    
    if (_searchView == nil)
    {
        return;
    }
    [UIView animateWithDuration:kINSSearchBarAnimationStepDuration animations:^{
        _searchView.width = self.view.frame.size.width-_searchView.x*2.0;
        _cityBtn.x = _searchView.maxX+15;
        UIImageView *imageView = (UIImageView *)[_searchView viewWithTag:10000];
        UIButton *button = (UIButton *)[_searchView viewWithTag:10001];
        button.hidden = NO;
        button.frame = _searchView.frame;
        imageView.x = _searchView.width - imageView.width - 10;
    } completion:nil];
}

- (void)handlerCityAction:(UIButton *)button
{
    [self pushPageWithName:@"LKCityViewPage" animation:YES];
}

- (void)hideSearchBar
{
    if (_searchView == nil)
    {
        return;
    }
    [UIView animateWithDuration:kINSSearchBarAnimationStepDuration animations:^{
        _searchView.width = _searchView.height;
        _cityBtn.frame = CGRectMake(_searchView.maxX+15, 20, 30, 30);
        UIImageView *imageView = (UIImageView *)[_searchView viewWithTag:10000];
        UIButton *button = (UIButton *)[_searchView viewWithTag:10001];
        button.hidden = YES;
        button.frame = _searchView.frame;
        imageView.center = CGPointMake(_searchView.width/2.0, _searchView.height/2.0);
    } completion:nil];
}

- (void)initData {
    _msgModel = [self.controller getModelFromListByName:NSStringFromClass([LKHomeMsgModel class])];
}

- (void)initView {
    _tableView = [[PBTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height-49) style:UITableViewStylePlain];
    _tableView.contentInset = UIEdgeInsetsMake(-20, 0, -49, 0);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    [self addRefreshViewToTableView:_tableView];
    [self addLoadMoreCellToTableView:_tableView];
}

- (void)showPlaceholderView:(NSString *)showText boolWith:(BOOL)isBool
{
    if (isBool)
    {
        self.placeholderInfoView.hidden = NO;
        
        [self showPlaceholderViewState:showText];
        [_tableView addSubview:self.placeholderInfoView];
        [self adjustPlaceHolderFrame:NO];
    }
    else
    {
        self.placeholderInfoView.hidden = YES;
    }
}

- (void)handlerLeftAction:(UIButton *)button
{
    [kShareSlider showLeftController];
}

//切换城市
- (void)changeCityNotificationCenter
{
    [ShowTipsView showLoadHUDWithMSG:nil andView:self.view];
    [self startRequest];
}

- (void) startRequest {
    if (self.isRefreshing)
    {
        _msgModel.nextPage = 1;
    }
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *cityString = [userDefaults objectForKey:kChangeCityKey];
    if (cityString.length <= 0)
    {
        NSDictionary * body = @{kLKCurPage:[NSNumber numberWithInteger:_msgModel.nextPage],@"pageSize":kLKPageSize};
        [self.controller sendMessageID:1111 messageInfo:@{kRequestUrl:kURL_HomePageData,kRequestBody:body}];
    }else
    {
        NSDictionary * body = @{kLKCurPage:[NSNumber numberWithInteger:_msgModel.nextPage],@"pageSize":kLKPageSize,@"cityName":cityString};
        [self.controller sendMessageID:1111 messageInfo:@{kRequestUrl:kURL_HomePageData,kRequestBody:body}];
    }
    
}

//加载更多
-(void)loadMoreData{
    [super loadMoreData];
    [self requestCommentMore];
}

- (void)requestCommentMore
{
    _msgModel.nextPage = self.currentPage;

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *cityString = [userDefaults objectForKey:kChangeCityKey];
    if (cityString.length <= 0)
    {
        NSDictionary * body = @{kLKCurPage:[NSNumber numberWithInteger:_msgModel.nextPage],@"pageSize":kLKPageSize};
        [self.controller sendMessageID:3333 messageInfo:@{kRequestUrl:kURL_HomePageData,kRequestBody:body}];
    }else
    {
        NSDictionary * body = @{kLKCurPage:[NSNumber numberWithInteger:_msgModel.nextPage],@"pageSize":kLKPageSize,@"cityName":cityString};
        [self.controller sendMessageID:3333 messageInfo:@{kRequestUrl:kURL_HomePageData,kRequestBody:body}];
    }
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _tableView) {

        CGFloat offset=scrollView.contentOffset.y;
        if (offset <= 0) {
            [self hideSearchBar];
        }else{
            [self showSearchBar];
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isLoading) {
        return [_dataArray count]+1;
    }
    return [_dataArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isLoading && indexPath.row == _dataArray.count) {
        return [LKLoadMoreCell getCellHeight];
    }
    return kTypeListCellHeight;
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isLoading && indexPath.row == _dataArray.count)
    {
        [self.loadMoreCell startLoadMore];
        [self loadMoreData];
        return self.loadMoreCell;
    }
    static NSString * cellId = @"TypeListCellId";
    LKTypeListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[LKTypeListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.delegate = self;
    cell.likeImage.tag = 9999+indexPath.row;
    cell.typeButton.tag = indexPath.row;
    cell.typeData = _dataArray[indexPath.row];
    //cell.likeImage.y = kTypeLikeButtonY+BoundsOfScale(10);
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row >= _dataArray.count) {
        return;
    }
    
    if (self.isLoading && indexPath.row == _dataArray.count) {
        [self.loadMoreCell startLoadMore];
        [self loadMoreData];
    }
    
    LKTypeData *data = _dataArray[indexPath.row];
    
    [self pushPageWithName:@"LKDetailsViewPage" animation:YES withParams:@{@"activityUuid":STR_IS_NULL(data.activityUuid),@"title":STR_IS_NULL(data.activityName)}];
}

- (void)likeButtonClick:(UIButton *)button
{
    if (![LKShareUserInfo share].isLogin)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您还没有登录，请先登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
        return;
    }
    NSInteger index = button.tag - 9999;
    if (index < 0 || index >= _dataArray.count) {
        return;
    }
    
    LKTypeData * data = _dataArray[index];
    NSString * iLike = @"";
    if ([data.iLike boolValue] == YES) {
        iLike = @"1";
    }
    else
    {
        iLike = @"0";
    }
    id body = @{@"activityUuid":STR_IS_NULL(data.activityUuid),@"iLike":iLike};
    [self.controller sendMessageID:2222 messageInfo:@{kRequestUrl:kURL_CollectionActivity,kRequestBody:body}];
}


- (void)typeButtonClick:(UIButton*)button
{
    if (button.tag >= _dataArray.count) {
        [self pushPageWithName:@"LKTypeListViewPage" withParams:nil];
    }
    else {
         LKTypeData * data = _dataArray[button.tag];
        [self pushPageWithName:@"LKTypeListViewPage" withParams:@{@"uuid":STR_IS_NULL(data.activityTypeUuid),@"title":STR_IS_NULL(data.activityTypeName)}];
    }
}


- (void)refreshDatasource {
    [super refreshDatasource];
    [self startRequest];
}

- (void)update:(id)data msgID:(int)msgid faildCode:(EDataStatusCode)errCode {

    [ShowTipsView hideHUDWithView:self.view];
    [self stopRefreshData];

    if (errCode == eDataCodeSuccess) {
        if (msgid == 1111) {
            LKHomeMsgModel * model = data;
            _dataArray = model.dataArray;
            [self stopLoadMoreData:_dataArray];
            if (_dataArray.count <= 0) {
                [self showPlaceholderView:@"暂无数据" boolWith:YES];
            }else{
                [self showPlaceholderView:@"" boolWith:NO];
            }
            
            [_tableView reloadData];
        }
        else if (msgid == 2222) {
            NSString * uuid = data;
            for (LKTypeData * data in _dataArray) {
                if ([data.activityUuid isEqualToString:uuid]) {
                    NSInteger index = [_dataArray indexOfObject:data];
                    LKTypeListTableViewCell * cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
                    if ([data.iLike boolValue]) {
                        data.iLike = @"0";
                    }
                    else
                    {
                        data.iLike = @"1";
                    }
                    [cell resetLikeImage:data];
                    
                    break;
                }
            }
        }else if (msgid == 3333){
            LKHomeMsgModel * model = data;
            _dataArray = model.dataArray;
            if (_dataArray.count)
            {
                self.currentPage = 0;
            }
            [self stopLoadMoreData:_dataArray];
            [_tableView reloadData];
        }
    }
    else {
        if (msgid == 1111) {
            if (_dataArray.count <= 0) {
                [self showPlaceholderView:@"网络异常获取数据失败" boolWith:YES];
            }
        }else if (msgid == 3333){
            [self.loadMoreCell stopLoadMore];
        }
        [ShowTipsView showHUDWithMessage:kRequest_TimeOut andView:self.view];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        LKLoginViewPage *loginVC = [[LKLoginViewPage alloc] init];
        loginVC.isGVC = YES;
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:loginVC animated:YES];
    }
}


@end
