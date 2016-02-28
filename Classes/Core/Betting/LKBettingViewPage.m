//
//  LKBettingViewPage.m
//  Luckeys
//
//  Created by lishaowei on 15/11/1.
//  Copyright © 2015年 Luckeys. All rights reserved.
//

#import "LKBettingViewPage.h"
#import "ZLSwipeableView.h"
#import "CardView.h"
#import "LKDetailsData.h"
#import "LKBettingModel.h"

@interface LKBettingViewPage () <ZLSwipeableViewDataSource, ZLSwipeableViewDelegate, CardViewDelegate, UIAlertViewDelegate>
{
    ZLSwipeableView *_swipeableView;
    
    NSInteger _countIndex;  //当前显示的编号的位置
    
    LKDetailsData *_detailsData;
    
    LKBettingModel *_bettingModel;
    
    NSString *_timeLabel;
    
    NSMutableArray *_selectArray;   //选择的数组
    
    UIView *_bjView;
    
    NSInteger _selectdCount;    //选择的个数
    
    UILabel *_conetnLabel;  //当前显示的编号
    
    NSMutableArray *_showNumberArray;   //编号按照10个一组
    
    NSInteger _showCont; //显示第几个数组
    
    UIButton *_toButton;
}

@end

@implementation LKBettingViewPage

- (void)dealloc
{
    _swipeableView.delegate = nil;
    _swipeableView.dataSource = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(id)init
{
    if (self = [super init])
    {
        [self registController:@"LKBettingController"];//注册控制器
    }
    return self;
}

- (void)initWithParam:(NSDictionary *)paramInfo
{
    if (paramInfo.allKeys.count)
    {
        _detailsData = [paramInfo objectForKey:@"data"];
        NSString *strDate = [NSString transTime:STR_IS_NULL(_detailsData.startDate) Format:@"yyyy-MM-dd"];
        NSString *endDate = [NSString transTime:STR_IS_NULL(_detailsData.endDate) Format:@"yyyy-MM-dd"];
        _timeLabel = [NSString stringWithFormat:@"%@到%@", strDate, endDate];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"投注";
    
    _selectdCount = 0;
    
    _countIndex = 0;
    
    _selectArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    _showNumberArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    [self addAightButton];
    
    [ShowTipsView showLoadHUDWithMSG:nil andView:self.view];
    
    [self requestForDetails];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orderSuccessNotification) name:kNotiLKOrderSuccessNotification object:nil];
}

- (void)addAightButton
{
    [self.navigationView addRightButtonTitleWith:@"随机" titleColorWith:[UIColor blackColor] selectdColorWith:nil fontWith:[UIFont systemFontOfSize:FontOfScale(15)]];
}

- (void)addView
{
    
    _bjView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, UI_IOS_WINDOW_WIDTH, UI_IOS_WINDOW_HEIGHT-64)];
    _bjView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bjView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageView.image = [[UIImage imageNamed:@"login_home_bg"] boxblurImageWithBlur:0.8];
    [_bjView addSubview:imageView];
    
    //左侧按钮
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake((UI_IOS_WINDOW_WIDTH - BoundsOfScale(15)*2-BoundsOfScale(100))/2, BoundsOfScale(50), BoundsOfScale(15), BoundsOfScale(15));
    [leftButton setImage:[UIImage imageNamed:@"ic_choose_left"] forState:UIControlStateNormal];
    [_bjView addSubview:leftButton];
    [leftButton addTarget:self action:@selector(leftButtonInside) forControlEvents:UIControlEventTouchUpInside];
    
    _conetnLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftButton.maxX, leftButton.y-BoundsOfScale(15)/2, BoundsOfScale(100), BoundsOfScale(30))];
    _conetnLabel.textAlignment = NSTextAlignmentCenter;
    _conetnLabel.font = [UIFont systemFontOfSize:FontOfScale(15)];
    _conetnLabel.textColor = [UIColor whiteColor];
    [_bjView addSubview:_conetnLabel];
    _conetnLabel.text = [NSString stringWithFormat:@"%lu-%lu",(unsigned long)(_showCont*10+1), (unsigned long)((_bettingModel.listData.count<10?_bettingModel.listData.count:(_showCont*10+[[_showNumberArray objectAtIndex:_showCont] count])))];
    
    //右侧按钮
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(_conetnLabel.maxX, leftButton.y, BoundsOfScale(15), BoundsOfScale(15));
    [rightButton setImage:[UIImage imageNamed:@"ic_choose_right"] forState:UIControlStateNormal];
    [_bjView addSubview:rightButton];
    [rightButton addTarget:self action:@selector(rightButtonInside) forControlEvents:UIControlEventTouchUpInside];
    
    _swipeableView = [[ZLSwipeableView alloc] initWithFrame:CGRectMake(BoundsOfScale(20), (UI_IOS_WINDOW_HEIGHT-BoundsOfScale(232)-64-BoundsOfScale(45))/2, UI_IOS_WINDOW_WIDTH-BoundsOfScale(40), BoundsOfScale(232))];
    [_swipeableView setNeedsLayout];
    [_swipeableView layoutIfNeeded];
    _swipeableView.dataSource = self;
    _swipeableView.delegate = self;
    [_bjView addSubview:_swipeableView];
    
    _toButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _toButton.frame = CGRectMake(0, UI_IOS_WINDOW_HEIGHT-BoundsOfScale(45)-64, UI_IOS_WINDOW_WIDTH, BoundsOfScale(49));
    [_toButton setBackgroundImage:[UIColor createImageWithColor:UIColorRGB(0xff664d)] forState:UIControlStateNormal];
    [_toButton setTitleColor:UIColorRGB(0xffffff) forState:UIControlStateNormal];
    [_toButton setTitle:@"提交" forState:UIControlStateNormal];
    _toButton.titleLabel.font = [UIFont systemFontOfSize:FontOfScale(16)];
    [_bjView addSubview:_toButton];
    [_toButton addTarget:self action:@selector(submitInside) forControlEvents:UIControlEventTouchUpInside];
}

