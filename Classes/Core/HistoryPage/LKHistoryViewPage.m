//
//  LKHistoryViewPage.m
//  Luckeys
//
//  Created by BearLi on 15/9/26.
//  Copyright © 2015年 Luckeys. All rights reserved.
//

#import "LKHistoryViewPage.h"
#import "LKHistoryPrizeCell.h"
#import "LKHistoryBettingCell.h"
#import "LKHistoryBettingData.h"
#import "LKHistoryModel.h"
#import "LKLoadMoreCell.h"

@interface LKHistoryViewPage ()<UITableViewDelegate,UITableViewDataSource,LKHistoryPrizeDelegate,LKBaskViewDelegate,BettingLikeDelegate>
{
    UIButton *_prizeBtn;
    UIButton *_bettingBtn;
    UITableView *_prizeTableView;
    UITableView *_bettingTableView;
    NSMutableArray *_dataArr;
    NSInteger _type; //1中奖,2投注
}

@property (nonatomic,strong) LKHistoryBettingData *selectData;

@end

@implementation LKHistoryViewPage

- (void)dealloc
{
    _prizeTableView.delegate = nil;
    _prizeTableView.dataSource = nil;
    _bettingTableView.delegate = nil;
    _bettingTableView.dataSource = nil;
}

-(id)init
{
    if (self = [super init])
    {
        [self registController:@"LKHistoryController"];//注册控制器
    }
    return self;
}

- (void)initWithParam:(NSDictionary *)paramInfo
{
    if (paramInfo.allKeys.count)
    {
        
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        //self.navigationController.interactivePopGestureRecognizer.enabled = NO;
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
    
    _dataArr=[[NSMutableArray alloc] initWithCapacity:0];
    _type=2;
    
    [self initView];
    [self requestHistoryBetting];
}

-(void)initView{

    //中奖按钮
    _prizeBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _prizeBtn.frame=CGRectMake(UI_IOS_WINDOW_WIDTH/2,20,UI_IOS_WINDOW_WIDTH/2, BoundsOfScale(38));
    [_prizeBtn setTitle:@"中奖" forState:UIControlStateNormal];
    [_prizeBtn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
    [_prizeBtn.titleLabel setFont:[UIFont systemFontOfSize:FontOfScale(14)]];
    [_prizeBtn setBackgroundColor:UIColorRGB(0xe9e9e9)];
    _prizeBtn.tag=499;
    _prizeBtn.selected=NO;
    [_prizeBtn addTarget:self action:@selector(clickPrizeBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_prizeBtn];
    
    _prizeTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_prizeBtn.frame), UI_IOS_WINDOW_WIDTH, self.view.frame.size.height-CGRectGetMaxY(_prizeBtn.frame)-44) style:UITableViewStylePlain];
    _prizeTableView.tag=600;
    _prizeTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _prizeTableView.delegate=self;
    _prizeTableView.dataSource=self;
    [self.view addSubview:_prizeTableView];
    [self addRefreshViewToTableView:_prizeTableView];
    [self addLoadMoreCellToTableView:_prizeTableView];
    
    //投注按钮
    _bettingBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _bettingBtn.frame=CGRectMake(0,20,UI_IOS_WINDOW_WIDTH/2, BoundsOfScale(38));
    [_bettingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_bettingBtn setTitle:@"投注" forState:UIControlStateNormal];
    [_bettingBtn.titleLabel setFont:[UIFont systemFontOfSize:FontOfScale(14)]];
    [_bettingBtn setBackgroundColor:UIColorRGB(0xf75347)];
    _bettingBtn.tag=599;
    _bettingBtn.selected=YES;
    [_bettingBtn addTarget:self action:@selector(clickPrizeBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_bettingBtn];
    _bettingBtn.userInteractionEnabled = NO;
    
    _bettingTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_prizeBtn.frame), UI_IOS_WINDOW_WIDTH, self.view.frame.size.height-CGRectGetMaxY(_prizeBtn.frame)-44) style:UITableViewStylePlain];
    _bettingTableView.tag=601;
    _bettingTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _bettingTableView.delegate=self;
    _bettingTableView.dataSource=self;
    
    [self.view addSubview:_bettingTableView];
    [self addRefreshViewToTableView:_bettingTableView];
    [self addLoadMoreCellToTableView:_bettingTableView];
    
}

