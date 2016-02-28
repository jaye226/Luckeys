//
//  LKLoginViewPage.m
//  Luckeys
//
//  Created by lishaowei on 15/9/19.
//  Copyright © 2015年 Luckeys. All rights reserved.
//

#import "LKLoginViewPage.h"
#import "UIPATabBarController.h"
#import "SliderViewController.h"
#import "LKLoginMsgModel.h"

@interface LKLoginViewPage () <UITextFieldDelegate,UITabBarControllerDelegate,UITabBarDelegate>
{
    UIButton *_loginButton;
    CGFloat _loginFrameY;
    UILabel *_forgetPassWordLabel;
    
    UITextField *_nameTextField;
    UITextField *_passWordTextField;
    
    BOOL transiting;
}

@end

@implementation LKLoginViewPage

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
        self.isGVC = [paramInfo[@"isGVC"] boolValue];
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _loginFrameY = 0;
    
    [self.view setUserInteractionEnabled:YES];
    
    [self hiddenNavgationView];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizerFirstResponder)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tapGestureRecognizer];
    [self addView];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *nameString = [userDefaults objectForKey:@"NameString"];
    NSString *passWord = [userDefaults objectForKey:@"PassWord"];
    if ([nameString length]>0 && [passWord length]>0)
    {
        _nameTextField.text = nameString;
        _passWordTextField.text = passWord;
        [self pushPageWithName:@"LKLoadingViewPage" animation:NO withParams:@{@"NameString":_nameTextField.text,@"PassWord":_passWordTextField.text,@"AutoLogin":[NSNumber numberWithBool:YES]}];
    }
    else if ([nameString length]>0)
    {
        _nameTextField.text = nameString;
    }
    
}

- (void)tapGestureRecognizerFirstResponder
{
    [self textFieldResignFirstResponder];
}

- (void)addView
{
    
    UIImageView *backgroundImageVIew = [[UIImageView alloc] initWithFrame:self.view.bounds];
    backgroundImageVIew.image = [UIImage imageNamed:@"login_bg"];
    [backgroundImageVIew setContentMode:UIViewContentModeScaleAspectFill];
    backgroundImageVIew.clipsToBounds = YES;
    [self.view addSubview:backgroundImageVIew];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(10, 20, 44, 44);
    [backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -((44-CGRectGetWidth(backButton.imageView.bounds))/2), 0, 0)];
    [self.view addSubview:backButton];
    [backButton addTarget:self action:@selector(backViewControllerAnimated) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(14, 80, CGRectGetWidth(self.view.bounds)-28, 80)];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = 3;
    [self.view addSubview:bgView];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(12, 40-SINGLE_LINE_ADJUST_OFFSET, CGRectGetWidth(bgView.bounds)-24, SINGLE_LINE_BOUNDS)];
    lineView.backgroundColor = UIColorRGB(0xe1e1e1);
    [bgView addSubview:lineView];
    
    _nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(12, 12, CGRectGetWidth(bgView.bounds)-24, 20)];
    [_nameTextField setClearButtonMode:UITextFieldViewModeWhileEditing];//右侧删除按钮
    _nameTextField.placeholder=@"请输入用户名";//默认显示的字
    _nameTextField.secureTextEntry=NO;//设置成密码格式
    _nameTextField.keyboardType=UIKeyboardTypeDefault;//设置键盘类型为默认的
    _nameTextField.returnKeyType=UIReturnKeyDone;//返回键的类型
    _nameTextField.delegate= self;//设置委托
    _nameTextField.adjustsFontSizeToFitWidth=YES;//自适应宽度
    [bgView addSubview:_nameTextField];
    
    _passWordTextField = [[UITextField alloc] initWithFrame:CGRectMake(12, 50, CGRectGetWidth(bgView.bounds)-24, 20)];
    [_passWordTextField setClearButtonMode:UITextFieldViewModeWhileEditing];//右侧删除按钮
    _passWordTextField.placeholder=@"密码";//默认显示的字
    _passWordTextField.secureTextEntry=YES;//设置成密码格式
    _passWordTextField.keyboardType=UIKeyboardTypeDefault;//设置键盘类型为默认的
    _passWordTextField.returnKeyType=UIReturnKeyNext;//返回键的类型
    _passWordTextField.delegate= self;//设置委托
    _passWordTextField.adjustsFontSizeToFitWidth=YES;//自适应宽度
    [bgView addSubview:_passWordTextField];

    _loginFrameY = CGRectGetMaxY(bgView.frame)+20;
    
    _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _loginButton.frame = CGRectMake(12, _loginFrameY, CGRectGetWidth(self.view.bounds)-24, 40);
    [_loginButton setBackgroundImage:[UIImage imageScaleNamed:@"login_btn_normal_bg#5_6_5_6#"] forState:UIControlStateNormal];
    _loginButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [_loginButton setTitleColor:UIColorRGB(0xffffff) forState:UIControlStateNormal];
    _loginButton.tag = 101;
    [self.view addSubview:_loginButton];
    [_loginButton addTarget:self action:@selector(loginStateChange) forControlEvents:UIControlEventTouchUpInside];
    
    _forgetPassWordLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_loginButton.frame)+3, CGRectGetWidth(self.view.bounds), 30)];
    _forgetPassWordLabel.alpha = 0.4;
    _forgetPassWordLabel.font = [UIFont systemFontOfSize:16];
    _forgetPassWordLabel.textColor = UIColorRGB(0xfffff1);
    _forgetPassWordLabel.textAlignment = NSTextAlignmentCenter;
    _forgetPassWordLabel.text = @"忘记密码？";
    [self.view addSubview:_forgetPassWordLabel];
    [_forgetPassWordLabel setUserInteractionEnabled:YES];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizer)];
    [_forgetPassWordLabel addGestureRecognizer:tapGestureRecognizer];
}

