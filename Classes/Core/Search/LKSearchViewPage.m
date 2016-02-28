//
//  LKSearchViewPage.m
//  Luckeys
//
//  Created by 李锦华 on 15/11/15.
//  Copyright © 2015年 Luckeys. All rights reserved.
//

#import "LKSearchViewPage.h"
#import "LKSearchHistoryView.h"
#import "LKSearchAssociateView.h"
#import "LKSearchData.h"
#import "LKHomeMsgModel.h"
#import "LKLoginViewPage.h"

@implementation LKSearchViewPage{
    
    UITableView *_tableView;
    UITextField *_textField;
    UIButton *_searchBtn;
    
    BOOL _firstInto;
    
    NSInteger  _nextPage;
    NSArray * _dataArray;
    LKHomeMsgModel * _msgModel;
    
    LKSearchHistoryView   *_historyView;   //历史搜索记录显示
    
    NSMutableArray *_historyArray;      //历史搜索记录array
}

- (void)dealloc
{
    _textField.delegate = nil;
    _historyView.selectSearchdelegate=nil;
    _historyView.deleteHistoryDelegate=nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self registController:@"LKSearchController"];
    }
    return self;
}

- (void)initWithParam:(NSDictionary *)paramInfo
{
    if (paramInfo.allKeys.count) {

    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   // self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (_firstInto) {
        [_textField becomeFirstResponder];
    }
    _firstInto = NO;
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_textField resignFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavItem];
    [self initData];
    [self initView];
    [self addHistoryAndAssociateView];
}

//添加导航栏按钮
- (void)addNavItem
{
    UIView *titleView = [self addInputView];
    titleView.x = (self.navigationView.width-titleView.width)/2;
    [self.navigationView addSubview:titleView];
    [self.navigationView addRightButtonTitleWith:@"搜索" titleColorWith:[UIColor redColor] selectdColorWith:UIColorRGB(0xf5c3B1) fontWith:[UIFont systemFontOfSize:BoundsOfScale(15)]];
    
//    self.navigationItem.titleView = titleView;
//    UIBarButtonItem * titleItem = [[UIBarButtonItem alloc] initWithCustomView:titleView];
    
    //添加rightBarButtonItem
//    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,0, 44, 44)];
//    [rightBtn setTitle:@"搜索" forState:UIControlStateNormal];
//    [rightBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//    [rightBtn setTitleColor:UIColorRGB(0xf5c3B1) forState:UIControlStateHighlighted];
//    [rightBtn.titleLabel setFont:[UIFont systemFontOfSize:17]];
//    rightBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
//    [self.view addSubview:rightBtn];
//    [rightBtn addTarget:self action:@selector(rightClickAction) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
////    self.navigationItem.rightBarButtonItem = barItem;
//    self.navigationItem.rightBarButtonItems = @[barItem,titleItem];

}

//-(void)leftClickAction
//{
//    [self.navigationController popViewControllerAnimated:NO];
//}

- (void)changeNavRightBtnInside
{
    
    if ([_textField isFirstResponder])
    {
        [_textField resignFirstResponder];
    }
    
    [self beginSearch:_textField.text];
    [self sendRequestWithTitle:_textField.text];
}


-(UIView *)addInputView
{
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 26, self.view.width - 2*44 -2*20, 30)];
    textField.font = [UIFont systemFontOfSize:16];
    textField.layer.borderWidth=0.3;
    textField.layer.cornerRadius = textField.height/2.0;
    textField.layer.borderColor=UIColorRGBA(0x666666, 0.5).CGColor;
    textField.placeholder = @"输入喜欢的活动";
    textField.textColor = UIColorRGB(0x666666);
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.returnKeyType = UIReturnKeySearch;
    if (kIOSVersions >= 7.0) {
        textField.tintColor = UIColorRGB(0xf5c3B1);
    }
    [textField  setValue:UIColorRGBA(0x333333, 0.5) forKeyPath:@"_placeholderLabel.textColor"];
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 27, textField.frame.size.height)];
    leftView.backgroundColor = [UIColor clearColor];
    textField.leftViewMode = UITextFieldViewModeAlways;
    
    UIImageView *searchImageView = [[UIImageView alloc] init];
    [searchImageView setImage:[UIImage imageWithName:@"ic_search"]];
    searchImageView.frame = CGRectMake(10, 0, 15, 15);
    searchImageView.centerY = leftView.height/2.0;
    [leftView addSubview:searchImageView];
    textField.leftView=leftView;
    
    _textField = textField;
    _textField.leftViewMode = UITextFieldViewModeAlways;
    _textField.delegate  = self;
    [_textField addTarget:self action:@selector(editingChanged:) forControlEvents:UIControlEventEditingChanged];
    return _textField;
}