- (void)showPlaceholderView:(NSString *)showText boolWith:(BOOL)isBool tableWith:(UITableView *)tableView
{
    if (isBool)
    {
        self.placeholderInfoView.hidden = NO;
        
        [self showPlaceholderViewState:showText];
        [tableView addSubview:self.placeholderInfoView];
        [self adjustPlaceHolderFrame:NO];
    }
    else
    {
        self.placeholderInfoView.hidden = YES;
    }
}

-(void)clickPrizeBtn:(UIButton*)sender{
    NSInteger btnTag=sender.tag;
    UIButton *priBtn=(UIButton*)[self.view viewWithTag:499];
    UIButton *betBtn=(UIButton*)[self.view viewWithTag:599];
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sender setBackgroundColor:UIColorRGB(0xf75347)];
    sender.selected = YES;
    if(btnTag==499){
        _type=1;
        [betBtn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
        [betBtn setBackgroundColor:UIColorRGB(0xe9e9e9)];
        betBtn.userInteractionEnabled = YES;
        priBtn.userInteractionEnabled = NO;
        betBtn.selected = NO;

        [self.view bringSubviewToFront:_prizeTableView];
        [self addRefreshViewToTableView:_prizeTableView];
        [self addLoadMoreCellToTableView:_prizeTableView];
    }else{
        _type=2;
        [priBtn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
        [priBtn setBackgroundColor:UIColorRGB(0xe9e9e9)];
        priBtn.userInteractionEnabled = YES;
        betBtn.userInteractionEnabled = NO;
        priBtn.selected = NO;
        
        [self.view bringSubviewToFront:_bettingTableView];
        [self addRefreshViewToTableView:_bettingTableView];
        [self addLoadMoreCellToTableView:_bettingTableView];
    }
    [self refreshDatasource];
}

- (void)requestHistoryBetting
{
    [ShowTipsView showLoadHUDWithMSG:@"" andView:self.view];
    NSString *requestUrl;
    if(_type==1){
        requestUrl=kURL_QueryWinByUserId;
    }else{
        requestUrl=kURL_QueryBetByUserId;
    }
    NSDictionary * body = @{@"userUuid":[[[LKShareUserInfo share] userInfo] userUuid],@"seeUserUuid":[[[LKShareUserInfo share] userInfo] userUuid],kLKCurPage:[NSString stringWithFormat:@"%ld", (long)self.currentPage],@"pageSize":kLKPageSize};
    [self.controller sendMessageID:_type==1?999:1111 messageInfo:@{kRequestUrl:requestUrl,kRequestBody:body}];
}

-(void)requestMoreHistoryBetting{
    [ShowTipsView showLoadHUDWithMSG:@"" andView:self.view];
    NSString *requestUrl;
    if(_type==1){
        requestUrl=kURL_QueryWinByUserId;
    }else{
        requestUrl=kURL_QueryBetByUserId;
    }
    
    NSDictionary * body = @{@"userUuid":[[[LKShareUserInfo share] userInfo] userUuid],@"seeUserUuid":STR_IS_NULL([[[LKShareUserInfo share] userInfo] userUuid]),kLKCurPage:[NSString stringWithFormat:@"%ld", (long)self.currentPage],@"pageSize":kLKPageSize};
    [self.controller sendMessageID:1000 messageInfo:@{kRequestUrl:requestUrl,kRequestBody:body}];
}

-(void)refreshDatasource{
    [super refreshDatasource];
    [self requestHistoryBetting];
}

-(void)loadMoreData{
    [super loadMoreData];
    [self requestMoreHistoryBetting];
}

#pragma UITableView delagate and dataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isLoading) {
        return [_dataArr count]+1;
    }
    return [_dataArr count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isLoading && indexPath.row == [_dataArr count]) {
        return [LKLoadMoreCell getCellHeight];
    }
    if(tableView.tag==600)
    {
        LKHistoryBettingData *data=[_dataArr objectAtIndex:indexPath.row];
        return [LKHistoryPrizeCell getHistoryCellHeight:data];
    }
    else
    {
        return BoundsOfScale(276);
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView==_prizeTableView){
        if(indexPath.row==_dataArr.count&&self.isLoading){
            [self.loadMoreCell startLoadMore];
            [self loadMoreData];
            return self.loadMoreCell;
        }else{
            static NSString * cellId = @"LKHistoryPrizeCell";
            LKHistoryPrizeCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (!cell) {
                cell = [[LKHistoryPrizeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            }
            cell.showBtn.tag = indexPath.row + 100;
            cell.delegate = self;
            LKHistoryBettingData *data=[_dataArr objectAtIndex:indexPath.row];
            [cell setPrizeCellData:data];
            return cell;
        }
    }else{
        if(indexPath.row==_dataArr.count&&self.isLoading){
            [self.loadMoreCell startLoadMore];
            [self loadMoreData];
            return self.loadMoreCell;
        }else{
            static NSString * cellId = @"LKHistoryBettingCell";
            LKHistoryBettingCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (!cell) {
                cell = [[LKHistoryBettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            }
            LKHistoryBettingData *data=[_dataArr objectAtIndex:indexPath.row];
            cell.likeBtn.tag=9999+indexPath.row;
            cell.bettingDelegate=self;
            [cell setBettingCellData:data];
            return cell;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView==_prizeTableView){
        LKHistoryBettingData *data=[_dataArr objectAtIndex:indexPath.row];
        [self pushPageWithName:@"LKDetailsViewPage" animation:YES withParams:@{@"activityUuid":STR_IS_NULL(data.activityUuid),@"title":STR_IS_NULL(data.activityName)}];
    }else{
        LKHistoryBettingData *data=[_dataArr objectAtIndex:indexPath.row];
        [self pushPageWithName:@"LKDetailsViewPage" animation:YES withParams:@{@"activityUuid":STR_IS_NULL(data.activityUuid),@"title":STR_IS_NULL(data.activityName)}];
    }
}

- (void)handleShowButton:(LKHistoryBettingData *)data
{
    _selectData = data;
    LKBaskView * view = [[LKBaskView alloc] initWithFrame:kAppWindow.bounds];
    view.delegate = self;
    [kAppWindow addSubview:view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - BettingLikeDelegate
//喜欢按钮点击回调
-(void)bettingLike:(NSInteger)tag
{
    NSInteger index = tag - 9999;
    if (index < 0 || index >= _dataArr.count) {
        return;
    }
    
    LKHistoryBettingData *data = _dataArr[index];
    NSString * iLike = @"";
    if ([data.iLike boolValue] == YES) {
        iLike = @"1";
    }
    else
    {
        iLike = @"0";
    }
    id body = @{@"activityUuid":STR_IS_NULL(data.activityUuid),@"iLike":iLike};
    [self.controller sendMessageID:1200 messageInfo:@{kRequestUrl:kURL_CollectionActivity,kRequestBody:body}];
}

#pragma mark - LKBaskViewDelegate
//晒一晒
- (void)handleBaskButtonAction:(NSInteger)buttonIndex;
{
    if (buttonIndex == 4 || buttonIndex == 5) {
        [self shareIndex:buttonIndex imageWith:nil];
        _selectData = nil;
        return;
    }
    [ShowTipsView showLoadHUDWithMSG:@"获取分享信息" andView:self.view];
    
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@%@",SeverHost,_selectData.imageUrl]];
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:url options:SDWebImageDownloaderUseNSURLCache progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [ShowTipsView hideHUDWithView:self.view];
            if (!error) {
                UIImage *imageShare = [self compressionImage:image bitLenght:32*1024];
                [self shareIndex:buttonIndex imageWith:imageShare];
            }else{
                [self shareIndex:buttonIndex imageWith:nil];
            }
        });

    }];
}

- (void)shareIndex:(NSInteger)index imageWith:(UIImage *)image
{
    switch (index) {
        case 0:
        {
            [UMSocialData defaultData].extConfig.wechatTimelineData.title = @"123";
            [UMSocialData defaultData].extConfig.wechatTimelineData.url = @"http://baidu.com";
            [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToWechatTimeline] content:_selectData.descri image:image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    NSLog(@"分享成功！");
                    [ShowTipsView showHUDWithMessage:@"分享成功" andView:self.view];
                }
                _selectData = nil;
            }];
            break;
        }
        case 1:
        {
            [UMSocialData defaultData].extConfig.wechatSessionData.url = @"http://baidu.com";
            [UMSocialData defaultData].extConfig.wechatSessionData.title = _selectData.activityName;
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:_selectData.descri image:image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    NSLog(@"分享成功！");
                    [ShowTipsView showHUDWithMessage:@"分享成功" andView:self.view];
                }
                _selectData = nil;
            }];
            break;
        }
        case 2:
        {
            [UMSocialData defaultData].extConfig.qqData.title = _selectData.activityName;
            [UMSocialData defaultData].extConfig.qqData.url = @"http://baidu.com";
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:_selectData.descri image:image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    NSLog(@"分享成功！");
                    [ShowTipsView showHUDWithMessage:@"分享成功" andView:self.view];
                }
                _selectData = nil;
            }];
            break;
        }
        case 3:
        {
            NSString *content = [NSString stringWithFormat:@"%@http://www.baidu.com",_selectData.descri];
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:content image:image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *shareResponse){
                if (shareResponse.responseCode == UMSResponseCodeSuccess) {
                    NSLog(@"分享成功！");
                    [ShowTipsView showHUDWithMessage:@"分享成功" andView:self.view];
                }
                _selectData = nil;
            }];
            break;
        }
        case 4:
        {
            break;
        }
        case 5:
        {
            [self pushPageWithName:@"LKShareCmmentViewPage" animation:YES withParams:@{@"activityUuid":STR_IS_NULL(_selectData.activityUuid)}];
            _selectData = nil;
            break;
        }
            
        default:
            break;
    }
}

