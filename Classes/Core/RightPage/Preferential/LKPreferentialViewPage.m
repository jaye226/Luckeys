//
//  LKPreferentialViewPage.m
//  Luckeys
//
//  Created by BearLi on 15/11/15.
//  Copyright © 2015年 Luckeys. All rights reserved.
//

#import "LKPreferentialViewPage.h"

@interface LKPreferentialViewPage () <UITextFieldDelegate>
{
    UITextField *_textField;
    
    UILabel *_numberLabel;
    
    UILabel *_descriptionLabel;
}

@end

@implementation LKPreferentialViewPage

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColorMakeRGB(247.0, 247.0, 247.0);
    self.title = @"优惠";
    
    [self.navigationView addRightButtonTitleWith:@"应用" titleColorWith:UIColorRGB(0xff4f4f) selectdColorWith:UIColorRGB(0xff4f4f) fontWith:[UIFont systemFontOfSize:FontOfScale(15)]];
    
    [self addView];
}

- (void)addView
{
    UIView *textFueldView = [[UIView alloc]initWithFrame:CGRectMake(BoundsOfScale(18), BoundsOfScale(12)+64, self.view.width-BoundsOfScale(18)*2, BoundsOfScale(48))];
    textFueldView.backgroundColor = [UIColor whiteColor];
    textFueldView.layer.masksToBounds = YES;
    textFueldView.layer.cornerRadius = 5;
    textFueldView.layer.borderWidth = 0.5;
    textFueldView.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.view addSubview:textFueldView];
    
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(BoundsOfScale(15), BoundsOfScale(4), textFueldView.width-BoundsOfScale(15), BoundsOfScale(40))];
    _textField.backgroundColor = [UIColor whiteColor];
    [_textField setClearButtonMode:UITextFieldViewModeWhileEditing];
    _textField.placeholder=@"乐其优惠码";
    _textField.keyboardType=UIKeyboardTypeDefault;
    _textField.returnKeyType=UIReturnKeyDone;
    _textField.delegate= self;
    [textFueldView addSubview:_textField];
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(BoundsOfScale(30), textFueldView.maxY+BoundsOfScale(69), self.view.width-BoundsOfScale(30)*2, BoundsOfScale(225))];
    bgImageView.image = [UIImage imageWithName:@"my_code"];
    [self.view addSubview:bgImageView];
    
    _numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(BoundsOfScale(30), BoundsOfScale(108), bgImageView.width-BoundsOfScale(30)*2, BoundsOfScale(30))];
    _numberLabel.backgroundColor = [UIColor clearColor];
    _numberLabel.textColor = UIColorRGB(0xffffff);
    _numberLabel.font = [UIFont systemFontOfSize:FontOfScale(24)];
    _numberLabel.textAlignment = NSTextAlignmentCenter;
    _numberLabel.text = @"321321321";
    [bgImageView addSubview:_numberLabel];
    
    _descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(BoundsOfScale(20), BoundsOfScale(168), bgImageView.width-BoundsOfScale(20)*2, BoundsOfScale(30))];
    _descriptionLabel.backgroundColor = [UIColor clearColor];
    _descriptionLabel.textColor = UIColorRGB(0xffffff);
    _descriptionLabel.font = [UIFont systemFontOfSize:FontOfScale(12)];
    _descriptionLabel.textAlignment = NSTextAlignmentCenter;
    _descriptionLabel.numberOfLines = 2;
    _descriptionLabel.text = @"某微信公众号发布转载郭某的微博照片称，上海市闵行区浦江镇发生抢劫砍人事件，网贴中称“居民在上海浦江镇某ATM上取款时遭遇抢劫，头部和大腿各被砍了一刀。”并配以图片，十分血腥。这一消息在朋友圈疯传。引起部分市民恐慌。";
    [bgImageView addSubview:_descriptionLabel];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, self.view.height-BoundsOfScale(49), self.view.width, BoundsOfScale(49));
    [button setBackgroundColor:UIColorRGBA(0xff664d,0.9)];
    [button setTitleColor:UIColorRGB(0xffffff) forState:UIControlStateNormal];
    [button setTitle:@"我要分享" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:FontOfScale(16)];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(submitBtnInside) forControlEvents:UIControlEventTouchUpInside];
}

- (void)changeNavRightBtnInside
{
    
}

- (void)submitBtnInside
{
    
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
    [textField resignFirstResponder];
    return YES;
}

@end
