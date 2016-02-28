//
//  LKRightViewPage.m
//  Luckeys
//

//  Created by lishaowei on 15/10/31.
//  Copyright © 2015年 Luckeys. All rights reserved.
//

#import "LKRightViewPage.h"
#import "LKLoginHomeViewPage.h"
#import "UIImageView+WebCache.h"

@interface LKRightViewPage () <UITableViewDataSource, UITableViewDelegate,UIAlertViewDelegate>
{
    UITableView *_tableView;
    UIImageView *_backgroundImageView;
    UIImageView *_headImageView;
    UILabel *_nameLabel;
}
@end

@implementation LKRightViewPage

- (void)dealloc
{
    _tableView.dataSource = nil;
    _tableView.delegate = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self hiddenNavgationView];
    
    self.view.backgroundColor = [UIColor whiteColor];

    [self addView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeHeadImageNotificationCenter:) name:kNotiChangeHeadImage object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeUserInfoNotificationCenter:) name:kNotiChangeUserInfo object:nil];    
}

- (void)addView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, UI_IOS_WINDOW_WIDTH-kRightXOffSet, UI_IOS_WINDOW_HEIGHT-BoundsOfScale(49)) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    LKShareUserInfo *userInfo = [LKShareUserInfo share];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _tableView.width, BoundsOfScale(170))];
    _tableView.tableHeaderView = view;
    [view setUserInteractionEnabled:YES];
    
    _backgroundImageView = [[UIImageView alloc] initWithFrame:view.bounds];
    [_backgroundImageView setContentMode:UIViewContentModeScaleAspectFill];
    _backgroundImageView.clipsToBounds = YES;
    _backgroundImageView.image = [UIImage imageWithName:@"moren"];
    [view addSubview:_backgroundImageView];
    
    _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake((_backgroundImageView.width-BoundsOfScale(70))/2, BoundsOfScale(50), BoundsOfScale(70), BoundsOfScale(70))];
    _headImageView.image = [UIImage imageNamed:@"moren"];
    _headImageView.layer.cornerRadius = CGRectGetMidX(_headImageView.bounds);
    _headImageView.layer.masksToBounds = YES;
    [_headImageView setContentMode:UIViewContentModeScaleAspectFill];
    _headImageView.clipsToBounds = YES;
    [view addSubview:_headImageView];
    [_headImageView setUserInteractionEnabled:YES];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHeadUpInside)];
    [_headImageView addGestureRecognizer:tapGestureRecognizer];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _headImageView.maxY, view.width, view.height-_headImageView.maxY)];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.textColor = UIColorRGB(0xfffff1);
    _nameLabel.font = [UIFont systemFontOfSize:FontOfScale(16)];
    if (userInfo.userInfo.nickName.length <= 0) {
        _nameLabel.text = userInfo.userInfo.userName;
    }else{
        _nameLabel.text = userInfo.userInfo.nickName;
    }
    [view addSubview:_nameLabel];
    
    UIView *buttomView = [[UIView alloc] initWithFrame:CGRectMake(0, _tableView.maxY, UI_IOS_WINDOW_WIDTH-kRightXOffSet, BoundsOfScale(49))];
    buttomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:buttomView];
    [buttomView setUserInteractionEnabled:YES];
    
    UIButton *bottom = [UIButton buttonWithType:UIButtonTypeCustom];
    bottom.frame = buttomView.bounds;
    [buttomView addSubview:bottom];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(BoundsOfScale(24), 0, BoundsOfScale(150), BoundsOfScale(49))];
    label.text = @"退出";
    label.textColor = UIColorRGB(0x666666);
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:FontOfScale(16)];
    //[buttomView addSubview:label];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(buttomView.width-BoundsOfScale(21)-BoundsOfScale(20), (buttomView.height-BoundsOfScale(20))/2, BoundsOfScale(20), BoundsOfScale(20))];
    imageView.image = [UIImage imageNamed:@"ic_out"];
    [buttomView addSubview:imageView];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = buttomView.bounds;
    backButton.x = buttomView.width-BoundsOfScale(21)-BoundsOfScale(20);
    [buttomView addSubview:backButton];
    [backButton addTarget:self action:@selector(logoutAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self setHeadImage];
}

