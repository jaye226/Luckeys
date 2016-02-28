//
//  LKEditePersonDataViewPage.m
//  Luckeys
//
//  Created by 李锦华 on 15/10/17.
//  Copyright © 2015年 Luckeys. All rights reserved.
//

#import "LKEditePersonDataViewPage.h"
#import "LKShareUserInfo.h"

@interface LKEditePersonDataViewPage ()<UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate>{

    UIScrollView *_scrollView;
    UIImageView *_headImageView;//头像
    UITextField *_niTextField;  //昵称
    UITextField *_phoneTextField;   //手机
    UITextField *_pwTextField;  //密码
    
    UITextField *_dateTextField;  //日期
    UITextField *_emailTextField;   //邮箱
    UITextField *_addresstField;  //地址
    
    UIView *_dateView;
    UIDatePicker *_datePicker;  //时间选择器
    
    CGFloat _textFieldHeight;
    
    NSString *_sex;
    
    NSData *_imageData;
    
    UIButton *_nanBtn;
    UIButton *_nvBtn;
    UIButton *_qiBtn;
}

@end

@implementation LKEditePersonDataViewPage

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(id)init
{
    if (self = [super init])
    {
        [self registController:@"LKEditePersonDataController"];//注册控制器
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:UIColorRGB(0xf0f0f0)];
    self.title=@"编辑个人资料";
    [self.navigationView addRightButtonTitleWith:@"保存" titleColorWith:UIColorRGB(0xff4f4f) selectdColorWith:UIColorRGB(0xff4f4f) fontWith:[UIFont systemFontOfSize:FontOfScale(15)]];
    
    _sex = [LKShareUserInfo share].userInfo.sex;
    
    _textFieldHeight = 0;
    
    [self addView];
    
    //键盘监测
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardWillHideNotification object:nil];
}


- (void)addView
{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-64)];
    _scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_scrollView];
    [self.view sendSubviewToBack:_scrollView];
    _scrollView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(allTextFieldResignFirstResponder)];
    [_scrollView addGestureRecognizer:tap];
    
    [self infoView];
    [self subInfoView];
    
    [_scrollView setContentOffset:CGPointMake(0, 20) animated:NO];

}

