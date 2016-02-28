//
//  LKForgetPasswordViewPage.m
//  Luckeys
//
//  Created by lishaowei on 15/9/19.
//  Copyright © 2015年 Luckeys. All rights reserved.
//

#import "LKForgetPasswordViewPage.h"
#import "LKForgetPasswordMsgModel.h"

@interface LKForgetPasswordViewPage () <UITextFieldDelegate>
{
    UIActivityIndicatorView *_activityIndicatorView;
    UILabel *_errLabel;
    UIButton *_submitButton;
    CGFloat _submitFrameY;

    UITextField *_nameTextField;
    UITextField *_verificationTextField;
    UITextField *_passWordTextField;
    
    UIButton *_verificationButton;
    
    NSInteger _totalTime; //倒数时间
    NSTimer * _timer;// 倒数计时器

}
@end

@implementation LKForgetPasswordViewPage

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self registController:@"LKForgetPasswordMsgController"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _submitFrameY = 0;
    
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
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(14, 80, CGRectGetWidth(self.view.bounds)-28, 120)];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = 3;
    [self.view addSubview:bgView];
    
    for (int i = 1; i < 3; i++) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(12, (40*i)-SINGLE_LINE_ADJUST_OFFSET, CGRectGetWidth(bgView.bounds)-24, SINGLE_LINE_BOUNDS)];
        lineView.backgroundColor = UIColorRGB(0xe1e1e1);
        [bgView addSubview:lineView];
    }

    _nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(12, 12, CGRectGetWidth(bgView.bounds)-24, 20)];
    [_nameTextField setClearButtonMode:UITextFieldViewModeWhileEditing];//右侧删除按钮
    _nameTextField.placeholder=@"请输入用户名";//默认显示的字
    _nameTextField.secureTextEntry=NO;//设置成密码格式
    _nameTextField.keyboardType=UIKeyboardTypeDefault;//设置键盘类型为默认的
    _nameTextField.returnKeyType=UIReturnKeyDone;//返回键的类型
    _nameTextField.delegate= self;//设置委托
    [bgView addSubview:_nameTextField];
    
    _verificationTextField = [[UITextField alloc] initWithFrame:CGRectMake(12, 50, CGRectGetWidth(bgView.bounds)-24 - 75, 20)];
    [_verificationTextField setClearButtonMode:UITextFieldViewModeWhileEditing];//右侧删除按钮
    _verificationTextField.placeholder=@"请输入验证码";//默认显示的字
    _verificationTextField.secureTextEntry=NO;//设置成密码格式
    _verificationTextField.keyboardType=UIKeyboardTypeDefault;//设置键盘类型为默认的
    _verificationTextField.returnKeyType=UIReturnKeyDone;//返回键的类型
    _verificationTextField.delegate= self;//设置委托
    [bgView addSubview:_verificationTextField];
    
    _verificationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _verificationButton.frame = CGRectMake(CGRectGetWidth(bgView.bounds)-14 - 70, 45, 70, 30);
    [_verificationButton setBackgroundImage:[UIImage imageScaleNamed:@"login_btn_fail#5_5_5_5#"] forState:UIControlStateNormal];
    [_verificationButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    _verificationButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [bgView addSubview:_verificationButton];
    [_verificationButton addTarget:self action:@selector(getPhoneCode) forControlEvents:UIControlEventTouchUpInside];

    
    _passWordTextField = [[UITextField alloc] initWithFrame:CGRectMake(12, 90, CGRectGetWidth(bgView.bounds)-24, 20)];
    [_passWordTextField setClearButtonMode:UITextFieldViewModeWhileEditing];//右侧删除按钮
    _passWordTextField.placeholder=@"请输入新密码";//默认显示的字
    _passWordTextField.secureTextEntry=YES;//设置成密码格式
    _passWordTextField.keyboardType=UIKeyboardTypeDefault;//设置键盘类型为默认的
    _passWordTextField.returnKeyType=UIReturnKeyDone;//返回键的类型
    _passWordTextField.delegate= self;//设置委托
    [bgView addSubview:_passWordTextField];
    
    _submitFrameY = CGRectGetMaxY(bgView.frame)+20;
    
    _errLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, CGRectGetMaxY(bgView.frame)+20, CGRectGetWidth(self.view.bounds)-24, 40)];
    _errLabel.backgroundColor = [UIColor redColor];
    _errLabel.textColor = UIColorRGB(0xfffff1);
    _errLabel.font = [UIFont systemFontOfSize:16];
    _errLabel.textAlignment = NSTextAlignmentCenter;
    _errLabel.alpha = 0.8;
    _errLabel.layer.masksToBounds = YES;
    _errLabel.layer.cornerRadius = 3;
    _errLabel.text = @"找回密码失败";
    [self.view addSubview:_errLabel];
    _errLabel.hidden = YES;
    
    _submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _submitButton.frame = CGRectMake(12, _submitFrameY, CGRectGetWidth(self.view.bounds)-24, 40);
    [_submitButton setBackgroundImage:[UIImage imageScaleNamed:@"login_btn_normal_bg#5_6_5_6#"] forState:UIControlStateNormal];
    _submitButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_submitButton setTitle:@"提交" forState:UIControlStateNormal];
    [_submitButton setTitleColor:UIColorRGB(0xffffff) forState:UIControlStateNormal];
    _submitButton.tag = 101;
    [self.view addSubview:_submitButton];
    [_submitButton addTarget:self action:@selector(submitStateChange) forControlEvents:UIControlEventTouchUpInside];
    
    _activityIndicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    _activityIndicatorView.center = CGPointMake(50.0f, 20.0f);//只能设置中心，不能设置大小
    [_submitButton addSubview:_activityIndicatorView];
    
    _activityIndicatorView.color = [UIColor whiteColor]; // 改变圈圈的颜色为红色； iOS5引入
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
    [_verificationButton setTitle:[NSString stringWithFormat:@"等待%ld秒",(long)_totalTime] forState:UIControlStateNormal];
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
    NSString * url = [NSString stringWithFormat:@"%@userPhone=%@&password=1",kURL_GetPhoneCode,_nameTextField.text];
    [self.controller sendMessageID:1000 messageInfo:@{kRequestUrl:url}];
    
    [self startTimeCount];

}

