//
//  LKRegistereViewPage.m
//  Luckeys
//
//  Created by lishaowei on 15/9/19.
//  Copyright © 2015年 Luckeys. All rights reserved.
//

#import "LKRegistereViewPage.h"
#import "LKRegistereMsgModel.h"

@interface LKRegistereViewPage () <UITextFieldDelegate>
{
    UIActivityIndicatorView *_activityIndicatorView;
    UIButton *_registereButton;
    CGFloat _registereFrameY;
    UILabel *_forgetPassWordLabel;
    
    UITextField *_nameTextField;
    UITextField *_phoneCodeTextField;
    UITextField *_passWordTextField;
    UITextField *_passWordAgainTextField;
    
    UIButton *_verificationButton;   //计时器
    
    NSString * _phoneCode;
    
    NSInteger _totalTime; //倒数时间
    NSTimer * _timer;// 倒数计时器
}
@end

@implementation LKRegistereViewPage

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self registController:@"LKRegistereMsgController"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _registereFrameY = 0;
    _phoneCode = @"";

    [self.view setUserInteractionEnabled:YES];
    
    [self hiddenNavgationView];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizer)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tapGestureRecognizer];

    [self addView];

}

- (void)tapGestureRecognizer
{
    [self textFieldResignFirstResponder];
}