- (void)initData
{
    _firstInto = YES;
    _historyArray=[[NSMutableArray alloc] initWithCapacity:0];
}

- (void)initView
{
    self.view.backgroundColor = [UIColor whiteColor];
    _tableView = [[PBTableView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, UI_IOS_WINDOW_HEIGHT-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    [self addRefreshViewToTableView:_tableView];
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

/**
 *  add历史记录和联想词条显示
 */
-(void)addHistoryAndAssociateView{
    _historyView=[[LKSearchHistoryView alloc] initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-64)];
    [_historyView setBackgroundColor:[UIColor clearColor]];
    _historyView.selectSearchdelegate=self;
    _historyView.deleteHistoryDelegate=self;
    _historyView.hiddenKeyBoardDelegete=self;
    [self.view addSubview:_historyView];
    
    [_historyArray removeAllObjects];
    [LKDBManager getAllSearchHistoryWithType:0 handle:^(NSArray *array) {
        if(array){
            [_historyArray addObjectsFromArray:array];
        }
        [_historyView refreshTable:_historyArray];
    }];
    
}


#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.1 animations:^{
        
        _searchBtn.frame = CGRectMake(10, 8, 15, 15);
    }];
    
    NSString *resultingString = [_textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if(resultingString.length==0){
        [self showHistoryView];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if(textField.text.length==0){
        [self showHistoryView];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([_textField isFirstResponder]) {
        [_textField resignFirstResponder];
    }
    [self sendRequestWithTitle:_textField.text];
    [self beginSearch:_textField.text];
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    [self showHistoryView];
    return YES;
}


//中文输入相应
- (void)editingChanged:(id)sender{
    NSString *resultingString = [_textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if(resultingString.length==0){
        [self showHistoryView];
    }
}

/*
 * 根据标题发送请求
 */
-(void)sendRequestWithTitle:(NSString *)title
{
    [self hiddenHistoryAndAssociateView];
    //self.placeholderInfoView.hidden = YES;
    [self requesSearchData];
}


-(NSString *)getTitle{
    //    去除两端空格
    NSString *temp = [_textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    //    去除两端空格和回车
    NSString *result = [temp stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet ]];
    if([result isEqualToString:@""] || result == nil) return nil;
    NSString *searchName = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)result ,NULL ,CFSTR("!*'();:@&=+$,/?%#[]") ,kCFStringEncodingUTF8));
    return searchName;
}


- (void) requesSearchData {
    [self.view endEditing:YES];
    if (self.isRefreshing) {
        _msgModel.nextPage = 1;
    }
    if (_textField.text.length <= 0) {
        [ShowTipsView showHUDWithMessage:@"搜索内容不能为空" andView:self.view];
        return;
    }
    
    [ShowTipsView showLoadHUDWithMSG:@"" andView:self.view];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *cityString = [userDefaults objectForKey:kChangeCityKey];
    if (cityString.length <= 0)
    {
        NSDictionary * body = @{kLKCurPage:[NSString stringWithFormat:@"1"],@"pageSize":kLKPageSize,@"activityName":STR_IS_NULL(_textField.text)};
        [self.controller sendMessageID:1111 messageInfo:@{kRequestUrl:kURL_HomePageData,kRequestBody:body}];
    }else
    {
        NSDictionary * body = @{kLKCurPage:[NSString stringWithFormat:@"1"],@"pageSize":kLKPageSize,@"activityName":STR_IS_NULL(_textField.text),@"cityName":cityString};
        [self.controller sendMessageID:1111 messageInfo:@{kRequestUrl:kURL_HomePageData,kRequestBody:body}];
    }
}


