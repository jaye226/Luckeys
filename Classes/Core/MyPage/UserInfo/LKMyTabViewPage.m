//
//  LKMyTabViewPage.m
//  Luckeys
//
//  Created by BearLi on 15/9/26.
//  Copyright © 2015年 Luckeys. All rights reserved.
//

#import "LKMyTabViewPage.h"
#import "LKBindingPhoneCell.h"
#import "LKRegisterInfoCell.h"
#import "LKPersonInfoData.h"
#import "LKPrizeCell.h"
#import "LKMyTabModel.h"
#import "LKLoginViewPage.h"

@interface LKMyTabViewPage () <UITableViewDelegate,UITableViewDataSource,LKPrizeCellDelegate>
{
    NSArray *dataArr;
    NSString *_uuid;
    LKMyTabModel *_model;
    BOOL _isMyBool;
}
@end

@implementation LKMyTabViewPage

-(void)dealloc{
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
}

-(id)init
{
    if (self = [super init])
    {
        [self registController:@"LKMyTabViewController"];//注册控制器
    }
    return self;
}

- (void)initWithParam:(NSDictionary *)paramInfo
{
    if (paramInfo.allKeys.count)
    {
        _uuid = STR_IS_NULL(paramInfo[@"uuid"]);
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIColor createLongImageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"个人资料";
    
    self.tableView.hidden = YES;
    
    if ([[[LKShareUserInfo share] userInfo].userUuid isEqualToString:_uuid])
    {
        _isMyBool = YES;
    }else{
        _isMyBool = NO;
    }
    
    if(_isMyBool)
    {
        [self.navigationView addRightButtonImageWith:EditeNormalImage selectdWith:EditeHighLightImage];
    }
    
    [self getPersonInfo];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeUserInfoNotificationCenter:) name:kNotiChangeUserInfo object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeHeadImageNotificationCenter:) name:kNotiChangeHeadImage object:nil];
}