- (void)changeUserInfoNotificationCenter:(NSNotification *)notification
{
    LKShareUserInfo *userInfo = [LKShareUserInfo share];
    if (userInfo.userInfo.nickName.length <= 0) {
        _nameLabel.text = userInfo.userInfo.userName;
    }else{
        _nameLabel.text = userInfo.userInfo.nickName;
    }
}

- (void)changeHeadImageNotificationCenter:(NSNotification *)notification
{
    [self setHeadImage];
}

- (void)changeBackImageNotificationCenter:(NSNotification *)notification
{
    __weak UIImageView * backImage = _backgroundImageView;
    [_backgroundImageView setImageUrl:[NSString stringWithFormat:@"http://%@%@",SeverHost,[[LKShareUserInfo share] userInfo].backImage] placeholderImage:[UIImage imageWithName:@"moren"] complete:^(UIImage *image) {
        backImage.image = [image boxblurImageWithBlur:1];
    }];
}

- (void) setHeadImage {
    
    NSString *userImage = [NSString stringWithFormat:@"http://%@%@",SeverHost,[[LKShareUserInfo share] userInfo].userHead];
    
    __weak UIImageView * backImage = _backgroundImageView;
    [_headImageView setImageUrl:userImage placeholderImage:[UIImage imageWithName:@"moren"] complete:^(UIImage *image) {
        backImage.image = [image boxblurImageWithBlur:1];
    }];
}
//退出
- (void)logoutAction
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"确定要退出登录吗" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults removeObjectForKey:@"PassWord"];
        [userDefaults synchronize];
        
        [LKShareUserInfo share].isLogin = NO;
        [LKShareUserInfo share].userInfo = nil;
        SliderViewController * slider = [SliderViewController shareSliderVC];
        [slider hiddenController];
        [self popToRootViewPageAnimated:NO];
        [slider clearViewsWithTab:YES];
    }
}

//点击头像跳转
- (void)tapHeadUpInside
{
    [self pushPageWithName:@"LKMyTabViewPage" withParams:@{@"uuid":STR_IS_NULL([LKShareUserInfo share].userInfo.userUuid)}];
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

#pragma mark - UITableViewDataSource
//上提回弹，下拉取消回弹
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_tableView.contentOffset.y <= 0)
    {
        _tableView.bounces = NO;
        [_tableView setContentOffset:CGPointMake(0, 0) animated:NO];
    }else{
        _tableView.bounces = YES;
    }
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return BoundsOfScale(40);
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellId = @"TypeListCellId";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(BoundsOfScale(24), 0, UI_IOS_WINDOW_WIDTH-kRightXOffSet-BoundsOfScale(24), BoundsOfScale(40))];
        lable.backgroundColor = [UIColor clearColor];
        lable.textAlignment = NSTextAlignmentLeft;
        lable.textColor = UIColorRGB(0x333333);
        lable.font = [UIFont systemFontOfSize:FontOfScale(16)];
        lable.tag = 10000;
        [cell.contentView addSubview:lable];
    }
    
    UILabel *nameLabel = (UILabel *)[cell.contentView viewWithTag:10000];
    switch (indexPath.row) {
        case 0:
        {
            nameLabel.text = @"钱包";
            break;
        }
        case 1:
        {
            nameLabel.text = @"订单";
            break;
        }
        case 2:
        {
            nameLabel.text = @"优惠";
            break;
        }
        case 3:
        {
            nameLabel.text = @"通知";
            break;
        }
        case 4:
        {
            nameLabel.text = @"帮助";
            break;
        }
        case 5:
        {
            nameLabel.text = @"关于";
            break;
        }
        case 6:
        {
            nameLabel.text = @"设置";
            break;
        }
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    switch (indexPath.row) {
        case 0:
        {
            //钱包
            [self pushPageWithName:@"LKWalletViewPage"];
            break;
        }
        case 1:
        {
            //订单
            [self pushPageWithName:@"LKNotOrderViewPage"];
            break;
        }
        case 2:
        {
            //优惠
            [self pushPageWithName:@"LKPreferentialViewPage"];
            break;
        }
        case 3:
        {
            
            break;
        }
        case 4:
        {
            
            break;
        }
        case 5:
        {
            //关于
            [self pushPageWithName:@"LKAboutViewPage"];
            break;
        }
        case 6:
        {
            //设置
            [self pushPageWithName:@"LKSettingViewPage"];
            break;
        }
        default:
            break;
    }
}

@end
