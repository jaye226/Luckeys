//
//  LKDetailsViewPage.m
//  Luckeys
//
//  Created by lishaowei on 15/10/12.
//  Copyright © 2015年 Luckeys. All rights reserved.
//

#import "LKDetailsViewPage.h"
#import "LKCommentCell.h"
#import "LKRecommendCell.h"
#import "LKHeadportraitCell.h"
#import "LKDetailsHeadView.h"
#import "UIDetailsSectionCell.h"
#import "LKToCommentCell.h"
#import "LKDetailsData.h"
#import "LKDetailsMsgModel.h"
#import "LKBetUserData.h"
#import "LKSectionData.h"
#import "LKCommentData.h"
#import "LKRecommendActivityData.h"
#import "LKToCommentData.h"
#import "LKLoginViewPage.h"
#import "LKShowBettingListView.h"

@interface LKDetailsViewPage () <UITableViewDelegate, UITableViewDataSource, LKBaskViewDelegate, LKDetailsHeadViewDelegate, LKCommentCellDelegate, LKHeadportraitCellDelegate>
{
    NSString *_activityUuid;
    UITableView *_tableView;
    NSMutableArray *_arrayData;
    
    LKDetailsMsgModel *_detailsMsgModel;
    LKDetailsHeadView *_headView;
    
    UIButton *_toButton;
}

@end

@implementation LKDetailsViewPage

- (void)dealloc
{
    _tableView.delegate = nil;
    _tableView.dataSource = nil;
    _headView.delegate = nil;
}

-(id)init
{
    if (self = [super init])
    {
        [self registController:@"LKDetailsController"];//注册控制器
    }
    return self;
}

- (void)initWithParam:(NSDictionary *)paramInfo
{
    if (paramInfo.allKeys.count)
    {
        if ([paramInfo objectForKey:@"title"]) {
            self.title = [paramInfo objectForKey:@"title"];
        }else{
            self.title = @"详情";
        }
        _activityUuid = [paramInfo objectForKey:@"activityUuid"];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _toButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _toButton.frame = CGRectMake(0, UI_IOS_WINDOW_HEIGHT-BoundsOfScale(40)-64, UI_IOS_WINDOW_WIDTH, BoundsOfScale(40));
    [_toButton setBackgroundImage:[UIColor createImageWithColor:UIColorRGB(0xff664d)] forState:UIControlStateNormal];
    [_toButton setTitleColor:UIColorRGB(0xffffff) forState:UIControlStateNormal];
    [_toButton setTitle:@"我要投注" forState:UIControlStateNormal];
    [self.view addSubview:_toButton];
    [_toButton addTarget:self action:@selector(toBettingInside) forControlEvents:UIControlEventTouchUpInside];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, UI_IOS_WINDOW_WIDTH, UI_IOS_WINDOW_HEIGHT-64) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    [self addRightButton];
    
    [ShowTipsView showLoadHUDWithMSG:nil andView:self.view];

    [self requestForDetails];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bettingSuccess:) name:kNotiLKBettingSuccessNotification object:nil];
}

