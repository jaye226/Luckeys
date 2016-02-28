//
//  LKPayViewPage.m
//  Luckeys
//
//  Created by lishaowei on 15/11/26.
//  Copyright © 2015年 Luckeys. All rights reserved.
//

#import "LKPayViewPage.h"
#import "LKPayManger.h"
#import "LKPayTableViewCell.h"
#import "LKPayWalletTableViewCell.h"
#import "LKPayData.h"
#import "Order.h"
#import "LKDetailsData.h"
#import "LKBettingData.h"
#import "LKPayModel.h"
#import "LKDetailsViewPage.h"

#define paySuccess 10005

@interface LKPayViewPage () <UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    UIView *_headView;
    UILabel *_nameLabel;
    UIImageView *_imageView;
    UILabel *_timeLabel;
    UILabel *_numberLabel;
    
    NSInteger _selectdPay;//0支付宝  1银联   2微信
    
    LKPayData *_payData;
    
    LKDetailsData *_detailsData;//商品

    NSMutableArray *_selectArray;
    
    LKPayModel *_payModel;
    
    UIButton *_toButton;
}

@end

@implementation LKPayViewPage

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self registController:@"LKPayController"];
    }
    return self;
}

- (void)initWithParam:(NSDictionary *)paramInfo
{
    if (paramInfo.allKeys.count)
    {
        _payData=[paramInfo objectForKey:@"order"];
        _selectArray = [paramInfo objectForKey:@"selectArray"];
        _detailsData = [paramInfo objectForKey:@"detailsData"];
        
        self.selectArray = [NSArray arrayWithArray:_selectArray];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"支付订单";
    
    _selectdPay = -1;
    
    [self.view setBackgroundColor:UIColorRGB(0xf0f0f0)];
        
    [self addView];
    
    _payModel = [self.controller getModelFromListByName:@"LKPayModel"];
    
}

- (void)addRightButton
{
    [self.navigationView addRightButtonTitleWith:@"支付" titleColorWith:[UIColor blackColor] selectdColorWith:nil fontWith:[UIFont systemFontOfSize:FontOfScale(15)]];
}

- (void)addView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, UI_IOS_WINDOW_WIDTH, UI_IOS_WINDOW_HEIGHT-64-BoundsOfScale(45)) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UI_IOS_WINDOW_WIDTH, BoundsOfScale(230))];
    _headView.backgroundColor = [UIColor clearColor];
    _tableView.tableHeaderView = _headView;
    
    [self addHeadView];
    
    _toButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _toButton.frame = CGRectMake(0, UI_IOS_WINDOW_HEIGHT-BoundsOfScale(45), UI_IOS_WINDOW_WIDTH, BoundsOfScale(45));
    [_toButton setBackgroundImage:[UIColor createImageWithColor:UIColorRGB(0xff664d)] forState:UIControlStateNormal];
    [_toButton setTitleColor:UIColorRGB(0xffffff) forState:UIControlStateNormal];
    [_toButton setTitle:@"提交" forState:UIControlStateNormal];
    _toButton.titleLabel.font = [UIFont systemFontOfSize:FontOfScale(16)];
    [self.view addSubview:_toButton];
    [_toButton addTarget:self action:@selector(submitInside) forControlEvents:UIControlEventTouchUpInside];
}

