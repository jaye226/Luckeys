//
//  LKCommentViewPage.m
//  Luckeys
//
//  Created by lishaowei on 15/10/12.
//  Copyright © 2015年 Luckeys. All rights reserved.
//

#import "LKCommentViewPage.h"
#import "LKCommentCell.h"
#import "KKCommentView.h"
#import "LKCommentModel.h"
#import "LKLoginViewPage.h"

@interface LKCommentViewPage () <UITableViewDelegate, UITableViewDataSource, KKCommentViewDelegate, LKCommentCellDelegate>
{
    UITableView *_tableView;
    KKCommentView *_commentView;
    NSString *_activityUuid;
    LKCommentModel *_commentModel;
}

@end

@implementation LKCommentViewPage

- (void)dealloc
{
    _tableView.delegate = nil;
    _tableView.dataSource = nil;
}

-(id)init
{
    if (self = [super init])
    {
        [self registController:@"LKCommentController"];
    }
    return self;
}

- (void)initWithParam:(NSDictionary *)paramInfo
{
    if (paramInfo.allKeys.count)
    {
        if ([paramInfo objectForKey:@"title"]) {
            //self.title = [paramInfo objectForKey:@"title"];
        }else{
            //self.title = @"详情";
        }
        _activityUuid = [paramInfo objectForKey:@"activityUuid"];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"评论";
    
    self.currentPage = 1;
    
    _commentModel = [self.controller getModelFromListByName:@"LKCommentModel"];
    
    [self addView];
    
    [ShowTipsView showLoadHUDWithMSG:nil andView:self.view];
    
    [self refreshData];
}

- (void)addView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, UI_IOS_WINDOW_WIDTH, UI_IOS_WINDOW_HEIGHT-64-BoundsOfScale(40)) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    _commentView = [[KKCommentView alloc] initWithFrame:CGRectMake(0, _tableView.maxY, UI_IOS_WINDOW_WIDTH, BoundsOfScale(40))];
    _commentView.delegate = self;
    [self.view addSubview:_commentView];
    
    [self addRefreshViewToTableView:_tableView];
    [self addLoadMoreCellToTableView:_tableView];
}

//刷新
- (void)refreshDatasource
{
    [super refreshDatasource];
    
    [self refreshData];
}