#pragma mark - TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return BoundsOfScale(270);
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
    if([_textField isFirstResponder]){
        [_textField resignFirstResponder];
    }
    if (indexPath.row >= _dataArray.count) {
        return;
    }
    
    LKTypeData *data = _dataArray[indexPath.row];
    
    [self pushPageWithName:@"LKDetailsViewPage" animation:YES withParams:@{@"activityUuid":STR_IS_NULL(data.activityUuid),@"title":STR_IS_NULL(data.activityName)}];
}

- (void)refreshDatasource {
    [super refreshDatasource];
    [self requesSearchData];
}

/**
 *  显示历史搜索记录
 */
-(void)showHistoryView{
    [self.view bringSubviewToFront:_historyView];
    _historyView.hidden=NO;
}

/**
 *  隐藏历史搜索列表和联想列表
 */
-(void)hiddenHistoryAndAssociateView{
    _historyView.hidden=YES;
}

/**
 *  搜索某一字段，数据更新和写入操作
 *
 *  @param searchKey 搜索的词条
 */
-(void)beginSearch:(NSString*)searchKey{
    
    NSString *searchStr=[self getTitle];
    if(searchStr&&searchStr.length!=0){
        [LKDBManager deleteRecordWithSearchKey:searchStr];
        //存储搜索数据
        LKSearchData *data=[[LKSearchData alloc] init];
        data.searchKey=searchStr;
        data.umId=[LKShareUserInfo share].userInfo.userUuid;
        data.searchDate=[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
        [LKDBManager updateModel:data];
        //更新搜索列表
        [LKDBManager getAllSearchHistoryWithType:0 handle:^(NSArray *array) {
            [_historyArray removeAllObjects];
            if(array){
                [_historyArray addObjectsFromArray:array];
            }
            [_historyView refreshTable:_historyArray];
        }];
    }
}

#pragma mark
/**
 *  SelectSearchHistoryDelegate
 */
-(void)selectSearchHistory:(LKSearchData*)data{
    if ([_textField isFirstResponder]) {
        [_textField resignFirstResponder];
    }
    //[data deleteObject];
    _textField.text=[data.searchKey stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self beginSearch:_textField.text];
    [self sendRequestWithTitle:_textField.text];
}

#pragma mark
/**
 *  DeleteHistoryDelegate
 *
 *  @param data 删除的数据
 */
-(void)deleteSearchHistory:(LKSearchData *)data{
    if(!data){
        //删除所有数据
        [_historyArray removeAllObjects];
        [_historyView refreshTable:_historyArray];
        [LKDBManager deleteSearchHistory:nil handle:^(BOOL success) {
            if(success){
                
            }
        }];
    }else{
        //删除某条数据
        [_historyArray removeObject:data];
        [_historyView refreshTable:_historyArray];
        [LKDBManager deleteSearchHistory:data handle:^(BOOL success) {
            if(success){
                
            }
        }];
    }
}

#pragma mark
/**
 *  HiddenKeyBoardDelegete
 */
-(void)hiddenKeyBoard{
    if ([_textField isFirstResponder]) {
        [_textField resignFirstResponder];
    }
}

#pragma mark
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

#pragma mark - Request Delegate
- (void)update:(id)data msgID:(int)msgid faildCode:(EDataStatusCode)errCode
{
    [ShowTipsView hideHUDWithView:self.view];
    [self stopRefreshData];
    
    if (errCode == eDataCodeSuccess) {
        if (msgid == 1111) {
            LKHomeMsgModel * model = data;
            _dataArray = model.dataArray;
            [_tableView reloadData];
            if (_dataArray.count <= 0)
            {
                [self showPlaceholderView:@"没有相关信息哦～" boolWith:YES];
            }
            else
            {
                [self showPlaceholderView:@"" boolWith:NO];
            }
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
        }
    }
    else {
        if (msgid == 1111) {
            if (_dataArray.count <= 0)
            {
                [self showPlaceholderView:@"网络异常获取数据失败" boolWith:YES];
            }
            
        }
        [ShowTipsView showHUDWithMessage:kRequest_TimeOut andView:self.view];
    }
}

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
