//
//  LKLoadingViewPage.m
//  Luckeys
//
//  Created by lishaowei on 15/12/1.
//  Copyright © 2015年 Luckeys. All rights reserved.
//

#import "LKLoadingViewPage.h"
#import "LKLoginMsgModel.h"

#define kActivityViewCenterY  270

@interface LKLoadingViewPage ()
{
    UIActivityIndicatorView *_activity;
    UILabel *_loadingStatelbl;
    
    NSString *_nameString;
    NSString *_passwordString;
    
    BOOL _isAutoLogin;
}
@end

@implementation LKLoadingViewPage


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self registController:@"LKLoginMsgController"];
    }
    return self;
}

- (void)initWithParam:(NSDictionary *)paramInfo
{
    if (paramInfo.allKeys.count)
    {
        _nameString = paramInfo[@"NameString"];
        _passwordString = paramInfo[@"PassWord"];
        _isAutoLogin = [paramInfo[@"AutoLogin"] boolValue];
        self.isGVC = [paramInfo[@"isGVC"] boolValue];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_activity stopAnimating];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self hiddenNavgationView];
    
    [self addView];
    
    if (_isAutoLogin)
    {
        [self autoLogin];
    }
    else
    {
        [self login];
    }
}

- (void)addView
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [imageView setContentMode:UIViewContentModeScaleAspectFill];
    imageView.clipsToBounds = YES;
    imageView.image = [UIImage imageWithName:@"loadingBG"];
    [self.view addSubview:imageView];
    
    _activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    if (UI_IOS_WINDOW_HEIGHT < 568)
    {
        _activity.center = CGPointMake(UI_IOS_WINDOW_WIDTH/2,kActivityViewCenterY - 50);
    }
    else
    {
        if (iPhone5)
        {
            _activity.center = CGPointMake(UI_IOS_WINDOW_WIDTH/2,kActivityViewCenterY-20);
        }
        else if (IS_IPHONE_6)
        {
            _activity.center = CGPointMake(UI_IOS_WINDOW_WIDTH/2,kActivityViewCenterY);
        }
        else
        {
            _activity.center = CGPointMake(UI_IOS_WINDOW_WIDTH/2,kActivityViewCenterY+20);
        }
    }
    [_activity startAnimating];
    [self.view addSubview:_activity];

    _loadingStatelbl = [[UILabel alloc]initWithFrame:CGRectZero];
    if (UI_IOS_WINDOW_HEIGHT < 568) {
        [_loadingStatelbl setFrame:CGRectMake(0, 235, UI_IOS_WINDOW_WIDTH, 20)];
    }else{
        if (iPhone5) {
            [_loadingStatelbl setFrame:CGRectMake(0, 265, UI_IOS_WINDOW_WIDTH, 20)];
        }else if (IS_IPHONE_6){
            [_loadingStatelbl setFrame:CGRectMake(0, 295, UI_IOS_WINDOW_WIDTH, 20)];
        }else{
            [_loadingStatelbl setFrame:CGRectMake(0, 325, UI_IOS_WINDOW_WIDTH, 20)];
        }
            
    }
    [_loadingStatelbl setTextColor:[UIColor whiteColor]];
    _loadingStatelbl.text=@"登陆中...";
    [_loadingStatelbl setFont:[UIFont systemFontOfSize:14]];
    [_loadingStatelbl setBackgroundColor:[UIColor clearColor]];
    [_loadingStatelbl setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:_loadingStatelbl];
}

- (void)autoLogin
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * url = [NSString stringWithFormat:@"%@userName=%@&password=%@",kURL_Login,[userDefaults objectForKey:@"NameString"],[userDefaults objectForKey:@"PassWord"]];
    [self.controller sendMessageID:999 messageInfo:@{kRequestUrl:url}];
}

- (void)login
{
    NSString * url = [NSString stringWithFormat:@"%@userName=%@&password=%@",kURL_Login,_nameString,_passwordString];
    [self.controller sendMessageID:999 messageInfo:@{kRequestUrl:url}];
}

- (void)gotoMainViewPage
{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotiLKLoginSuccessNotification object:nil];
    
    NSArray *pageArrays = @[@"LKHomeViewPage",@"LKHistoryViewPage",@"LKShareViewPage"
                            ,@"LKRightViewPage"
                            ];
    
    NSMutableArray *tabBarButtons = [NSMutableArray arrayWithArray:@[
                                                                     @{kTabItemNorImage:@"ic_home_normla",
                                                                       kTabItemSelImage:@"ic_home",
                                                                       kTabItemTitle:@"首页"},
                                                                     @{kTabItemNorImage:@"ic_history_normal",
                                                                       kTabItemSelImage:@"ic_history_on",
                                                                       kTabItemTitle:@"历史"},
                                                                     @{kTabItemNorImage:@"ic_collec_normal",
                                                                       kTabItemSelImage:@"ic_collec_on",
                                                                       kTabItemTitle:@"分享"},
                                                                     @{kTabItemNorImage:@"ic_user_normal",
                                                                       kTabItemSelImage:@"ic_user_on",
                                                                       kTabItemTitle:@"我的"}
                                                                     ]];
    UIPATabBarController * tab = [[UIPATabBarController alloc] initTabPages:pageArrays items:tabBarButtons];
    
    UIViewController * leftVC;
    Class leftClass = NSClassFromString(@"LKAllTypesViewPage");
    if (leftClass) {
        leftVC = [[leftClass alloc] init];
    }
    
    UIViewController * rightVC;
    Class rightClass = NSClassFromString(@"LKRightViewPage");
    if (rightClass) {
        rightVC = [[rightClass alloc] init];
    }
    
    SliderViewController * slider = [SliderViewController shareSliderVC];
    slider.mainController = tab;
    slider.leftController = (UIViewController*)leftVC;
    slider.rightController = rightVC;
    slider.sldierTabbar = tab;
    tab.delegate = slider;
    if (self.isGVC)
    {
        for (int i = 0; i < self.navigationController.viewControllers.count; i++) {
            if ([[self.navigationController.viewControllers objectAtIndex:i] isKindOfClass:[SliderViewController class]]) {
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:i] animated:YES];
            }
        }
    }else{
        [self.navigationController pushViewController:slider animated:YES];
    }
}

#pragma mark - 数据
- (void)update:(id)data msgID:(int)msgid faildCode:(EDataStatusCode)errCode
{
    
    [ShowTipsView hideHUDWithView:self.view];
    LKLoginMsgModel * model = data;
    if (errCode == eDataCodeSuccess) {
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setValue:_nameString forKey:@"NameString"];
        [userDefaults setValue:_passwordString forKey:@"PassWord"];
        [userDefaults synchronize];
        
        [LKShareUserInfo share].isLogin = YES;
        //初始化新数据库
        [LKDBManager initDBWithUM:[LKShareUserInfo share].userInfo.userUuid];

        [self gotoMainViewPage];
        
//        NSMutableArray * array = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
//        if (array.count > 1)
//        {
//            while (array.count > 1) {
//                UIViewController * view = [array lastObject];
//                if ([view isKindOfClass:[self class]])
//                {
//                    [array removeObjectAtIndex:1];
//                }
//            }
//        }
//        [self.navigationController setViewControllers:array];
    }
    else
    {
        [ShowTipsView showHUDWithMessage:model.message.length > 0 ?model.message :kRequest_TimeOut andView:kUIWindow];
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults removeObjectForKey:@"PassWord"];
        [userDefaults synchronize];
        
        [self popViewPageAnimated:YES];
    }
    
}

@end