- (void)addHeadView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(BoundsOfScale(20), BoundsOfScale(20), UI_IOS_WINDOW_WIDTH-BoundsOfScale(40), BoundsOfScale(190))];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 10;
    [_headView addSubview:view];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(BoundsOfScale(18), BoundsOfScale(10), _headView.width-BoundsOfScale(18)*2, 30)];
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.font = [UIFont systemFontOfSize:FontOfScale(18)];
    _nameLabel.textColor = UIColorRGB(0x333333);
    _nameLabel.text = _detailsData.activityTypeName;
    [view addSubview:_nameLabel];
        
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, _nameLabel.maxY, view.width, BoundsOfScale(110))];
    switch ([_detailsData.activityTypeUuid integerValue]) {
        case 1:
        {
            _imageView.image = [UIImage imageNamed:@"card_movie"];
            break;
        }
        case 2:
        {
            _imageView.image = [UIImage imageNamed:@"card_food"];
            break;
        }
        case 3:
        {
            _imageView.image = [UIImage imageNamed:@"card_ative"];
            break;
        }
        case 4:
        {
            _imageView.image = [UIImage imageNamed:@"card_book"];
            break;
        }
        case 5:
        {
            _imageView.image = [UIImage imageNamed:@"card_other"];
            break;
        }
        default:
            break;
    }    [view addSubview:_imageView];
        
    UILabel *numberLable = [[UILabel alloc] initWithFrame:CGRectMake(BoundsOfScale(20), BoundsOfScale(30), _headView.width-BoundsOfScale(24)*2, BoundsOfScale(20))];
    numberLable.backgroundColor = [UIColor clearColor];
    numberLable.textColor = [UIColor whiteColor];
    numberLable.font = [UIFont boldSystemFontOfSize:FontOfScale(16)];
    numberLable.text = @"抽奖券";
    [_imageView addSubview:numberLable];
        
    _numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(BoundsOfScale(20), numberLable.maxY+BoundsOfScale(15), _headView.width-BoundsOfScale(20)-BoundsOfScale(10), BoundsOfScale(30))];
    _numberLabel.backgroundColor = [UIColor clearColor];
    _numberLabel.textColor = [UIColor whiteColor];
    _numberLabel.font = [UIFont boldSystemFontOfSize:FontOfScale(30)];
    _numberLabel.text = [NSString stringWithFormat:@"x%lu",(unsigned long)[_selectArray count]];
    [_imageView addSubview:_numberLabel];
        
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(BoundsOfScale(10), _imageView.maxY, view.width-BoundsOfScale(20), view.height-_imageView.maxY)];
    _timeLabel.backgroundColor = [UIColor clearColor];
    _timeLabel.textColor = UIColorRGB(0x999999);
    _timeLabel.font = [UIFont systemFontOfSize:FontOfScale(13)];
    _timeLabel.text = [NSString stringWithFormat:@"订单金额：%ld元", [_detailsData.unitPrice integerValue]*[_selectArray count]];
    [view addSubview:_timeLabel];
}

- (void)submitInside
{
    if (_selectdPay == -1) {
        [ShowTipsView showHUDWithMessage:@"请选择支付类型" andView:self.view];
        return;
    }
    switch (_selectdPay) {
        case PayType_Weixin:{
            if (_payModel.payData)
            {
                LKPayManger *payManger = [LKPayManger sharedManager];
                [payManger payMent:_selectdPay goods:_payModel.payData];
                payManger.delegate = self;
                return;
            }
            [ShowTipsView showLoadHUDWithMSG:@"生成订单中..." andView:self.view];
            [self requestWXOrder];
            break;
        }
        case PayType_Ali:{
            if (_payModel.aliPayData) {
                _payModel.aliPayData.activityName = _detailsData.activityName;
                _payModel.aliPayData.descri = _detailsData.descri;
                LKPayManger *payManger = [LKPayManger sharedManager];
                [payManger payMent:_selectdPay goods:_payModel.aliPayData];
                payManger.delegate = self;
                return;
            }
            [ShowTipsView showLoadHUDWithMSG:@"生成订单中..." andView:self.view];
            [self requestAliOrder];
            //[[LKPayManger sharedManager] payMent:_selectdPay goods:[self alipayOrder]];
            break;
        }
        case PayType_Union:
            //[self unionPay:model];
            break;
        default:
            break;
    }
}