- (void)changeNavRightBtnInside
{
    [self pushPageWithName:@"LKEditePersonDataViewPage" animation:YES];
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

- (void)changeHeadImageNotificationCenter:(NSNotification *)notification
{
    [self getPersonInfo];
}

- (void)changeUserInfoNotificationCenter:(NSNotification *)notification
{
   [self getPersonInfo];
}

//获取中奖信息
-(void)getPrizeRequest{
    
    [ShowTipsView showLoadHUDWithMSG:nil andView:self.view];
    
    _model.curPage = 1;
    
    NSDictionary *body = nil;
    if (!_isMyBool)
    {
        body = @{@"userUuid":STR_IS_NULL(_uuid),@"seeUserUuid":STR_IS_NULL(_uuid),kLKCurPage:[NSString stringWithFormat:@"%ld", (long)_model.curPage],@"pageSize":kPageCoutTag};
    }else
    {
        body = @{@"userUuid":[[LKShareUserInfo share] userInfo].userUuid,@"seeUserUuid":STR_IS_NULL(_uuid),kLKCurPage:[NSString stringWithFormat:@"%ld", (long)_model.curPage],@"pageSize":kPageCoutTag};
    }
    
    NSDictionary *dic=@{kRequestUrl:kURL_GetPrize,kRequestBody:body};
    
    [self.controller sendMessageID:10010 messageInfo:dic];
}

- (void)pullToLoadMoreDidTrigger
{
    [self getLoadMorePrizeRequest];
}

//加载更多中奖信息
-(void)getLoadMorePrizeRequest{
    NSDictionary *body = nil;
    if (!_isMyBool)
    {
        body = @{@"userUuid":STR_IS_NULL(_uuid),@"seeUserUuid":STR_IS_NULL(_uuid),kLKCurPage:[NSString stringWithFormat:@"%ld", (long)_model.curPage],@"pageSize":kPageCoutTag};
    }else
    {
        body = @{@"userUuid":[[LKShareUserInfo share] userInfo].userUuid,@"seeUserUuid":STR_IS_NULL(_uuid),kLKCurPage:[NSString stringWithFormat:@"%ld", (long)_model.curPage],@"pageSize":kPageCoutTag};
    }
    NSDictionary *dic=@{kRequestUrl:kURL_GetPrize,kRequestBody:body};
    
    [self.controller sendMessageID:kLoadMoreTag messageInfo:dic];
}

//获取个人信息
-(void)getPersonInfo{
    [ShowTipsView showLoadHUDWithMSG:nil andView:self.view];
    
    NSDictionary *dic=@{kRequestUrl:kURL_UserInfo,kRequestBody:STR_IS_NULL(_uuid)};
    
    [self.controller sendMessageID:10011 messageInfo:dic];
}

-(void)addTableView
{
    self.tableView.frame = CGRectMake(0, 64, UI_IOS_WINDOW_WIDTH, UI_IOS_WINDOW_HEIGHT-64);
}

#pragma mark - UITableViewDataSource
//上提回弹，下拉取消回弹
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.tableView.contentOffset.y <= 0)
    {
        [self.tableView setContentOffset:CGPointMake(0, 0) animated:NO];
    }
    else
    {
        self.tableView.bounces = YES;
    }
}
#pragma mark - UITableViewDelegate、UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==0){
        return 3;
    }else{
        return [dataArr count];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section==0){
        return 0;
    }else{
        return 40;
    }
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section==0){
        return nil;
    }else{
        UIView *headView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, UI_IOS_WINDOW_WIDTH, 40)];
        headView.backgroundColor=[UIColor whiteColor];
        UILabel* countLabel=[[UILabel alloc] initWithFrame:CGRectMake(18, 0, 100, 40)];
        countLabel.backgroundColor=[UIColor clearColor];
        countLabel.font=[UIFont systemFontOfSize:14];
        countLabel.textColor=UIColorRGB(kContentColor_nine);
        if (_model.userData.winSum.length <= 0 || [_model.userData.winSum integerValue] == 0) {
            countLabel.text=@"暂无中奖信息";
        }else{
            countLabel.text=[NSString stringWithFormat:@"%@次中奖",_model.userData.winSum];
        }
        [headView addSubview:countLabel];
        return headView;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0){
        if(indexPath.row==0){
            return UI_IOS_WINDOW_WIDTH;
        }else if (indexPath.row==1){
            return BoundsOfScale(115);
        }else{
            return BoundsOfScale(70);
        }
    }
   else{
        return BoundsOfScale(80);
    };
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0){
        if(indexPath.row==0){
            static NSString * cellId = @"PersonImageCell";
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            UIImageView *personImageView=(UIImageView*)[cell.contentView viewWithTag:299];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
                personImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, UI_IOS_WINDOW_WIDTH, UI_IOS_WINDOW_WIDTH)];
                [personImageView setContentMode:UIViewContentModeScaleAspectFill];
                personImageView.clipsToBounds = YES;
                personImageView.userInteractionEnabled=YES;
                personImageView.tag=299;
                [cell.contentView addSubview:personImageView];
            }
            NSString *backImage = [NSString stringWithFormat:@"http://%@%@",SeverHost,_model.userData.userHead];
            [personImageView sd_setImageWithURL:[NSURL URLWithString:backImage] placeholderImage:[UIImage imageNamed:@"moren"]];
            return cell;
        }else if(indexPath.row==1){
            static NSString * cellId = @"RegisterInfoCell";
            LKRegisterInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (!cell) {
                cell = [[LKRegisterInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            }
            [cell setViewsFrame:_model.userData];
            return cell;
        }else{
            static NSString * cellId = @"BindingPhoneCell";
            LKBindingPhoneCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (!cell) {
                cell = [[LKBindingPhoneCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            }
            
            [cell setViewsFrame:_model.userData.userPhone boolWith:_isMyBool];
            return cell;
        }
    }
    else{
        static NSString * cellId = @"LKPrizeCell";
        LKPrizeCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[LKPrizeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        cell.delegate = self;
        [cell setViewsFrame:[dataArr objectAtIndex:indexPath.row]];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.section != 0)
    {
        LKTypeData *prizeData = [dataArr objectAtIndex:indexPath.row];
        [self pushPageWithName:@"LKFriendLikeListViewPage" animation:YES withParams:@{@"codeUuid":prizeData.codeUuid}];
    }
}

#pragma mark - LKPrizeCellDelegate
- (void)changeLikeBtnUpInside:(LKTypeData *)prizeData
{
    if (![LKShareUserInfo share].isLogin)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您还没有登录，请先登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
        return;
    }
    NSDictionary * body = @{@"codeUuid":prizeData.codeUuid};
    [self.controller sendMessageID:kPersonWinUserBtnTag messageInfo:@{kRequestUrl:kURL_PraiseWin, kRequestBody:body}];
}

#pragma Http Request callBack
-(void)update:(id)data msgID:(int)msgid faildCode:(EDataStatusCode)errCode{
    [ShowTipsView hideHUDWithView:self.view];
    LKMyTabModel * model = data;
    if (errCode == eDataCodeSuccess) {
        if (msgid == 10010) {
            dataArr = model.dataArray;
            [self addTableView];
        
            if (_model.curPage == kNoCurPage)
            {
                self.enablePullToLoadMore = NO;
            }else{
                self.enablePullToLoadMore = YES;
            }
            [self.tableView reloadData];
            self.tableView.hidden = NO;
            [self showPlaceholderView:nil boolWith:NO];
        }else if (msgid == kPersonWinUserBtnTag)
        {
            for (int i = 0; i < dataArr.count; i++) {
                LKTypeData *typeData = [dataArr objectAtIndex:i];
                if (_model.codeUuid.length > 0 && [typeData.codeUuid isEqualToString:_model.codeUuid]) {
                    typeData.praises = [NSString stringWithFormat:@"%ld", [typeData.praises integerValue]+1];
                    typeData.isPraises = @"1";
                    [self.tableView reloadData];
                }
            }
        }else if (msgid == kLoadMoreTag){
            [self pullToLoadMoreDidFinish];

            if (_model.curPage == kNoCurPage)
            {
                self.enablePullToLoadMore = NO;
            }else{
                self.enablePullToLoadMore = YES;
            }
            [self.tableView reloadData];
        }
        else{
            _model=model;
            [self getPrizeRequest];
        }
    }
    else {
        if (msgid == kPersonWinUserBtnTag)
        {
            [ShowTipsView showHUDWithMessage:@"点赞失败" andView:self.view];
        }else if (msgid == kLoadMoreTag)
        {
            [ShowTipsView showHUDWithMessage:@"网络异常获取数据失败" andView:self.view];
            [self pullToLoadMoreDidFinish];
        }
        else
        {
            [self showPlaceholderView:@"网络异常获取数据失败" boolWith:YES];
            self.tableView.hidden = YES;
        }
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