- (void)infoView
{
    UIView *infoView = [[UIView alloc] initWithFrame:CGRectMake(18, 18, CGRectGetWidth(self.view.bounds)-36, 45*3+90)];
    infoView.backgroundColor = [UIColor whiteColor];
    // 圆角
    infoView.layer.masksToBounds = YES;
    infoView.layer.cornerRadius = 6.0;
    infoView.layer.borderWidth = 1.0;
    infoView.layer.borderColor = [[UIColor whiteColor] CGColor];
    [_scrollView addSubview:infoView];
    
    //头像
    UILabel *headLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, 100, 90)];
    headLabel.backgroundColor = [UIColor clearColor];
    headLabel.textAlignment = NSTextAlignmentLeft;
    headLabel.textColor = UIColorRGB(0x666666);
    headLabel.font = [UIFont systemFontOfSize:15];
    headLabel.text = @"头像";
    [infoView addSubview:headLabel];
    
    _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(infoView.bounds)-76, 15, 60, 60)];
    _headImageView.backgroundColor = [UIColor yellowColor];
    [_headImageView setContentMode:UIViewContentModeScaleAspectFill];
    _headImageView.clipsToBounds = YES;
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@%@",SeverHost,[[LKShareUserInfo share] userInfo].userHead]] placeholderImage:[UIImage imageNamed:@"defaulthead"]];
    [infoView addSubview:_headImageView];
    
    UIView *headLineView = [[UIView alloc] initWithFrame:CGRectMake(16, 87-SINGLE_LINE_ADJUST_OFFSET, CGRectGetWidth(infoView.bounds)-32, SINGLE_LINE_BOUNDS)];
    headLineView.backgroundColor = UIColorRGB(0xe9e9e9);
    [infoView addSubview:headLineView];
    
    UIButton *headButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 90)];
    headButton.backgroundColor = [UIColor clearColor];
    [infoView addSubview:headButton];
    [headButton addTarget:self action:@selector(clickedHeadBtn) forControlEvents:UIControlEventTouchUpInside];
    
    //昵称
    for (int i = 0; i < 3; i++)
    {
        UILabel *niLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 90+45*i, 70, 45)];
        niLabel.backgroundColor = [UIColor clearColor];
        niLabel.textAlignment = NSTextAlignmentLeft;
        niLabel.textColor = UIColorRGB(0x666666);
        niLabel.font = [UIFont systemFontOfSize:15];
        [infoView addSubview:niLabel];
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(86, 90+45*i, CGRectGetWidth(infoView.bounds)-102, 45)];
        [textField setBackgroundColor:[UIColor clearColor]];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.textAlignment=NSTextAlignmentRight;
        textField.returnKeyType = UIReturnKeyDone;
        textField.font = [UIFont systemFontOfSize:14];
        textField.delegate = self;
        [textField setTextColor:UIColorRGB(0x333333)];
        [infoView addSubview:textField];
        
        UIView *headLineView = [[UIView alloc] initWithFrame:CGRectMake(16, 90+45*i+45-SINGLE_LINE_ADJUST_OFFSET, CGRectGetWidth(infoView.bounds)-32, SINGLE_LINE_BOUNDS)];
        headLineView.backgroundColor = UIColorRGB(0xe9e9e9);
        [infoView addSubview:headLineView];
        
        switch (i) {
            case 0://昵称
            {
                niLabel.text = @"昵称";
                
                textField.placeholder = [[LKShareUserInfo share] userInfo].nickName.length>0?[[LKShareUserInfo share] userInfo].nickName:@"昵称";
                _niTextField = textField;
                
                break;
            }
            case 1://手机
            {
                niLabel.text = @"手机";
                
                textField.placeholder = [[LKShareUserInfo share] userInfo].userPhone.length>0?[[LKShareUserInfo share] userInfo].userPhone:@"手机";
                _phoneTextField = textField;
                _phoneTextField.userInteractionEnabled = NO;
                
                break;
            }
            case 2://密码
            {
                niLabel.text = @"密码";
                
                textField.text = @"123456";
                textField.secureTextEntry = YES;
                textField.userInteractionEnabled = NO;
                _pwTextField = textField;
                
                break;
            }
            default:
                break;
        }
    }
}

