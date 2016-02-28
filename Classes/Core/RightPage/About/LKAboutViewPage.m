//
//  LKAboutViewPage.m
//  Luckeys
//
//  Created by BearLi on 15/11/15.
//  Copyright © 2015年 Luckeys. All rights reserved.
//

#import "LKAboutViewPage.h"

@interface LKAboutViewPage ()

@end

@implementation LKAboutViewPage

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于";
    [self initView];
}

- (void)initView {
    UIImageView * aboutImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, kNavBarHeight+BoundsOfScale(94), BoundsOfScale(54), BoundsOfScale(54))];
    aboutImage.centerX = self.view.width/2.0;
    aboutImage.image = UIImageNamed(@"about_lq");
    aboutImage.layer.cornerRadius = 8;
    aboutImage.clipsToBounds = YES;
    [self.view addSubview:aboutImage];
    
    NSDictionary * dict = [[NSBundle mainBundle] infoDictionary];
    
    PBUILabel * namelabel = [[PBUILabel alloc] initWithFrame:CGRectMake(0, aboutImage.maxY + 10, self.view.width, 22)];
    namelabel.backgroundColor = [UIColor clearColor];
    namelabel.textAlignment = NSTextAlignmentCenter;
    namelabel.textColor = UIColorRGB(0x333333);
    namelabel.font = [UIFont systemFontOfSize:20];
    namelabel.text = dict[@"CFBundleName"];
    [self.view addSubview:namelabel];
    
    PBUILabel * versionLabel = [[PBUILabel alloc] initWithFrame:CGRectMake(0, namelabel.maxY + 11, self.view.width, 18)];
    versionLabel.backgroundColor = [UIColor clearColor];
    versionLabel.textColor = namelabel.textColor;
    versionLabel.textAlignment = NSTextAlignmentCenter;
    versionLabel.font = [UIFont systemFontOfSize:FontOfScale(13)];
    versionLabel.text = [NSString stringWithFormat:@"V%@",dict[@"CFBundleShortVersionString"]];
    [self.view addSubview:versionLabel];
    
    UIButton * agreement = [UIButton buttonWithType:UIButtonTypeCustom];
    agreement.frame = CGRectMake(0, versionLabel.maxY + 11, 111, 20);
    agreement.centerX = versionLabel.centerX;
    [agreement setTitleColor:UIColorRGB(0xf75347) forState:UIControlStateNormal];
    [agreement setTitle:@"用户协议" forState:UIControlStateNormal];
    agreement.titleLabel.font = [UIFont systemFontOfSize:FontOfScale(13)];
    [agreement addTarget:self action:@selector(agreementAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:agreement];
    
    PBUILabel * incLabel = [[PBUILabel alloc] initWithFrame:CGRectMake(0, self.view.height - 20 - 18, self.view.width, 18)];
    incLabel.textColor = UIColorRGB(0x999999);
    incLabel.textAlignment = NSTextAlignmentCenter;
    incLabel.systemFont = BoundsOfScale(12);
    incLabel.text = @"© 2015-2016 Luckys Inc. All rights reseved";
    [self.view addSubview:incLabel];
    incLabel.height = [incLabel heightWithText];
    incLabel.y = self.view.height -20 -incLabel.height;
    
    PBUILabel * lqLabel = [[PBUILabel alloc] initWithFrame:CGRectMake(0, incLabel.y-8-18, self.view.width, 18)];
    lqLabel.textAlignment = NSTextAlignmentCenter;
    lqLabel.textColor = incLabel.textColor;
    lqLabel.systemFont = incLabel.systemFont;
    lqLabel.text = @"乐其传媒 版权所有";
    [self.view addSubview:lqLabel];
}

- (void)agreementAction {
    
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