- (void)refreshData
{
    NSDictionary * body = @{@"activityUuid":_activityUuid,@"pageSize":kLKPageSize,kLKCurPage:[NSString stringWithFormat:@"1"]};
    [self.controller sendMessageID:kRequstCommentListTag messageInfo:@{kRequestUrl:kURL_CommentPage, kRequestBody:body}];
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

//加载更多
-(void)loadMoreData{
    [super loadMoreData];
    [self requestCommentMore];
}

- (void)requestCommentMore
{
    NSDictionary * body = @{@"activityUuid":_activityUuid,@"userUuid":[[[LKShareUserInfo share] userInfo] userUuid],kLKCurPage:[NSString stringWithFormat:@"%ld", (long)self.currentPage],@"pageSize":kLKPageSize};
    
    [self.controller sendMessageID:kRequstCommentMoreTag messageInfo:@{kRequestUrl:kURL_CommentPage, kRequestBody:body}];
}

//有用
- (void)requstCommentUseful:(NSString *)commentUuid
{
    if (![LKShareUserInfo share].isLogin)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您还没有登录，请先登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
        return;
    }
    [ShowTipsView showLoadHUDWithMSG:nil andView:self.view];

    NSDictionary * body = @{@"commentUuid":commentUuid};
    [self.controller sendMessageID:kRequstCommentUsefulTag messageInfo:@{kRequestUrl:kURL_AddUse, kRequestBody:body}];
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

#pragma mark - KKCommentViewDelegate
- (void)sendChange:(NSString *)sendString
{
    if (![LKShareUserInfo share].isLogin)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您还没有登录，请先登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
        return;
    }
    
    //    去除两端空格
    NSString *temp = [sendString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    //    去除两端空格和回车
    NSString *result = [temp stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if([result isEqualToString:@""] || result == nil)
    {
        [ShowTipsView showHUDWithMessage:@"评论内容不能为空" andView:self.view];
        return;
    }
    [ShowTipsView showLoadHUDWithMSG:nil andView:self.view];

    NSDictionary * body = @{@"activityUuid":_activityUuid,@"userUuid":[LKShareUserInfo share].userInfo.userUuid,@"description":sendString};
    [self.controller sendMessageID:kRequstCommentTag messageInfo:@{kRequestUrl:kURL_AddComment, kRequestBody:body}];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isLoading) {
        return [_commentModel.infoArray count]+1;
    }
    return [_commentModel.infoArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.isLoading && indexPath.row == _commentModel.infoArray.count)
    {
        [self.loadMoreCell startLoadMore];
        [self loadMoreData];
        return self.loadMoreCell;
    }
    static NSString *cellId = @"CommentId";
    LKCommentCell *comment = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (comment == nil)
    {
        comment = [[LKCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        comment.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    comment.delegate = self;
    [comment updateWithData:[_commentModel.infoArray objectAtIndex:indexPath.row]];
    return comment;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isLoading && indexPath.row == _commentModel.infoArray.count) {
        return [LKLoadMoreCell getCellHeight];
    }
    return [LKCommentCell getCellHeight:[_commentModel.infoArray objectAtIndex:indexPath.row]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.isLoading && indexPath.row == _commentModel.infoArray.count) {
        [self.loadMoreCell startLoadMore];
        [self loadMoreData];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_commentView hiddenKeyboard];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        LKLoginViewPage *loginVC = [[LKLoginViewPage alloc] init];
        loginVC.isGVC = YES;
        [self.navigationController pushViewController:loginVC animated:YES];
    }
}


#pragma mark - LKCommentCellDelegate
- (void)changeLikeBtn:(LKCommentData *)commentData
{
    [self requstCommentUseful:commentData.commentUuid];
}
//点击头像
- (void)changeHeadBtn:(LKCommentData *)commentData
{
    [self pushPageWithName:@"LKMyTabViewPage" withParams:@{@"uuid":STR_IS_NULL(commentData.userUuid)}];
}

#pragma mark - 数据
- (void)update:(id)data msgID:(int)msgid faildCode:(EDataStatusCode)errCode
{
    [ShowTipsView hideHUDWithView:self.view];
    
    [self stopRefreshData];

    if (errCode == eDataCodeSuccess) {
        if (msgid == kRequstCommentListTag) {//评论刷新
            [self stopLoadMoreData:_commentModel.infoArray];
            [_tableView reloadData];
            [_tableView scrollRectToVisible:CGRectMake(0, 0, _tableView.width, _tableView.height) animated:YES];
            if (_commentModel.infoArray.count <= 0) {
                [self showPlaceholderView:@"还没有评论哦，快来抢沙发吧～" boolWith:YES];
            }else{
                [self showPlaceholderView:@"" boolWith:NO];
            }
        }else if (msgid == kRequstCommentMoreTag)//加载更多
        {
            if (_commentModel.loadMoreArray.count)
            {
                self.currentPage = 0;
            }
            [self stopLoadMoreData:_commentModel.infoArray];
            [_tableView reloadData];
        }else if (msgid == kRequstCommentTag)//评论
        {
            [ShowTipsView showLoadHUDWithMSG:nil andView:self.view];
            [self refreshData];
        }else if (msgid == kRequstCommentUsefulTag) //是否有用
        {
            [_tableView reloadData];
        }
    }else{
        if (msgid == kRequstCommentListTag)
        {
            if (_commentModel.infoArray.count <= 0)
            {
                [self showPlaceholderView:@"网络异常获取数据失败" boolWith:YES];
                [ShowTipsView showHUDWithMessage:kRequest_TimeOut andView:self.view];
            }
        }
        else if (msgid == kRequstCommentTag)//评论
        {
            [ShowTipsView showHUDWithMessage:@"评论失败" andView:self.view];
        }
        else if (msgid == kRequstCommentMoreTag)
        {
            [ShowTipsView showHUDWithMessage:kRequest_TimeOut andView:self.view];
            [self.loadMoreCell stopLoadMore];
        }
        else
        {
            [ShowTipsView showHUDWithMessage:kRequest_TimeOut andView:self.view];
        }
    }
    
}


@end