- (void)orderSuccessNotification
{
    for (LKBettingData *bettData in _selectArray) {
        if ([_bettingModel.listData containsObject:bettData]) {
            [_bettingModel.listData removeObject:bettData];
        }
    }
    if (_bettingModel.listData.count <= 0)
    {
        [_bjView removeFromSuperview];
        [self.navigationView removeRightBtn];
        [self showPlaceholderView:@"已经被抢光了－－!" boolWith:YES];
    }else{
        [self showPlaceholderView:@"" boolWith:NO];
    }
    
    _countIndex = 0;
    
    _showCont = 0;
    if (_bettingModel.listData.count%10 > 0)
    {
        _showCont = _bettingModel.listData.count/10+1;
    }else{
        _showCont = _bettingModel.listData.count/10;
    }
    
    if (_showNumberArray.count > 0) {
        [_showNumberArray removeAllObjects];
    }
    
    for (int i = 0; i < _showCont; i++) {
        NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:0];
        for (int j = 0; j < 10; j++) {
            if (i*10+j >= _bettingModel.listData.count) {
                break;
            }
            [arr addObject:[_bettingModel.listData objectAtIndex:i*10+j]];
        }
        [_showNumberArray addObject:arr];
    }
    _showCont = 0;
    
    [_swipeableView discardAllSwipeableViews];
    [_swipeableView loadNextSwipeableViewsIfNeeded];
    
    _conetnLabel.text = [NSString stringWithFormat:@"%lu-%lu",(unsigned long)(_showCont*10+1), (unsigned long)((_bettingModel.listData.count<10?_bettingModel.listData.count:(_showCont*10+[[_showNumberArray objectAtIndex:_showCont] count])))];
    
    _selectdCount = 0;
    [_selectArray removeAllObjects];
    
    [_toButton setTitle:[NSString stringWithFormat:@"确定"] forState:UIControlStateNormal];

}

- (void)leftButtonInside
{
    NSInteger count = 0;
    if (_bettingModel.listData.count%10 > 0)
    {
        count = _bettingModel.listData.count/10+1;
    }else{
        count = _bettingModel.listData.count/10;
    }
    
    if (_showCont-1 < 0)
    {
        _showCont = count-1;
    }else{
        _showCont -= 1;
    }
    _countIndex = 0;
    
    _conetnLabel.text = [NSString stringWithFormat:@"%lu-%lu",(unsigned long)(_showCont*10+1), (unsigned long)((_bettingModel.listData.count<10?_bettingModel.listData.count:(_showCont*10+[[_showNumberArray objectAtIndex:_showCont] count])))];
    
    [_swipeableView discardAllSwipeableViews];
    [_swipeableView loadNextSwipeableViewsIfNeeded];
}

- (void)rightButtonInside
{
    NSInteger count = 0;
    if (_bettingModel.listData.count%10 > 0)
    {
        count = _bettingModel.listData.count/10+1;
    }else{
        count = _bettingModel.listData.count/10;
    }
    
    if (_showCont+1 >= count)
    {
        _showCont = 0;
    }else{
        _showCont += 1;
    }
    _countIndex = 0;
    
    _conetnLabel.text = [NSString stringWithFormat:@"%lu-%lu",(unsigned long)(_showCont*10+1), (unsigned long)((_bettingModel.listData.count<10?_bettingModel.listData.count:(_showCont*10+[[_showNumberArray objectAtIndex:_showCont] count])))];
    
    [_swipeableView discardAllSwipeableViews];
    [_swipeableView loadNextSwipeableViewsIfNeeded];
}