//生成随机订单号(alipay)
- (NSString *)generateTradeNO
{
    static int kNumber = 15;
    
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand(time(0));
    for (int i = 0; i < kNumber; i++)
    {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}
//微信订单请求
- (void)requestWXOrder
{
    
    NSMutableDictionary *body = [[NSMutableDictionary alloc] initWithCapacity:0];
    NSMutableArray *arry = [[NSMutableArray alloc] initWithCapacity:0];
    for (LKBettingData *data in _selectArray)
    {
        [arry addObject:data.codeUuid];
    }
    [body setObject:_detailsData.activityUuid forKey:@"activityUuid"];
    [body setObject:arry forKey:@"listCodeUuid"];
    [body setObject:[[LKShareUserInfo share] userInfo].userUuid forKey:@"userUuid"];
    [body setObject:_detailsData.activityName forKey:@"activityName"];
    [body setObject:_detailsData.descri forKey:@"description"];
    [body setObject:_detailsData.unitPrice forKey:@"unitPrice"];
    [body setObject:@"Sign=WXPay" forKey:@"wxPackage"];
    [body setObject:[NSString stringWithFormat:@"%lu", (unsigned long)[_selectArray count]] forKey:@"bets"];
    [body setObject:@"weixin" forKey:@"payType"];

    [self.controller sendMessageID:kWXPayRequestTag messageInfo:@{kRequestUrl:kUrl_PrepaidOrders,kRequestBody:body}];
}
//支付宝订单请求
- (void)requestAliOrder
{
    
    NSMutableDictionary *body = [[NSMutableDictionary alloc] initWithCapacity:0];
    NSMutableArray *arry = [[NSMutableArray alloc] initWithCapacity:0];
    for (LKBettingData *data in _selectArray)
    {
        [arry addObject:data.codeUuid];
    }
    [body setObject:_detailsData.activityUuid forKey:@"activityUuid"];
    [body setObject:arry forKey:@"listCodeUuid"];
    [body setObject:[[LKShareUserInfo share] userInfo].userUuid forKey:@"userUuid"];
    [body setObject:_detailsData.activityName forKey:@"activityName"];
    [body setObject:_detailsData.descri forKey:@"description"];
    [body setObject:_detailsData.unitPrice forKey:@"unitPrice"];
    [body setObject:[NSString stringWithFormat:@"%lu", (unsigned long)[_selectArray count]] forKey:@"bets"];
    [body setObject:@"ali" forKey:@"payType"];

    [self.controller sendMessageID:kAliPayRequestTag messageInfo:@{kRequestUrl:kUrl_PrepaidOrders,kRequestBody:body}];

    
}
//银联订单请求
- (void)requestUnionOrder
{
    
}

//微信支付回调
- (void)managerDidRecvPayResponse:(PayResp *)response{
    switch(response.errCode){
        case WXSuccess:
        {
            //服务器端查询支付通知或查询API返回的结果再提示成功
            NSLog(@"支付成功");

//            NSDictionary *body = @{@"prepayId":STR_IS_NULL(_payModel.payData.prepay_id),@"activityUuid":STR_IS_NULL(_detailsData.activityUuid)};
//            [self.controller sendMessageID:kWXPaySuccess messageInfo:@{kRequestUrl:kUrl_PaySuccess,kRequestBody:body}];
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotiLKBettingSuccessNotification object:nil];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"支付成功" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            alertView.tag = paySuccess;
            [alertView show];
            break;
        }
        default:
        {
            NSLog(@"支付失败，retcode=%d",response.errCode);
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"支付失败" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertView show];
            break;
        }
    }
}

- (void)managerDidRecvAlipayResponse:(BOOL )isAlipay
{
    if (isAlipay)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotiLKBettingSuccessNotification object:nil];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"支付成功" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        alertView.tag = paySuccess;
        [alertView show];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"支付失败" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
    }
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        static NSString * cellId = @"Cell";
        LKPayWalletTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[LKPayWalletTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    }else{
        static NSString * cellId = @"LKPayTableViewCell";
        LKPayTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[LKPayTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [cell updateCell:indexPath.row-1 showIcon:(indexPath.row-1==_selectdPay)?YES:NO];
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return BoundsOfScale(50);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row != 0) {
        _selectdPay = indexPath.row-1;
        [_tableView reloadData];
    }
    
}
#pragma mark - 数据
- (void)update:(id)data msgID:(int)msgid faildCode:(EDataStatusCode)errCode
{
    [ShowTipsView hideHUDWithView:self.view];

    if (errCode == eDataCodeSuccess)
    {
        if ([_payModel.isTimeOut integerValue] == 1)
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"号码已过期，生成订单失败" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            alertView.tag = 10002;
            [alertView show];
            return;
        }
        if (msgid == kWXPayRequestTag)
        {
            LKPayManger *payManger = [LKPayManger sharedManager];
            [payManger payMent:_selectdPay goods:_payModel.payData];
            payManger.delegate = self;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotiLKOrderSuccessNotification object:nil];
        }
        else if (msgid == kAliPayRequestTag)
        {
            _payModel.aliPayData.activityName = _detailsData.activityName;
            _payModel.aliPayData.descri = _detailsData.descri;
            LKPayManger *payManger = [LKPayManger sharedManager];
            [payManger payMent:_selectdPay goods:_payModel.aliPayData];
            payManger.delegate = self;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotiLKOrderSuccessNotification object:nil];
        }
        else
        {
            
        }
    }
    else
    {
        if (msgid == kWXPaySuccess)
        {
            return;
        }
        [ShowTipsView showHUDWithMessage:@"生成订单失败" andView:self.view];
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 10002)
    {
        [self popViewPageAnimated:YES];
    }else if (alertView.tag == paySuccess){
        for (int i = 0; i < self.navigationController.viewControllers.count; i++) {
            if ([[self.navigationController.viewControllers objectAtIndex:i] isKindOfClass:[LKDetailsViewPage class]]) {
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:i] animated:YES];
            }
        }
    }
}

@end