- (void)submitStateChange
{
    [self textFieldResignFirstResponder];
    
    if (_verificationTextField.text.length == 0) {
        [ShowTipsView showHUDWithMessage:@"请输入验证码" andView:self.view];
        return;
    }
    
    if (_passWordTextField.text.length < 6) {
        [ShowTipsView showHUDWithMessage:@"密码不能少于6位" andView:self.view];
        return;
    }
    
    [ShowTipsView showLoadHUDWithMSG:@"" andView:self.view];
    
    NSDictionary * body = @{@"codes":_verificationTextField.text,@"userPhone":_nameTextField.text,@"password":_passWordTextField.text};
    [self.controller sendMessageID:1001 messageInfo:@{kRequestUrl:kURL_ResetPassword,kRequestBody:body}];

}


- (void)textFieldResignFirstResponder
{
    [_nameTextField resignFirstResponder];
    [_verificationTextField resignFirstResponder];
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
    [self textFieldResignFirstResponder];
    return YES;
}

#pragma - 数据
- (void) update:(id)data msgID:(int)msgid faildCode:(EDataStatusCode)errCode
{
    LKForgetPasswordMsgModel * model = (LKForgetPasswordMsgModel*)data;
    if (errCode == eDataCodeSuccess) {
        if (msgid == 1000) {
            //验证码
            if (model.message.length > 0) {
                [ShowTipsView showHUDWithMessage:@"发送验证码成功" andView:self.view];
            }
        }else{
            [ShowTipsView hideHUDWithView:self.view];
            [self popViewPageAnimated:YES];
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

@end
