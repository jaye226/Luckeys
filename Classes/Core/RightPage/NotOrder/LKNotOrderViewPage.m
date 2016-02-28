//
//  LKNotOrderViewPage.m
//  Luckeys
//
//  Created by lishaowei on 16/1/17.
//  Copyright © 2016年 Luckeys. All rights reserved.
//

#import "LKNotOrderViewPage.h"
#import "LKNotOrderModel.h"
#import "LKNotOrderCell.h"

@interface LKNotOrderViewPage ()
{
    LKNotOrderModel *_orderModel;
}

@end

@implementation LKNotOrderViewPage

-(void)dealloc{
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
}

-(id)init
{
    if (self = [super init])
    {
        [self registController:@"LKNotOrderController"];//注册控制器
    }
    return self;
}

- (void)initWithParam:(NSDictionary *)paramInfo
{
    if (paramInfo.allKeys.count)
    {
    }
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title=@"未完成订单";
    
    _orderModel = [self.controller getModelFromListByName:@"LKNotOrderModel"];

    self.enablePullToRefresh = YES;
    [self triggerPullToRefresh];
}

/**
 *  下拉刷新
 */
- (void)pullToRefreshDidTrigger
{
    NSDictionary *body = @{@"userUuid":[[LKShareUserInfo share] userInfo].userUuid};
    NSDictionary *dic=@{kRequestUrl:kUrl_QueryOrderList,kRequestBody:body};
    
    [self.controller sendMessageID:kRefreshTag messageInfo:dic];
}

- (void)showPlaceholderView:(NSString *)showText boolWith:(BOOL)isBool
{
    if (isBool)
    {
        self.placeholderInfoView.hidden = NO;
        
        [self showPlaceholderViewState:showText];
        [self.tableView addSubview:self.placeholderInfoView];
        [self adjustPlaceHolderFrame:NO];
    }
    else
    {
        self.placeholderInfoView.hidden = YES;
    }
}

/**
 *  加载更多
 */
- (void)pullToLoadMoreDidTrigger
{

}

#pragma mark - UITableViewDataSource,UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _orderModel.list.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return BoundsOfScale(80);
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellId = @"PersonImageCell";
    LKNotOrderCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (cell == nil)
    {
        cell = [[LKNotOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    [cell updateWithData:[_orderModel.list objectAtIndex:indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row < _orderModel.list.count)
    {
        LKNotOrderData *data = [_orderModel.list objectAtIndex:indexPath.row];
        [self pushPageWithName:@"LKOrderPayViewPage" animation:YES withParams:@{@"data":data,@"name":data.activityName}];
    }
}

/**
 *  数据返回
 */
- (void)update:(id)data msgID:(int)msgid faildCode:(EDataStatusCode)errCode
{
    if (errCode == eDataCodeSuccess)
    {
        if (msgid == kRefreshTag)
        {
            [self pullToRefreshDidFinish];
            if (_orderModel.list.count == 0)
            {
                [self showPlaceholderView:@"您还没有订单信息哦" boolWith:YES];
            }
            else
            {
                [self showPlaceholderView:@"" boolWith:NO];
            }
        }
        else
        {
            [self pullToLoadMoreDidFinish];
        }
        [self.tableView reloadData];
    }
    else
    {
        if (msgid == kRefreshTag)
        {
            [self pullToRefreshDidFinish];
            [self showPlaceholderView:@"网络异常获取数据失败" boolWith:YES];
        }
        else
        {
            [self pullToLoadMoreDidFinish];
            [ShowTipsView showHUDWithMessage:@"" andView:self.view];
        }
    }
}

@end