- (void)addRightButton
{
    [self.navigationView addRightButtonImage:@"ic_title_share"];
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

- (void)bettingSuccess:(NSNotification *)notification
{
    [self refreshDatasource];
}

//导航栏分享响应
- (void)changeNavRightBtnInside
{
    LKBaskView * view = [[LKBaskView alloc] initWithFrame:kAppWindow.bounds];
    [view updateIsShareLocal:NO];
    view.delegate = self;
    [kAppWindow addSubview:view];
}

- (void)addView:(LKDetailsData *)detailsData
{
    
    CGFloat height = BoundsOfScale(40);
    
    NSString *totalPrice = detailsData.totalPrice;
    NSString *betsUnitPrice = [NSString stringWithFormat:@"%ld", [detailsData.betNumber integerValue]*[detailsData.unitPrice intValue]];
    
    if ([betsUnitPrice integerValue] >= [totalPrice integerValue]) {
        height = 0;
    }
    
    _tableView.height = UI_IOS_WINDOW_HEIGHT-64-height;

    _toButton.height = height;
    _toButton.y = _tableView.maxY;
    
    [self addRefreshViewToTableView:_tableView];
    if (_headView) {
        [_headView removeFromSuperview];
    }
    _headView = [[LKDetailsHeadView alloc] initWithData:detailsData];
    _headView.delegate = self;
    _tableView.tableHeaderView = _headView;
}

- (void)toBettingInside
{
    [self pushPageWithName:@"LKBettingViewPage" animation:YES withParams:@{@"data":_detailsMsgModel.detailsData}];
}

- (void)refreshDatasource {
    [super refreshDatasource];
    [self refreshRequestData];
}

- (void)refreshRequestData
{
    NSDictionary * body = @{@"activityUuid":_activityUuid,@"userUuid":STR_IS_NULL([LKShareUserInfo share].userInfo.userUuid)};
    [self.controller sendMessageID:1001 messageInfo:@{kRequestUrl:kURL_ActivityDetail, kRequestBody:body}];
}

- (void)requestForDetails
{
    NSDictionary * body = @{@"activityUuid":_activityUuid,@"userUuid":STR_IS_NULL([LKShareUserInfo share].userInfo.userUuid)};
    [self.controller sendMessageID:1000 messageInfo:@{kRequestUrl:kURL_ActivityDetail, kRequestBody:body}];
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
    [self.controller sendMessageID:1009 messageInfo:@{kRequestUrl:kURL_AddUse, kRequestBody:body}];
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
        [self.navigationController pushViewController:loginVC animated:YES];
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _detailsMsgModel.infoArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    PADataObject *data = [_detailsMsgModel.infoArray objectAtIndex:indexPath.row];
    if ([data isKindOfClass:[LKBetUserData class]])
    {
        static NSString *cellId = @"HeadportraitId";
        LKHeadportraitCell *headportrait = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (headportrait == nil)
        {
            headportrait = [[LKHeadportraitCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        headportrait.selectionStyle = UITableViewCellSelectionStyleNone;
        [headportrait updateWithData:_detailsMsgModel.detailsData.listBetUser];
        headportrait.delegate = self;
        return headportrait;
    }
    else if ([data isKindOfClass:[LKSectionData class]])
    {
        LKSectionData *sectionData = (LKSectionData *)data;
        static NSString *cellId = @"DetailsSectioId";
        UIDetailsSectionCell *headportrait = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (headportrait == nil)
        {
            headportrait = [[UIDetailsSectionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        if (sectionData.isComment) {
            if (sectionData.isShowMore) {
                [headportrait setNameWith:@"评论" withHidden:NO];
            }else{
                [headportrait setNameWith:@"评论" withHidden:YES];
            }
            
        }else{
            [headportrait setNameWith:@"相似活动" withHidden:YES];
        }
        
        headportrait.selectionStyle = UITableViewCellSelectionStyleNone;
        return headportrait;
    }
    else if ([data isKindOfClass:[LKCommentData class]])
    {
        static NSString *cellId = @"CommentId";
        LKCommentCell *comment = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (comment == nil) {
            comment = [[LKCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            comment.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        comment.delegate = self;
        comment.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [comment updateWithData:(LKCommentData *)data];
        return comment;
    }
    else if ([data isKindOfClass:[LKToCommentData class]])
    {
        static NSString *cellId = @"ToCommentId";
        LKToCommentCell *headportrait = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (headportrait == nil) {
            headportrait = [[LKToCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        headportrait.selectionStyle = UITableViewCellSelectionStyleNone;
        return headportrait;
    }
    else
    {
        static NSString *cellId = @"RecommendId";
        LKRecommendCell *comment = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (comment == nil)
        {
            comment = [[LKRecommendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        [comment updateWithData:(LKRecommendActivityData *)data];
        return comment;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PADataObject *data = [_detailsMsgModel.infoArray objectAtIndex:indexPath.row];
    if ([data isKindOfClass:[LKBetUserData class]])
    {
        return [LKHeadportraitCell getCellHeight:_detailsMsgModel.detailsData.listBetUser];
    }
    else if ([data isKindOfClass:[LKSectionData class]])
    {
        return [UIDetailsSectionCell getCellHeight];
    }
    else if ([data isKindOfClass:[LKCommentData class]])
    {
        return [LKCommentCell getCellHeight:(LKCommentData *)data];
    }
    else if ([data isKindOfClass:[LKToCommentData class]])
    {
        return [LKToCommentCell getCellHeight];
    }
    else
    {
        return [LKRecommendCell getCellHeight];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    PADataObject *data = [_detailsMsgModel.infoArray objectAtIndex:indexPath.row];
    
    if ([data isKindOfClass:[LKToCommentData class]]) {
        [self pushPageWithName:@"LKCommentViewPage" animation:YES withParams:@{@"activityUuid":STR_IS_NULL(_detailsMsgModel.detailsData.activityUuid),@"title":STR_IS_NULL(_detailsMsgModel.detailsData.activityName)}];
    }else if ([data isKindOfClass:[LKRecommendActivityData class]])
    {
        LKRecommendActivityData *recommendActivityData = (LKRecommendActivityData *)data;
        [self pushPageWithName:@"LKDetailsViewPage" animation:YES withParams:@{@"activityUuid":STR_IS_NULL(recommendActivityData.activityUuid),@"title":STR_IS_NULL(recommendActivityData.activityName)}];
    }else if ([data isKindOfClass:[LKSectionData class]])
    {
        [self pushPageWithName:@"LKCommentViewPage" animation:YES withParams:@{@"activityUuid":STR_IS_NULL(_detailsMsgModel.detailsData.activityUuid),@"title":STR_IS_NULL(_detailsMsgModel.detailsData.activityName)}];
    }
}

#pragma mark - LKCommentCellDelegate
- (void)changeLikeBtn:(LKCommentData *)commentData
{
    if (![LKShareUserInfo share].isLogin)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您还没有登录，请先登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
        return;
    }
    [self requstCommentUseful:commentData.commentUuid];
}
//点击头像
- (void)changeHeadBtn:(LKCommentData *)commentData
{
    if (![LKShareUserInfo share].isLogin)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您还没有登录，请先登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
        return;
    }
    [self pushPageWithName:@"LKMyTabViewPage" withParams:@{@"uuid":STR_IS_NULL(commentData.userUuid)}];
}

#pragma mark - LKDetailsHeadViewDelegate
- (void)endCountdown
{
    _tableView.tableHeaderView = _headView;
}

- (void)changeWinHeadImageViewBtn:(NSString *)userId
{
    [self pushPageWithName:@"LKMyTabViewPage" withParams:@{@"uuid":STR_IS_NULL(userId)}];
}

- (void)changeLike
{
    if (![LKShareUserInfo share].isLogin)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您还没有登录，请先登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
        return;
    }
    
    NSString * iLike = @"";
    if ([_detailsMsgModel.detailsData.iLike boolValue] == YES) {
        iLike = @"1";
    }
    else
    {
        iLike = @"0";
    }
    id body = @{@"activityUuid":STR_IS_NULL(_detailsMsgModel.detailsData.activityUuid),@"iLike":iLike};
    [self.controller sendMessageID:10005 messageInfo:@{kRequestUrl:kURL_CollectionActivity,kRequestBody:body}];
}

//中奖人点赞
- (void)changeWinUserBtn:(LKDetailsData *)detailsData
{
    if (![LKShareUserInfo share].isLogin)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您还没有登录，请先登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
        return;
    }
    
    NSDictionary * body = @{@"codeUuid":_detailsMsgModel.detailsData.codeUuid};//,@"userUuid":STR_IS_NULL([LKShareUserInfo share].userInfo.userUuid)
    [self.controller sendMessageID:kWinUserBtn messageInfo:@{kRequestUrl:kURL_PraiseWin, kRequestBody:body}];
}

#pragma mark - LKBaskViewDelegate
- (void)handleBaskButtonAction:(NSInteger)buttonIndex;
{
    if (buttonIndex == 4 || buttonIndex == 5) {
        [self shareIndex:buttonIndex imageWith:nil];
        return;
    }
    [ShowTipsView showLoadHUDWithMSG:@"获取分享信息" andView:self.view];
    
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@%@",SeverHost,_detailsMsgModel.detailsData.imageUrl]];
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:url options:SDWebImageDownloaderUseNSURLCache progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
        [ShowTipsView hideHUDWithView:self.view];
        if (!error) {
            UIImage *imageShare = [self compressionImage:image bitLenght:32*1024];
            [self shareIndex:buttonIndex imageWith:imageShare];
        }else{
            [self shareIndex:buttonIndex imageWith:nil];
        }
    }];
}

- (void)shareIndex:(NSInteger)index imageWith:(UIImage *)image
{
    dispatch_async(dispatch_get_main_queue(), ^{

        switch (index) {
            case 0:
            {
                [UMSocialData defaultData].extConfig.wechatTimelineData.title = _detailsMsgModel.detailsData.activityName;
                [UMSocialData defaultData].extConfig.wechatTimelineData.url = @"http://baidu.com";
                [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToWechatTimeline] content:_detailsMsgModel.detailsData.descri image:image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                    if (response.responseCode == UMSResponseCodeSuccess) {
                        NSLog(@"分享成功！");
                        [ShowTipsView showHUDWithMessage:@"分享成功" andView:self.view];
                    }
                }];
                break;
            }
            case 1:
            {
                [UMSocialData defaultData].extConfig.wechatSessionData.url = @"http://baidu.com";
                [UMSocialData defaultData].extConfig.wechatSessionData.title = _detailsMsgModel.detailsData.activityName;
                [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:_detailsMsgModel.detailsData.descri image:image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                    if (response.responseCode == UMSResponseCodeSuccess) {
                        NSLog(@"分享成功！");
                        [ShowTipsView showHUDWithMessage:@"分享成功" andView:self.view];
                        
                    }
                }];
                break;
            }
            case 2:
            {
                [UMSocialData defaultData].extConfig.qqData.title = _detailsMsgModel.detailsData.activityName;
                [UMSocialData defaultData].extConfig.qqData.url = @"http://baidu.com";
                [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:_detailsMsgModel.detailsData.descri image:image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                    if (response.responseCode == UMSResponseCodeSuccess) {
                        NSLog(@"分享成功！");
                        [ShowTipsView showHUDWithMessage:@"分享成功" andView:self.view];
                    }
                }];
                break;
            }
            case 3:
            {
                NSString *content = [NSString stringWithFormat:@"%@http://www.baidu.com",_detailsMsgModel.detailsData.descri];
                [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:content image:image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *shareResponse){
                    if (shareResponse.responseCode == UMSResponseCodeSuccess) {
                        NSLog(@"分享成功！");
                        [ShowTipsView showHUDWithMessage:@"分享成功" andView:self.view];
                    }
                }];
                break;
            }
            case 4:
            {
                break;
            }
            case 5:
            {
                [self pushPageWithName:@"LKShareCmmentViewPage" animation:YES withParams:@{@"activityUuid":STR_IS_NULL(_detailsMsgModel.detailsData.activityUuid)}];
                break;
            }
                
            default:
                break;
        }
    });
    
}

- (void)pushShareCmmentViewPage
{
    [self pushPageWithName:@"LKShareCmmentViewPage" animation:YES withParams:@{@"activityUuid":STR_IS_NULL(_detailsMsgModel.detailsData.activityUuid)}];
}

- (UIImage *)compressionImage:(UIImage*)image bitLenght:(NSInteger)lenght
{
    if (!image) {
        return nil;
    }
    //150的size
    CGFloat maxSize = 150.f;
    CGFloat scale = 1.0;
    if (MAX(image.size.width, image.size.height) > maxSize) {
        scale = maxSize/MAX(image.size.width, image.size.height);
        image = [image scaleImageToScale:scale];
    }
    
    //控制32KB
    double quality = 1.0;
    NSData * data = UIImageJPEGRepresentation(image, quality);
    while ([data length] > lenght) {
        if(quality > 0.1){
            quality -= 0.1;
            data = UIImageJPEGRepresentation(image, quality);
        }else{
            data = UIImageJPEGRepresentation(image, 0);
            break;
        }
    }
    return [UIImage imageWithData:data];
    
}

#pragma mark - LKHeadportraitCellDelegate

- (void)changeHeadportraitBet:(LKBetUserData *)data
{
    [self pushPageWithName:@"LKMyTabViewPage" withParams:@{@"uuid":STR_IS_NULL(data.userUuid)}];
}

/**
 *  显示投注码
 *
 *  @param codeArray
 */
- (void)showHeadporInside:(NSArray *)codeArray
{
    if (codeArray.count > 0)
    {
        [LKShowBettingListView showListView:codeArray];
    }
}

#pragma mark - 数据
- (void)update:(id)data msgID:(int)msgid faildCode:(EDataStatusCode)errCode
{
    [ShowTipsView hideHUDWithView:self.view];

    _detailsMsgModel = [self.controller getModelFromListByName:@"LKDetailsMsgModel"];
    [self stopRefreshData];
    if (errCode == eDataCodeSuccess) {
        if (msgid == 1000 || msgid == 1001) {
            [self addView:_detailsMsgModel.detailsData];
            self.title = _detailsMsgModel.detailsData.activityName;
            [_tableView reloadData];
            [self showPlaceholderView:@"" boolWith:NO];
        }else if (msgid == 1009)
        {
            [_tableView reloadData];
        }else if (msgid == kWinUserBtn)
        {
            [_headView updateWinUser:_detailsMsgModel.detailsData];
        }else if (msgid == 10005) {
            [_headView updateLike:_detailsMsgModel.detailsData];
        }
        
    }else{
        if (msgid == 1000) {
            [self showPlaceholderView:@"网络异常获取数据失败" boolWith:YES];
        }
        if (msgid == kWinUserBtn) {
            [ShowTipsView showHUDWithMessage:@"点赞失败" andView:self.view];
        }else{
            [ShowTipsView showHUDWithMessage:kRequest_TimeOut andView:self.view];
        }
    }
    
}

@end