- (void)showPlaceholderView:(NSString *)showText boolWith:(BOOL)isBool
{
    if (isBool)
    {
        self.placeholderInfoView.hidden = NO;
        
        [self showPlaceholderViewState:showText];
        [self.view addSubview:self.placeholderInfoView];
        [self adjustPlaceHolderFrame:NO];
    }
    else
    {
        self.placeholderInfoView.hidden = YES;
    }
}

- (void)submitInside
{
    if (_selectArray.count <= 0) {
        [ShowTipsView showHUDWithMessage:@"请选择投注号码" andView:self.view];
        return;
    }
    
    [ShowTipsView showLoadHUDWithMSG:@"" andView:self.view];

    [self requestBetCode];
    
    //[self pushPageWithName:@"LKPayViewPage" animation:YES withParams:@{@"detailsData":_detailsData, @"selectArray":_selectArray}];
}

- (void)changeNavRightBtnInside
{
    NSInteger listCount = _bettingModel.listData.count;

    if (listCount > 0) {
        NSInteger intIndex = arc4random_uniform(listCount);
        LKBettingData *data = [_bettingModel.listData objectAtIndex:intIndex];
        
        if ([_selectArray containsObject:data]){
            return;
        }else{
            [_selectArray addObject:data];
            [_toButton setTitle:[NSString stringWithFormat:@"提交(%lu)", (unsigned long)_selectArray.count] forState:UIControlStateNormal];
            _conetnLabel.text = [NSString stringWithFormat:@"%lu-%lu",(unsigned long)(_showCont*10+1), (unsigned long)((_bettingModel.listData.count<10?_bettingModel.listData.count:(_showCont*10+[[_showNumberArray objectAtIndex:_showCont] count])))];

            for (int i = 0; i < _showNumberArray.count; i++)
            {
                NSArray *arr = [_showNumberArray objectAtIndex:i];
                if ([arr containsObject:data])
                {
                    _showCont = i;
                    _countIndex = [[_showNumberArray objectAtIndex:i] indexOfObject:data];
                }
            }
            [_swipeableView discardAllSwipeableViews];
            [_swipeableView loadNextSwipeableViewsIfNeeded];
        }
    }
}

- (void)requestForDetails
{
    NSDictionary * body = @{@"activityUuid":_detailsData.activityUuid};
    [self.controller sendMessageID:1000 messageInfo:@{kRequestUrl:kURL_QueryCodeList, kRequestBody:body}];
}