- (void)subInfoView
{
    UIView *infoView = [[UIView alloc] initWithFrame:CGRectMake(18, 18+45*3+90+18, CGRectGetWidth(self.view.bounds)-36, 45*4)];
    infoView.backgroundColor = [UIColor whiteColor];
    // 圆角
    infoView.layer.masksToBounds = YES;
    infoView.layer.cornerRadius = 6.0;
    infoView.layer.borderWidth = 1.0;
    infoView.layer.borderColor = [[UIColor whiteColor] CGColor];
    [_scrollView addSubview:infoView];
    
    UIView *lineView=[[UIView alloc] initWithFrame:CGRectMake(16, 45-SINGLE_LINE_ADJUST_OFFSET, UI_IOS_WINDOW_WIDTH-16, SINGLE_LINE_BOUNDS)];
    lineView.backgroundColor = UIColorRGB(0xe9e9e9);
    [infoView addSubview:lineView];
    
    for (int i = 0; i < 3; i++)
    {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i*(infoView.width/3), 0, infoView.width/3, 44);
        [button setTitleColor:UIColorRGB(0x666666) forState:UIControlStateNormal];
        [button setTitleColor:UIColorRGB(0xff4f4f) forState:UIControlStateSelected];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        [infoView addSubview:button];
        [button addTarget:self action:@selector(selectSex:) forControlEvents:UIControlEventTouchUpInside];
        if (i != 2)
        {
            UIView *sexLineView = [[UIView alloc] initWithFrame:CGRectMake(infoView.width/3+(infoView.width/3)*i-SINGLE_LINE_ADJUST_OFFSET, 10, SINGLE_LINE_BOUNDS, 25)];
            sexLineView.backgroundColor = UIColorRGB(0xe9e9e9);
            [infoView addSubview:sexLineView];
        }
        
        UILabel *niLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 45+45*i, 70, 45)];
        niLabel.backgroundColor = [UIColor clearColor];
        niLabel.textAlignment = NSTextAlignmentLeft;
        niLabel.textColor = UIColorRGB(0x666666);
        niLabel.font = [UIFont systemFontOfSize:15];
        [infoView addSubview:niLabel];
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(86, 45+45*i, CGRectGetWidth(infoView.bounds)-102, 45)];
        [textField setBackgroundColor:[UIColor clearColor]];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.textAlignment=NSTextAlignmentRight;
        textField.returnKeyType = UIReturnKeyDone;
        textField.font = [UIFont systemFontOfSize:14];
        textField.delegate = self;
        [textField setTextColor:UIColorRGB(0x333333)];
        [infoView addSubview:textField];
        
        UIView *headLineView = [[UIView alloc] initWithFrame:CGRectMake(16, 45+45*i+45-SINGLE_LINE_ADJUST_OFFSET, CGRectGetWidth(infoView.bounds)-32, SINGLE_LINE_BOUNDS)];
        headLineView.backgroundColor = UIColorRGB(0xe9e9e9);
        [infoView addSubview:headLineView];
        
        switch (i) {
            case 0://出生日期
            {
                [button setTitle:@"男" forState:UIControlStateNormal];
                _nanBtn = button;
                niLabel.text = @"出生日期";
                
                textField.placeholder = [[LKShareUserInfo share] userInfo].birthday.length>0?[[LKShareUserInfo share] userInfo].birthday:@"出生日期";
                _dateTextField = textField;
                _dateTextField.userInteractionEnabled = NO;
                
                UIButton *dateButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 45+45*i, CGRectGetWidth(infoView.bounds), 45)];
                dateButton.backgroundColor = [UIColor clearColor];
                [infoView addSubview:dateButton];
                [dateButton addTarget:self action:@selector(clickedDateBtn) forControlEvents:UIControlEventTouchUpInside];
                
                break;
            }
            case 1://电子邮件
            {
                [button setTitle:@"女" forState:UIControlStateNormal];
                _nvBtn = button;
                niLabel.text = @"电子邮件";
                
                textField.placeholder = [[LKShareUserInfo share] userInfo].email.length>0?[[LKShareUserInfo share] userInfo].email:@"电子邮件";
                _emailTextField = textField;
                
                break;
            }
            case 2://地址
            {
                [button setTitle:@"其它" forState:UIControlStateNormal];
                _qiBtn = button;
                niLabel.text = @"地址";
                
                textField.placeholder = [[LKShareUserInfo share] userInfo].address.length>0?[[LKShareUserInfo share] userInfo].address:@"地址";
                _addresstField = textField;
                
                break;
            }
            default:
                break;
        }
    }
    if([[[LKShareUserInfo share] userInfo].sex isEqualToString:@"1"]){
        _nanBtn.selected = YES;
    }else if([[[LKShareUserInfo share] userInfo].sex isEqualToString:@"0"]){
        _nvBtn.selected = YES;
    }else{
        _qiBtn.selected = YES;
    }
}

-(void)selectSex:(UIButton *)button
{
    button.selected = YES;
    if(button==_nanBtn){
        _sex=@"1";
        _nvBtn.selected = NO;
        _qiBtn.selected = NO;
    }else if(button==_nvBtn){
        _sex=@"0";
        _nanBtn.selected = NO;
        _qiBtn.selected = NO;
    }else{
        _sex=@"2";
        _nanBtn.selected = NO;
        _nvBtn.selected = NO;
    }
}

-(void)changeNavRightBtnInside{
    [self.view endEditing:YES];
    
    NSDictionary *bodyDic=@{@"nickName":_niTextField.text,@"address":_addresstField.text,@"userPhone":@"",@"sex":_sex,@"email":_emailTextField.text,@"birthday":_dateTextField.text};
    
    NSDictionary *requestDic=@{kRequestUrl:kURL_ModifyPersonData,kRequestBody:bodyDic};
    
    [self.controller sendMessageID:10000 messageInfo:requestDic];
}

