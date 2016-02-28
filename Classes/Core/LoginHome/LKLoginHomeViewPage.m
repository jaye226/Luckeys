//
//  LKLoginHomeViewPage.m
//  Luckeys
//
//  Created by lishaowei on 15/9/19.
//  Copyright © 2015年 Luckeys. All rights reserved.
//

#import "LKLoginHomeViewPage.h"

@interface LKLoginHomeViewPage () <UITabBarControllerDelegate>
{
    UIImageView *_backgroundImageVIew;
    UIImageView *_logo;
}


@end

@implementation LKLoginHomeViewPage

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self hiddenNavgationView];
    
    _backgroundImageVIew = [[UIImageView alloc] initWithFrame:self.view.bounds];
    _backgroundImageVIew.image = [UIImage imageNamed:@"login_home_bg"];
    [_backgroundImageVIew setContentMode:UIViewContentModeScaleAspectFill];
    _backgroundImageVIew.clipsToBounds = YES;
    [self.view addSubview:_backgroundImageVIew];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *nameString = [userDefaults objectForKey:@"NameString"];
    NSString *passWord = [userDefaults objectForKey:@"PassWord"];
    if ([nameString length]>0 && [passWord length]>0) {
        [self addContentView];
        [self pushPageWithName:@"LKLoginViewPage" animation:NO];
    }else {
        [self addView];
    }
}

- (void)addView
{
//    if (iPhone5 || IS_IPHONE_6 || IS_IPHONE_6P)
//    {
//        NSMutableArray *arry = [[NSMutableArray alloc] initWithCapacity:0];
//        for (int i = 0; i < 78; i++)
//        {
//            [arry addObject:[UIImage imageNamed:[NSString stringWithFormat:@"bg_%d",i]]];
//        }
//        
//        _logo = [[UIImageView alloc] initWithFrame:self.view.bounds];
//        [_logo setContentMode:UIViewContentModeScaleAspectFill];
//        _logo.clipsToBounds = YES;
//        _logo.y = _logo.y-BoundsOfScale(40);
//        [_logo setAnimationImages:arry];
//        [_logo setAnimationDuration:5];
//        [_logo setAnimationRepeatCount:1];
//        [_logo startAnimating];
//        [self.view addSubview:_logo];
//        [self performSelector:@selector(didAnimate) withObject:nil afterDelay:3.2];
//    }
//    else
//    {
        [self addContentView];
//    }
}

- (void)didAnimate
{
    [_logo stopAnimating];
    [self addContentView];
}

- (void)addContentView
{
    UIImageView *logo = [[UIImageView alloc] initWithFrame:self.view.bounds];
    logo.y = logo.y-BoundsOfScale(40);
    [logo setContentMode:UIViewContentModeScaleAspectFill];
    logo.clipsToBounds = YES;
    logo.image = [UIImage imageNamed:@"bg_77"];
    [self.view addSubview:logo];
    
    UIButton *createButton = [UIButton buttonWithType:UIButtonTypeCustom];
    createButton.frame = CGRectMake(12, CGRectGetHeight(self.view.bounds)-180, CGRectGetWidth(self.view.bounds)-24, 45);
    [createButton setBackgroundImage:[UIImage imageScaleNamed:@"login_btn_normal_bg#5_6_5_6#"] forState:UIControlStateNormal];
    createButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [createButton setTitle:@"创建账号" forState:UIControlStateNormal];
    [createButton setTitleColor:UIColorRGB(0xffffff) forState:UIControlStateNormal];
    createButton.tag = 100;
    [self.view addSubview:createButton];
    [createButton addTarget:self action:@selector(buttonStateChange:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    loginButton.frame = CGRectMake(12, CGRectGetHeight(self.view.bounds)-120, CGRectGetWidth(self.view.bounds)-24, 45);
    [loginButton setBackgroundImage:[UIImage imageScaleNamed:@"registere_btn_bg#5_6_5_6#"] forState:UIControlStateNormal];
    loginButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [loginButton setTitleColor:UIColorRGB(0xf85347) forState:UIControlStateNormal];
    loginButton.tag = 101;
    [self.view addSubview:loginButton];
    [loginButton addTarget:self action:@selector(buttonStateChange:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *guangButton = [UIButton buttonWithType:UIButtonTypeCustom];
    guangButton.frame = CGRectMake(12, CGRectGetHeight(self.view.bounds)-75, CGRectGetWidth(self.view.bounds)-24, 45);
    //[guangButton setBackgroundImage:[UIImage imageScaleNamed:@"registere_btn_bg#5_6_5_6#"] forState:UIControlStateNormal];
    guangButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [guangButton setTitle:@"逛一逛" forState:UIControlStateNormal];
    [guangButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];//UIColorRGB(0xf85347)
    guangButton.tag = 102;
    [self.view addSubview:guangButton];
    [guangButton addTarget:self action:@selector(buttonStateChange:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)buttonStateChange:(UIButton *)button
{
    if (button.tag == 100) {    //创建账号
        [self pushPageWithName:@"LKRegistereViewPage" animation:YES];
    }else if (button.tag == 101){  //登录
        [self pushPageWithName:@"LKLoginViewPage" animation:YES];
    }else{//逛一逛
        
        //by change jaye
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
                                                                           kTabItemTitle:@"圈子"},
                                                                         @{kTabItemNorImage:@"ic_user_normal",
                                                                           kTabItemSelImage:@"ic_user_on",
                                                                           kTabItemTitle:@"我的"}
                                                                         ]];
        UIPATabBarController * tab = [[UIPATabBarController alloc] initTabPages:pageArrays items:tabBarButtons];
        tab.delegate = self;
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
        [self.navigationController pushViewController:slider animated:YES];
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

@end
