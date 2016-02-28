//
//  LKFriendLikeListViewPage.m
//  Luckeys
//
//  Created by 李锦华 on 15/10/17.
//  Copyright © 2015年 Luckeys. All rights reserved.
//

#import "LKFriendLikeListViewPage.h"
#import "LKFriendLikeCell.h"
#import "LKFriendLikeListModel.h"

@interface LKFriendLikeListViewPage ()<UITableViewDataSource,UITableViewDelegate,LKFriendLikeCellDelegate>
{
    UITableView *friendLikeTableView;
    NSString *_codeUuid;
    LKFriendLikeListModel *_friendLikeListModel;
}
@end

@implementation LKFriendLikeListViewPage

- (void)dealloc
{
    friendLikeTableView.delegate = nil;
    friendLikeTableView.dataSource = nil;
}

-(id)init
{
    if (self = [super init])
    {
        [self registController:@"LKFriendLikeListController"];
    }
    return self;
}

- (void)initWithParam:(NSDictionary *)paramInfo
{
    if (paramInfo.allKeys.count)
    {
        if ([paramInfo objectForKey:@"codeUuid"]) {
            _codeUuid = [paramInfo objectForKey:@"codeUuid"];
        }else{
            _codeUuid = @"";
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"赞我的朋友";
    
    _friendLikeListModel = [self.controller getModelFromListByName:@"LKFriendLikeListModel"];
    
    [self addTableView];
    [self.view setBackgroundColor:UIColorRGB(0xf0f0f0)];
    
    [ShowTipsView showLoadHUDWithMSG:nil andView:self.view];
    
    [self refreshData];
}

- (void)showPlaceholderView:(NSString *)showText boolWith:(BOOL)isBool
{
    if (isBool)
    {
        self.placeholderInfoView.hidden = NO;

        [self showPlaceholderViewState:showText];
        [friendLikeTableView addSubview:self.placeholderInfoView];
        [self adjustPlaceHolderFrame:NO];
    }
    else
    {
        self.placeholderInfoView.hidden = YES;
    }
}

-(void)handlerRightAction:(UIButton *)button{
    
}

-(void)addTableView{
    friendLikeTableView=[[UITableView alloc] initWithFrame:CGRectMake(0,64, UI_IOS_WINDOW_WIDTH, UI_IOS_WINDOW_HEIGHT-64) style:UITableViewStylePlain];
    [friendLikeTableView setBackgroundColor:[UIColor clearColor]];
    friendLikeTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    friendLikeTableView.delegate=self;
    friendLikeTableView.dataSource=self;
    [self.view addSubview:friendLikeTableView];
    
    [self addRefreshViewToTableView:friendLikeTableView];
    [self addLoadMoreCellToTableView:friendLikeTableView];
}

//刷新
- (void)refreshDatasource
{
    [super refreshDatasource];
    
    [self refreshData];
}

- (void)refreshData
{
    NSDictionary * body = @{@"codeUuid":_codeUuid,@"pageSize":kLKPageSize,kLKCurPage:[NSString stringWithFormat:@"1"]};
    [self.controller sendMessageID:kRequstFriendLikeListTag messageInfo:@{kRequestUrl:kURL_QueryPraisePage, kRequestBody:body}];
}

//加载更多
-(void)loadMoreData{
    [super loadMoreData];
    [self requestCommentMore];
}

- (void)requestCommentMore
{
    NSDictionary * body = @{@"codeUuid":_codeUuid,kLKCurPage:[NSString stringWithFormat:@"%ld", (long)self.currentPage],@"pageSize":kLKPageSize};
    
    [self.controller sendMessageID:kRequstFriendLikeMoreTag messageInfo:@{kRequestUrl:kURL_QueryPraisePage, kRequestBody:body}];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (self.isLoading) {
        return [_friendLikeListModel.infoArray count]+1;
    }
    return _friendLikeListModel.infoArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  BoundsOfScale(72);
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isLoading && indexPath.row == _friendLikeListModel.infoArray.count)
    {
        [self.loadMoreCell startLoadMore];
        [self loadMoreData];
        return self.loadMoreCell;
    }
    static NSString * cellId = @"LKPersonPhotoCell";
    LKFriendLikeCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[LKFriendLikeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.delegate = self;
    [cell setContent:[_friendLikeListModel.infoArray objectAtIndex:indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.isLoading && indexPath.row == _friendLikeListModel.infoArray.count) {
        [self.loadMoreCell startLoadMore];
        [self loadMoreData];
    }
}

#pragma mark - LKFriendLikeCellDelegate
- (void)changeHeadBtnUpInside:(LKPersonLikeData *)likeData
{
    [self pushPageWithName:@"LKMyTabViewPage" withParams:@{@"uuid":STR_IS_NULL(likeData.userUuid)}];
}

#pragma mark - 数据
- (void)update:(id)data msgID:(int)msgid faildCode:(EDataStatusCode)errCode
{
    [ShowTipsView hideHUDWithView:self.view];
    
    [self stopRefreshData];
    
    if (errCode == eDataCodeSuccess) {
        if (msgid == kRequstFriendLikeListTag) {//评论刷新
            [self stopLoadMoreData:_friendLikeListModel.infoArray];
            [friendLikeTableView reloadData];
            [friendLikeTableView scrollRectToVisible:CGRectMake(0, 0, friendLikeTableView.width, friendLikeTableView.height) animated:YES];
            if (_friendLikeListModel.infoArray.count <= 0) {
                [self showPlaceholderView:@"还没有朋友给你点赞哦～" boolWith:YES];
            }else{
                [self showPlaceholderView:nil boolWith:NO];

            }
        }else if (msgid == kRequstFriendLikeMoreTag)//加载更多
        {
            if (_friendLikeListModel.loadMoreArray.count)
            {
                self.currentPage = 0;
            }
            [self stopLoadMoreData:_friendLikeListModel.infoArray];
            [friendLikeTableView reloadData];
        }
    }else{
        if (msgid == kRequstFriendLikeMoreTag)
        {
            [ShowTipsView showHUDWithMessage:kRequest_TimeOut andView:self.view];
            [self.loadMoreCell stopLoadMore];
        }
        else
        {
            [ShowTipsView showHUDWithMessage:kRequest_TimeOut andView:self.view];
            if (_friendLikeListModel.infoArray.count <= 0) {
                [self showPlaceholderView:@"网络异常获取数据失败" boolWith:YES];
            }
        }
    }
    
}

@end