/**
 *  点击头像响应
 */
- (void)clickedHeadBtn
{
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@"请选择"
                                                        delegate:self
                                               cancelButtonTitle:@"取消"
                                          destructiveButtonTitle:nil
                                               otherButtonTitles:@"相册",@"拍照", nil];
    action.actionSheetStyle = UIActionSheetStyleDefault;
    [action showInView:self.view.superview];
}

/**
 *  点击日起响应
 */
- (void)clickedDateBtn
{
    [self allTextFieldResignFirstResponder];
    if (_dateView == nil) {
        _dateView = [[UIView alloc] initWithFrame:self.view.bounds];
        _dateView.backgroundColor = UIColorRGBA(0xf0f0f0, 0.5);
        [self.view addSubview:_dateView];
        _dateView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dateResignFirstResponder)];
        [_dateView addGestureRecognizer:tap];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.bounds)-230, CGRectGetWidth(self.view.bounds), 230)];
        view.backgroundColor = [UIColor whiteColor];
        [_dateView addSubview:view];
        
        UIButton *dateButton = [UIButton buttonWithType:UIButtonTypeCustom];
        dateButton.frame = CGRectMake(CGRectGetWidth(view.bounds)-60, 5, 50, 40);
        dateButton.backgroundColor = [UIColor clearColor];
        [dateButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [dateButton setTitle:@"完成" forState:UIControlStateNormal];
        dateButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [view addSubview:dateButton];
        [dateButton addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
        
        _datePicker= [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 30, CGRectGetWidth(self.view.bounds), 200)];
        _datePicker.datePickerMode = UIDatePickerModeDate;
        [view addSubview:_datePicker];
    }
}

- (void)dateResignFirstResponder
{
    [_dateView removeFromSuperview];
    _dateView = nil;
}

- (void)clicked:(id)sender {
    
    // 获取用户通过UIDatePicker设置的日期和时间
    NSDate *selected = [_datePicker date];
    // 创建一个日期格式器
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // 为日期格式器设置格式字符串
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    // 使用日期格式器格式化日期、时间
    NSString *destDateString = [dateFormatter stringFromDate:selected];
    
    _dateTextField.text = destDateString;
    [_dateView removeFromSuperview];
    _dateView = nil;
}

