//
//  LKTypeListViewPage.m
//  Luckeys
//
//  Created by BearLi on 15/9/29.
//  Copyright © 2015年 Luckeys. All rights reserved.
//

#import "LKTypeListViewPage.h"
#import "LKTypeListTableViewCell.h"
#import "LKTypeListMsgModel.h"
#import "LKLoginViewPage.h"

@interface LKTypeListViewPage ()<UITableViewDelegate,UITableViewDataSource,LKTypeListTableViewCellDelegate>
{
    
    PBTableView * _tableView;
    NSMutableArray * _dataArray;
    UIView * _headView;
    NSMutableArray * _buttons;
    UIButton * _currentButton;
    LKTypeListMsgModel * _model;
    NSString *_orderBy;
}

@end

@implementation LKTypeListViewPage


- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self registController:@"LKTypeListMsgController"];
    }
    return self;
}

- (void)initWithParam:(NSDictionary *)paramInfo
{
    if (paramInfo.allKeys.count > 0) {
        _activeUuid = paramInfo[@"uuid"];
        _typeName = paramInfo[@"title"];
        
        if ([_activeUuid integerValue] >= 0 && [_activeUuid integerValue] <= 4)
        {
            _orderBy = @"6";
        }else{
            _orderBy = @"";
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    if (_typeName.length == 0) {
        _typeName = @"分类";
    }
    
    self.title = _typeName;
    if (_activeUuid.length == 0) {
        _activeUuid = @"";
    }
    _model = [self.controller getModelFromListByName:@"LKTypeListMsgModel"];
    
    [self createView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSuccessNotificationCenter) name:kNotiLKBettingSuccessNotification object:nil];
    
    [ShowTipsView showLoadHUDWithMSG:nil andView:self.view];
    [self startRequest];
}

- (void)changeSuccessNotificationCenter
{
    [ShowTipsView showLoadHUDWithMSG:nil andView:self.view];
    [self startRequest];
}

- (void)createView
{
    _headView = [[UIView alloc] initWithFrame:CGRectMake(0,64, self.view.width, BoundsOfScale(45))];
    _headView.backgroundColor = UIColorRGB(0xf0f0f0);
    [self.view addSubview:_headView];
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 4, _headView.width, _headView.height-4)];
    view.backgroundColor = [UIColor whiteColor];
    [_headView addSubview:view];
    
    NSInteger count = 4;
    CGFloat width = (view.width - (count-1)*0.5)/4.0;
    CGFloat height = view.height;
    CGFloat imageEdgeBottom = BoundsOfScale(7.5);
    CGFloat imageEdgeRight = BoundsOfScale(8);
    _buttons = [NSMutableArray arrayWithCapacity:count];
    NSArray * array = @[@"进度",@"热度",@"时间",@"金额"];
    for (int i = 0; i < count; i ++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i*(width+0.5), 0, width, height);
        [button setTitle:array[i] forState:UIControlStateNormal];
        [button setTitleColor:UIColorRGB(0x666666) forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:FontOfScale(14)];
        if (i == 0) {
            [button setImage:[UIImage imageWithName:@"type_right_on"] forState:UIControlStateNormal];
            _currentButton = button;
        }
        else
        {
            [button setImage:[UIImage imageWithName:@"type_right_normal"] forState:UIControlStateNormal];
        }
        button.imageEdgeInsets = UIEdgeInsetsMake(button.height-7-imageEdgeBottom, button.width-7-imageEdgeRight, imageEdgeBottom, imageEdgeRight);
        [button addTarget:self action:@selector(handleHeadButton:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
        button.tag = 200 +i;
        
        if (i < count-1) {
            UIView * line = [[UIView alloc] initWithFrame:CGRectMake(button.maxX, 0, 0.5, BoundsOfScale(27))];
            line.centerY = view.height/2.0;
            line.backgroundColor = UIColorRGB(0xdbdbdb);
            [view addSubview:line];
        }
        [_buttons addObject:button];
    }
    
    _tableView = [[PBTableView alloc] initWithFrame:CGRectMake(0, _headView.maxY, self.view.width, self.view.height-_headView.maxY) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
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


- (void)startRequest {
    NSDictionary * body = @{@"activityTypeUuid":_activeUuid,
                            @"orderBy":_orderBy.length>0?_orderBy:@"",
                            kLKCurPage:[NSNumber numberWithInteger:_model.nextPage],
                            @"pageSize":kLKPageSize};
    [self.controller sendMessageID:111 messageInfo:@{kRequestUrl:KURL_TypeList,kRequestBody:body}];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _model.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kTypeListCellHeight;
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellId = @"TypeListCellId";
    LKTypeListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[LKTypeListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.typeButton.hidden = YES;
    }
    cell.likeImage.tag = 9999+indexPath.row;
    cell.delegate = self;
    cell.typeData = _model.dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LKTypeData *data = _model.dataArray[indexPath.row];
    [self pushPageWithName:@"LKDetailsViewPage" animation:YES withParams:@{@"activityUuid":STR_IS_NULL(data.activityUuid),@"title":STR_IS_NULL(data.activityName)}];
}


- (void)handleHeadButton:(UIButton*)button
{
    if (_currentButton != button) {
        [button setImage:[UIImage imageWithName:@"type_right_on"] forState:UIControlStateNormal];
        [_currentButton setImage:[UIImage imageWithName:@"type_right_normal"] forState:UIControlStateNormal];
        _currentButton = button;
        
        if ([_activeUuid integerValue] >= 0 && [_activeUuid integerValue] <= 4)
        {
            switch (button.tag-200) {
                case 0:
                    _orderBy = @"6";
                    break;
                case 1:
                    _orderBy = @"7";
                    break;
                case 2:
                    _orderBy = @"8";
                    break;
                case 3:
                    _orderBy = @"9";
                    break;
                default:
                    break;
            }
        }else{
            switch (button.tag-200) {
                case 0:
                    _activeUuid = @"6";
                    break;
                case 1:
                    _activeUuid = @"7";
                    break;
                case 2:
                    _activeUuid = @"8";
                    break;
                case 3:
                    _activeUuid = @"9";
                    break;
                default:
                    break;
            }
            _orderBy = @"";
        }
        
        [_tableView setContentOffset:CGPointMake(0, 0) animated:NO];
        
        _model.nextPage = 1;
        [ShowTipsView showLoadHUDWithMSG:nil andView:self.view];

        [self startRequest];
    }
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
    if (index < 0 || index >= _model.dataArray.count) {
        return;
    }
    
    LKTypeData * data = _model.dataArray[index];
    NSString * iLike = @"";
    if ([data.iLike boolValue] == YES) {
        iLike = @"1";
    }
    else
    {
        iLike = @"0";
    }
    id body = @{@"activityUuid":STR_IS_NULL(data.activityUuid),@"iLike":iLike};
    [self.controller sendMessageID:kLikeTag messageInfo:@{kRequestUrl:kURL_CollectionActivity,kRequestBody:body}];
}


- (void)update:(id)data msgID:(int)msgid faildCode:(EDataStatusCode)errCode {
    [ShowTipsView hideHUDWithView:self.view];
    if (errCode == eDataCodeSuccess) {
            if (msgid == kLikeTag)
            {
                NSString * uuid = data;
                for (LKTypeData * data in _model.dataArray) {
                    if ([data.activityUuid isEqualToString:uuid]) {
                        NSInteger index = [_model.dataArray indexOfObject:data];
                        
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
            else
            {
                if ([data isKindOfClass:[LKTypeListMsgModel class]])
                {
                    _model = data;
                if (_model.dataArray.count > 0)
                {
                    [self showPlaceholderView:@"" boolWith:NO];
                }else{
                    [self showPlaceholderView:@"暂无相关信息" boolWith:YES];
                }
                [_tableView reloadData];

            }
            
        }
        
    }
    else {
        if (_model.dataArray.count > 0) {
            [ShowTipsView showHUDWithMessage:@"网络异常获取数据失败" andView:self.view];
        }else{
            [self showPlaceholderView:@"暂无相关信息" boolWith:YES];
        }
    }
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