- (void)addView
{
    
    UIImageView *backgroundImageVIew = [[UIImageView alloc] initWithFrame:self.view.bounds];
    backgroundImageVIew.image = [UIImage imageNamed:@"login_bg"];
    [self.view addSubview:backgroundImageVIew];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(10, 20, 44, 44);
    [backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -((44-CGRectGetWidth(backButton.imageView.bounds))/2), 0, 0)];
    [self.view addSubview:backButton];
    [backButton addTarget:self action:@selector(backViewControllerAnimated) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(14, 80, CGRectGetWidth(self.view.bounds)-28, 160)];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = 3;
    [self.view addSubview:bgView];
    
    for (int i = 1; i < 4; i++) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(12, (40*i)-SINGLE_LINE_ADJUST_OFFSET, CGRectGetWidth(bgView.bounds)-24, SINGLE_LINE_BOUNDS)];
        lineView.backgroundColor = UIColorRGB(0xe1e1e1);
        [bgView addSubview:lineView];
    }
    
    _nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(12, 12, CGRectGetWidth(bgView.bounds)-24, 20)];
    [_nameTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
    _nameTextField.placeholder=@"请输入用户名";
    _nameTextField.keyboardType=UIKeyboardTypeDefault;
    _nameTextField.returnKeyType=UIReturnKeyDone;
    _nameTextField.delegate= self;
    [bgView addSubview:_nameTextField];
    
    _phoneCodeTextField = [[UITextField alloc] initWithFrame:CGRectMake(12, 50, CGRectGetWidth(bgView.bounds)-24 - 75, 20)];
    [_phoneCodeTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
    _phoneCodeTextField.placeholder=@"请输入验证码";
    _phoneCodeTextField.keyboardType=UIKeyboardTypeDefault;
    _phoneCodeTextField.returnKeyType=UIReturnKeyDone;
    _phoneCodeTextField.delegate= self;
    [bgView addSubview:_phoneCodeTextField];
    
    _verificationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _verificationButton.frame = CGRectMake(CGRectGetWidth(bgView.bounds)-14 - 70, 45, 70, 30);
    [_verificationButton setBackgroundImage:[UIImage imageScaleNamed:@"login_btn_fail#5_5_5_5#"] forState:UIControlStateNormal];
    [_verificationButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    _verificationButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [_verificationButton addTarget:self action:@selector(getPhoneCode) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:_verificationButton];
    
    _passWordTextField = [[UITextField alloc] initWithFrame:CGRectMake(12, 90, CGRectGetWidth(bgView.bounds)-24, 20)];
    [_passWordTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
    _passWordTextField.placeholder=@"请输入密码";
    _passWordTextField.secureTextEntry=YES;
    _passWordTextField.keyboardType=UIKeyboardTypeDefault;
    _passWordTextField.returnKeyType=UIReturnKeyDone;
    _passWordTextField.delegate= self;
    [bgView addSubview:_passWordTextField];
    
    _passWordAgainTextField = [[UITextField alloc] initWithFrame:CGRectMake(12, 130, CGRectGetWidth(bgView.bounds)-24, 20)];
    [_passWordAgainTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
    _passWordAgainTextField.placeholder=@"请重新输入密码";
    _passWordAgainTextField.secureTextEntry=YES;
    _passWordAgainTextField.keyboardType=UIKeyboardTypeDefault;
    _passWordAgainTextField.returnKeyType=UIReturnKeyDone;
    _passWordAgainTextField.delegate= self;
    [bgView addSubview:_passWordAgainTextField];
    
    _registereFrameY = CGRectGetMaxY(bgView.frame)+20;
    
    _registereButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _registereButton.frame = CGRectMake(12, _registereFrameY, CGRectGetWidth(self.view.bounds)-24, 40);
    [_registereButton setBackgroundImage:[UIImage imageScaleNamed:@"login_btn_normal_bg#5_6_5_6#"] forState:UIControlStateNormal];
    _registereButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_registereButton setTitle:@"注册" forState:UIControlStateNormal];
    [_registereButton setTitleColor:UIColorRGB(0xffffff) forState:UIControlStateNormal];
    _registereButton.tag = 101;
    [self.view addSubview:_registereButton];
    [_registereButton addTarget:self action:@selector(registereStateChange) forControlEvents:UIControlEventTouchUpInside];
    
    _activityIndicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    _activityIndicatorView.center = CGPointMake(50.0f, 20.0f);//只能设置中心，不能设置大小
    [_registereButton addSubview:_activityIndicatorView];
    
    _activityIndicatorView.color = [UIColor whiteColor];
    [_activityIndicatorView setHidden:YES];
    
}

- (void)backViewControllerAnimated
{
    [self popViewPageAnimated:YES];
}

//开始倒计时
-(void)startTimeCount{
    _totalTime = 60;
    if (_timer == nil) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeCount:) userInfo:nil repeats:YES];
    }else{
        [_timer setFireDate:[NSDate distantPast]];
    }
    [_verificationButton setEnabled:NO];
}
//倒计时方法
-(void)timeCount:(id)sender{
    _totalTime -- ;
    [_verificationButton setTitle:[NSString stringWithFormat:@"等待%ld秒",_totalTime] forState:UIControlStateNormal];
    if (_totalTime <= 0) {
        [_timer setFireDate:[NSDate distantFuture]];
        [_verificationButton setEnabled:YES];
        [_verificationButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    }
}

- (void)getPhoneCode
{
    [self textFieldResignFirstResponder];
    
    if (_nameTextField.text.length != 11) {
        [ShowTipsView showHUDWithMessage:@"请输入正确的手机号" andView:self.view];
        return;
    }
    NSString * url = [NSString stringWithFormat:@"%@userPhone=%@",kURL_GetPhoneCode,_nameTextField.text];
    [self.controller sendMessageID:1000 messageInfo:@{kRequestUrl:url}];
    
    [self startTimeCount];
    
}

- (void)registereStateChange
{
    [self textFieldResignFirstResponder];
    
    if (_nameTextField.text.length == 0 || _phoneCodeTextField.text.length == 0 || _passWordTextField.text.length == 0 || _passWordAgainTextField.text.length == 0) {
        [ShowTipsView showHUDWithMessage:@"请输入正确的信息" andView:self.view];
        return;
    }
    if (![_passWordTextField.text isEqualToString:_passWordAgainTextField.text]) {
        [ShowTipsView showHUDWithMessage:@"请输入相同的密码" andView:self.view];
        return;
    }
    
    if (_passWordTextField.text.length < 6) {
        [ShowTipsView showHUDWithMessage:@"密码不能少于6位" andView:self.view];
        return;
    }
    
    NSDictionary * body = @{@"codes":_phoneCodeTextField.text,@"userPhone":_nameTextField.text,@"password":_passWordTextField.text};
    
    [self.controller sendMessageID:1001 messageInfo:@{kRequestUrl:kURL_Register,kRequestBody:body}];

}


- (void) update:(id)data msgID:(int)msgid faildCode:(EDataStatusCode)errCode
{
    LKRegistereMsgModel * model = (LKRegistereMsgModel*)data;
    if (errCode == eDataCodeSuccess) {
        if (msgid == 1000) {
            //验证码
            if (model.message.length > 0) {
                [ShowTipsView showHUDWithMessage:model.message andView:self.view];
            }
        }
        else {
                [LKShareUserInfo share].isLogin = YES;
                [ShowTipsView showHUDWithMessage:@"注册成功" andView:self.view];
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
    }
    else {
        
        if (msgid == 1000) {
            _totalTime = 0;
            [ShowTipsView showHUDWithMessage:(model.message.length >0 ? model.message:@"验证码发送失败") andView:self.view];
        }else{
            [ShowTipsView showHUDWithMessage:(model.message.length >0 ? model.message:kRequest_TimeOut) andView:self.view];
        }
        
        
    }
}

- (void)gotoMainViewPage
{
    NSArray *pageArrays = @[@"LKHomeViewPage",@"LKHistoryViewPage",@"LKShareViewPage",@"LKMyTabViewPage"];
    
    NSMutableArray *tabBarButtons = [NSMutableArray arrayWithArray:@[
                                                                     @{@"itemImgName":@"ic_home_normla",
                                                                       @"itemSelImgName":@"ic_home",
                                                                       @"itemTitle":@"首页"},
                                                                     @{@"itemImgName":@"ic_history_normal",
                                                                       @"itemSelImgName":@"ic_history_on",
                                                                       @"itemTitle":@"历史"},
                                                                     @{@"itemImgName":@"ic_collec_normal",
                                                                       @"itemSelImgName":@"ic_collec_on",
                                                                       @"itemTitle":@"分享"},
                                                                     @{@"itemImgName":@"ic_user_normal",
                                                                       @"itemSelImgName":@"ic_user_on",
                                                                       @"itemTitle":@"我的"}
                                                                     ]];
    UIPATabBarController * tab = [[UIPATabBarController alloc] initTabPages:pageArrays items:tabBarButtons];
    
    UIViewController * leftVC;
    Class leftClass = NSClassFromString(@"LKAllTypesViewPage");
    if (leftClass) {
        leftVC = [[leftClass alloc] init];
    }
    
    UIViewController * rightVC;
    Class rightClass = NSClassFromString(@"LKAllTypesViewPage");
    if (rightClass) {
        rightVC = [[rightClass alloc] init];
    }
    
    SliderViewController * slider = [SliderViewController shareSliderVC];
    slider.mainController = tab;
    slider.leftController = (UIViewController*)leftVC;
    slider.rightController = rightVC;
    
    [self.navigationController pushViewController:slider animated:YES];
}


- (void)textFieldResignFirstResponder
{
    [_nameTextField resignFirstResponder];
    [_phoneCodeTextField resignFirstResponder];
    [_passWordTextField resignFirstResponder];
    [_passWordAgainTextField resignFirstResponder];
}


#pragma - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self textFieldResignFirstResponder];
    return YES;
}


@end