- (void)pushShareCmmentViewPage
{
    [self pushPageWithName:@"LKShareCmmentViewPage" animation:YES withParams:@{@"activityUuid":STR_IS_NULL(@"123")}];
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

#pragma mark - 数据
- (void)update:(id)data msgID:(int)msgid faildCode:(EDataStatusCode)errCode
{
    [ShowTipsView hideHUDWithView:self.view];
    [self stopRefreshData];
    if (errCode == eDataCodeSuccess) {
        LKHistoryModel *model=(LKHistoryModel*)data;
        if (msgid == 1000)
        {
            if (!model.listData.count)
            {
                self.currentPage = 0;
            }
            [_dataArr addObjectsFromArray:model.listData];
            [self stopLoadMoreData:_dataArr];
            
            if(_type==1){
                [_prizeTableView reloadData];
            }else{
                [_bettingTableView reloadData];
            }
        }
        else if(msgid==999||msgid==1111)
        {
            if (!model.listData.count)
            {
                self.currentPage = 0;
            }
            [self stopLoadMoreData:model.listData];
            [_dataArr removeAllObjects];
            [_dataArr addObjectsFromArray:model.listData];
            
            if(_type==1){
                [_prizeTableView reloadData];
                if (_dataArr.count <= 0) {
                    [self showPlaceholderView:@"暂无数据" boolWith:YES tableWith:_prizeTableView];
                }else{
                    [self showPlaceholderView:@"" boolWith:NO tableWith:_prizeTableView];
                }
            }else{
                [_bettingTableView reloadData];
                if (_dataArr.count <= 0) {
                    [self showPlaceholderView:@"暂无数据" boolWith:YES tableWith:_bettingTableView];
                }else{
                    [self showPlaceholderView:@"" boolWith:NO tableWith:_bettingTableView];
                }
            }
            
        }else{//点赞
            [_bettingTableView reloadData];
        }
    }else{
        if(msgid==999||msgid==1111) {
            if(_type==1){
                if (_dataArr.count <= 0) {
                    [self showPlaceholderView:@"网络异常获取数据失败" boolWith:YES tableWith:_prizeTableView];
                }else{
                    [self showPlaceholderView:@"" boolWith:NO tableWith:_prizeTableView];
                    [_prizeTableView reloadData];
                }
            }else{
                if (_dataArr.count <= 0) {
                    [self showPlaceholderView:@"网络异常获取数据失败" boolWith:YES tableWith:_bettingTableView];
                }else{
                    [self showPlaceholderView:@"" boolWith:NO tableWith:_bettingTableView];
                    [_bettingTableView reloadData];
                }
            }
        }
        [self.loadMoreCell stopLoadMore];
    }
}

@end