//锁定编号
- (void)requestBetCode
{
    NSMutableArray *arry = [[NSMutableArray alloc] initWithCapacity:0];
    for (LKBettingData *data in _selectArray)
    {
        [arry addObject:data.codeUuid];
    }
    
    NSDictionary * body = @{@"userUuid":[[LKShareUserInfo share] userInfo].userUuid,@"listCodeUuid":arry};

    [self.controller sendMessageID:10086 messageInfo:@{kRequestUrl:kURL_BetCode,kRequestBody:body}];

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

#pragma mark - ZLSwipeableViewDelegate
- (void)swipeableView: (ZLSwipeableView *)swipeableView didSwipeLeft:(UIView *)view {
    NSLog(@"did swipe left");
}
- (void)swipeableView: (ZLSwipeableView *)swipeableView didSwipeRight:(UIView *)view {
    NSLog(@"did swipe right");
}
- (void)swipeableView: (ZLSwipeableView *)swipeableView swipingView:(UIView *)view atLocation:(CGPoint)location {
    NSLog(@"swiping at location: x %f, y%f", location.x, location.y);
}

#pragma mark - ZLSwipeableViewDataSource
- (UIView *)nextViewForSwipeableView:(ZLSwipeableView *)swipeableView {
    
    if (_showNumberArray.count == 0)
    {
        return nil;
    }
    
    if (_countIndex < [[_showNumberArray objectAtIndex:_showCont] count]) {
        CardView *view = [[CardView alloc] initWithFrame:swipeableView.bounds];
        view.activityTypeUuid = _detailsData.activityTypeUuid;
        view.cardColor = [UIColor whiteColor];
        view.delegate = self;
        LKBettingData *data = [[_showNumberArray objectAtIndex:_showCont] objectAtIndex:_countIndex];
        if ([_selectArray containsObject:data])
        {
            data.isSelect = YES;
        }
        [view updateWith:_detailsData.activityName withTime:_timeLabel WithBettingData:data];
        _countIndex++;
        return view;
    }else{
        
        NSInteger count = 0;
        if (_bettingModel.listData.count%10 > 0)
        {
            count = _bettingModel.listData.count/10+1;
        }else{
            count = _bettingModel.listData.count/10;
        }
        
        if (_showCont+1 >= count)
        {
            _showCont = 0;
        }else{
            _showCont += 1;
        }
        _conetnLabel.text = [NSString stringWithFormat:@"%lu-%lu",(unsigned long)(_showCont*10+1), (unsigned long)((_bettingModel.listData.count<10?_bettingModel.listData.count:(_showCont*10+[[_showNumberArray objectAtIndex:_showCont] count])))];
        _countIndex = 0;
        [_swipeableView discardAllSwipeableViews];
        [_swipeableView loadNextSwipeableViewsIfNeeded];
        return nil;
    }

}

#pragma mark - CardViewDelegate
- (void)selectButtonInsideWithBettingData:(LKBettingData *)data withBool:(BOOL)isSelectd
{
    if (isSelectd) {
        if ([_selectArray containsObject:data]) {
            return;
        }
        [_selectArray addObject:data];
        [_toButton setTitle:[NSString stringWithFormat:@"提交(%lu)", (unsigned long)_selectArray.count] forState:UIControlStateNormal];
    }else{
        for (int i = 0; i < _selectArray.count; i++) {
            LKBettingData *betData = [_selectArray objectAtIndex:i];
            if ([betData.code isEqualToString:data.code]) {
                [_selectArray removeObjectAtIndex:i];
                [_toButton setTitle:[NSString stringWithFormat:@"提交(%lu)", (unsigned long)_selectArray.count] forState:UIControlStateNormal];
                break;
            }
        }
    }
}

#pragma mark - 数据
- (void)update:(id)data msgID:(int)msgid faildCode:(EDataStatusCode)errCode
{
    _bettingModel = [self.controller getModelFromListByName:@"LKBettingModel"];
    [ShowTipsView hideHUDWithView:self.view];
    if (errCode == eDataCodeSuccess) {
        if (msgid == 1000) {
            if (_bettingModel.listData > 0) {
                [self showPlaceholderView:@"" boolWith:NO];
                
                _showCont = 0;
                if (_bettingModel.listData.count%10 > 0)
                {
                    _showCont = _bettingModel.listData.count/10+1;
                }else{
                    _showCont = _bettingModel.listData.count/10;
                }
                
                for (int i = 0; i < _showCont; i++) {
                    NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:0];
                    for (int j = 0; j < 10; j++) {
                        if (i*10+j >= _bettingModel.listData.count) {
                            break;
                        }
                        [arr addObject:[_bettingModel.listData objectAtIndex:i*10+j]];
                    }
                    [_showNumberArray addObject:arr];
                }
                _showCont = 0;
                [self addView];
            }else{
                //[self.navigationView removeRightBtn];
                [self showPlaceholderView:@"已经被抢光了－－!" boolWith:YES];
            }
        }else{
            _selectdCount = _selectArray.count;
            
            if (_bettingModel.failureListData.count > 0) {
                _selectdCount = _selectdCount - _bettingModel.failureListData.count;
                for (NSString *uuCode in _bettingModel.failureListData)
                {
                    for (LKBettingData *data in _bettingModel.listData) {
                        if ([data.code isEqualToString:uuCode])
                        {
                            [_bettingModel.listData removeObject:data];
                            break;
                        }
                    }
                    for (LKBettingData *selectData in _selectArray)
                    {
                        if ([selectData.code isEqualToString:uuCode])
                        {
                            [_selectArray removeObject:selectData];
                            break;
                        }
                    }
                }
                
                NSString *str = [_bettingModel.failureListData componentsJoinedByString:@"\n"];
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"锁定失败号码" message:str delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alertView show];
            }else{
                if (_selectdCount == 0)
                {
                    return;
                }
                [ShowTipsView showHUDWithMessage:@"号码已经锁定，请尽快进行支付" andView:self.view];
                [self pushPageWithName:@"LKPayViewPage" animation:YES withParams:@{@"detailsData":_detailsData, @"selectArray":_selectArray}];
            }
        }
    }else{
        [ShowTipsView showHUDWithMessage:@"网络异常，请稍后再试" andView:self.view];
        if (msgid == 1000)
        {
            //[self.navigationView removeRightBtn];
            [self showPlaceholderView:@"网络异常加载数据失败" boolWith:YES];
        }
    }
    
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (_selectdCount == 0)
    {
        return;
    }
    [self pushPageWithName:@"LKPayViewPage" animation:YES withParams:@{@"detailsData":_detailsData, @"selectArray":_selectArray}];
}

@end