- (void)backViewControllerAnimated
{
    [self popViewPageAnimated:YES];
}

- (void)loginStateChange
{
    [self textFieldResignFirstResponder];

//    _nameTextField.text = @"15118030209";
//    _passWordTextField.text = @"qwerty";
    if (_nameTextField.text.length == 0 || _passWordTextField.text.length == 0) {
        [ShowTipsView showHUDWithMessage:@"请输入用户名或密码" andView:self.view];
        return;
    }else if (_passWordTextField.text.length < 6) {
        [ShowTipsView showHUDWithMessage:@"密码不能少于6位" andView:self.view];
        return;
    }

    [self pushPageWithName:@"LKLoadingViewPage" animation:NO withParams:@{@"NameString":_nameTextField.text,@"PassWord":_passWordTextField.text,@"AutoLogin":[NSNumber numberWithBool:NO],@"isGVC":[NSNumber numberWithBool:self.isGVC]}];
    
//    [ShowTipsView showLoadHUDWithMSG:@"登录中" andView:self.view];
//    
//    NSString * url = [NSString stringWithFormat:@"%@userName=%@&password=%@",kURL_Login,_nameTextField.text,_passWordTextField.text];
//    [self.controller sendMessageID:999 messageInfo:@{kRequestUrl:url}];
    
    
}

/*
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
    [self.navigationController pushViewController:slider animated:YES];
}

- (void)update:(id)data msgID:(int)msgid faildCode:(EDataStatusCode)errCode {

    [ShowTipsView hideHUDWithView:self.view];
    LKLoginMsgModel * model = data;
    if (errCode == eDataCodeSuccess) {
        [LKShareUserInfo share].isLogin = YES;
        //初始化新数据库
        [LKDBManager initDBWithUM:[LKShareUserInfo share].userInfo.userUuid];
        
        [self gotoMainViewPage];
        NSMutableArray * array = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
        if (array.count > 1) {
            UIViewController * view = array[1];
            if ([view isKindOfClass:[self class]]) {
                [array removeObjectAtIndex:1];
            }
        }
        [self.navigationController setViewControllers:array];
    }
    else {
        [ShowTipsView showHUDWithMessage:model.message.length > 0 ?model.message :kRequest_TimeOut andView:self.view];
    }
    
}
*/

- (void)tapGestureRecognizer
{
    [self pushPageWithName:@"LKForgetPasswordViewPage" animation:YES];
}

- (void)textFieldResignFirstResponder
{
    [_nameTextField resignFirstResponder];
    [_passWordTextField resignFirstResponder];
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

#pragma - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _passWordTextField) {
        [self textFieldResignFirstResponder];
        [self loginStateChange];
    }else{
        [_nameTextField resignFirstResponder];
        [_passWordTextField becomeFirstResponder];
    }
    
    return YES;
}

@end