- (void)allTextFieldResignFirstResponder
{
    [_headImageView resignFirstResponder];//头像
    [_niTextField resignFirstResponder];  //昵称
    [_phoneTextField resignFirstResponder];   //手机
    [_pwTextField resignFirstResponder];  //密码
    [_dateTextField resignFirstResponder];  //日期
    [_emailTextField resignFirstResponder];   //邮箱
    [_addresstField resignFirstResponder];  //地址
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
    CGRect rect=[textField convertRect:textField.bounds toView:window];
    _textFieldHeight = CGRectGetMaxY(rect);
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - 键盘显示\隐藏
- (void) keyboardWasShown:(NSNotification *) notif
{
    NSDictionary *info = [notif userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    
    NSTimeInterval interVal = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    if(CGRectGetMaxY(self.view.bounds)-keyboardSize.height<_textFieldHeight){
        [UIView animateWithDuration:interVal animations:^{
            [_scrollView setContentOffset:CGPointMake(0, _textFieldHeight-(CGRectGetMaxY(self.view.bounds)-keyboardSize.height)+10) animated:NO];
        } completion:^(BOOL finished){
            
        }];
    }
}

- (void) keyboardWasHidden:(NSNotification *) notif
{
    NSDictionary *info = [notif userInfo];
    NSTimeInterval interVal = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:interVal animations:^{
        [_scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    } completion:^(BOOL finished){
        
    }];
}

#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    UIImage* oralImg=[info objectForKey:UIImagePickerControllerEditedImage];
    
//    double image_w = oralImg.size.width;
//    double image_h = oralImg.size.height;
//    
//    if (image_h > 110)
//    {
//        image_h = 110;
//    }
//    
//    if (image_w > 100)
//    {
//        image_w = 110;
//    }
    
//    oralImg = [self scaleFromImage:oralImg toSize:CGSizeMake(image_w, image_h)];
    
   [self commitHeadImage:oralImg];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

- (UIImage *) scaleFromImage: (UIImage *) image toSize: (CGSize) size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

//提交图片
- (void)commitHeadImage:(UIImage*)headImage
{
    _imageData = UIImageJPEGRepresentation(headImage, 1.0);
    
    NSString *url=[NSString stringWithFormat:@"%@%@%@",HeadHost,SeverHost,kURL_UploadPhoto];

    [[MLHttpRequestManager sharedMLHttpRequestManager] uploadRequestWithTag:100 URLString:url requestType:Request_UploadHead uploadData:headImage Finished:^(Result_TYPE success, int requestTag, id callbackData) {
        if (success == Result_Success) {
            NSDictionary *dict = [PADataObject jsonDataToObject:callbackData];
            if (dict && [[dict objectForKey:@"code"] intValue] == 1) {
                NSDictionary * body = [dict objectForKey:@"body"];
                if (body.allKeys.count) {
                    NSString *imageUrl = [body objectForKey:@"userHead"];
                    [self uploadSuccess:imageUrl];
                }
            }
        }
        else if (success == Result_TimeOut || success == Result_Fail)
        {
            [self uploadFailure];
        }
    }];
}

#pragma mark -
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        UIImagePickerController *picker =[[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.allowsEditing = YES;
        [picker.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
        picker.navigationBar.tintColor = [UIColor blackColor];
        [self presentViewController:picker animated:YES completion:nil];
    }
    else if (buttonIndex == 1)
    {
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
        {
            /*if ([[AVCaptureDevice class] respondsToSelector:@selector(authorizationStatusForMediaType:)]) {
                AVAuthorizationStatus authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
                if (authorizationStatus == AVAuthorizationStatusRestricted
                    || authorizationStatus == AVAuthorizationStatusDenied) {
                    
                    // 没有权限
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                                        message:@"请在iPhone的“设置-隐私-相机”选项中，允许Luckeys访问你的相机。"
                                                                       delegate:nil
                                                              cancelButtonTitle:@"确定"
                                                              otherButtonTitles:nil];
                    [alertView show];
                    return;
                }
            }*/
            
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:picker animated:YES completion:nil];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Error accessing photo library"
                                  message:@"Device does not support a photo library"
                                  delegate:nil
                                  cancelButtonTitle:@"ok!"
                                  otherButtonTitles:nil];
            [alert show];
        }
    }
    else if (buttonIndex == 2)
    {
        [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
    }
}

#pragma mark - 头像上传Delegate
- (void)uploadSuccess:(NSString *)imageUrl
{
    [[LKShareUserInfo share] userInfo].userHead = imageUrl;
    
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@%@",SeverHost,[[LKShareUserInfo share] userInfo].userHead]] placeholderImage:[UIImage imageNamed:@"defaulthead"]];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotiChangeHeadImage object:nil];
}

- (void)uploadFailure{
    [ShowTipsView showHUDWithMessage:@"修改头像失败" andView:self.view];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma request callback
-(void)update:(id)data msgID:(int)msgid faildCode:(EDataStatusCode)errCode{
    if(errCode==eDataCodeSuccess){
        if(_niTextField.text&&_niTextField.text.length!=0){
            [LKShareUserInfo share].userInfo.nickName=_niTextField.text;
        }
        if(_addresstField.text&&_addresstField.text.length!=0){
            [LKShareUserInfo share].userInfo.address=_addresstField.text;
        }
        if(_emailTextField.text&&_emailTextField.text.length!=0){
            [LKShareUserInfo share].userInfo.email=_emailTextField.text;
        }
        if(_sex&&_sex.length!=0){
            [LKShareUserInfo share].userInfo.sex=_sex;
        }
        
        if(_dateTextField.text&&_dateTextField.text.length!=0){
            [LKShareUserInfo share].userInfo.birthday=_dateTextField.text;
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotiChangeUserInfo object:nil];
        [self popViewPageAnimated:YES];
    }else{
        [ShowTipsView showHUDWithMessage:@"修改个人信息失败" andView:self.view];
    }
}


@end
