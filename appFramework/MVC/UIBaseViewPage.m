//
//  PABaseViewPage.m
//  MLPlayer
//
//  Created by txt on 15/6/3.
//  Copyright (c) 2015年 w. All rights reserved.
//

#import "UIBaseViewPage.h"

@interface UIBaseViewPage ()

@end

@implementation UIBaseViewPage

-(void)initWithParam:(NSDictionary *)paramInfo
{
    //子类实现
}

-(void)backViewWithParam:(NSDictionary *)paramInfo
{
    //子类实现
}

-(void)registController:(NSString*)controllerName
{
    if (controllerName == nil || [controllerName isEqualToString:@""]) {
        return;
    }
    Class classObj = NSClassFromString(controllerName);
    if (classObj && [classObj isSubclassOfClass:[NBaseController class]]) {
        self.controller = [((NBaseController*)[classObj alloc]) initWithPage:self];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.canSlidGesture = YES;
}

- (void)setLeftBarButtonItemTitle:(NSString*)title titleColor:(UIColor*)normalColor highlightColor:(UIColor*)highlightColor
{
    [self addTitleBarButton:YES title:title titleColor:normalColor highlightColor:highlightColor];
}

- (void)setRightBarButtonItemTitle:(NSString*)title titleColor:(UIColor*)normalColor highlightColor:(UIColor*)highlightColor
{
    [self addTitleBarButton:NO title:title titleColor:normalColor highlightColor:highlightColor];
}


- (void)addTitleBarButton:(BOOL)isLeft title:(NSString*)title titleColor:(UIColor*)normalColor highlightColor:(UIColor*)highlightColor
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 44, 44);
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:normalColor forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:FontOfScale(15)];
    [button setTitleColor:highlightColor forState:UIControlStateHighlighted];
    
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:button];
    if (isLeft) {
        [button addTarget:self action:@selector(handlerLeftAction:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = item;
    }
    else
    {
        [button addTarget:self action:@selector(handlerRightAction:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = item;
    }
}

- (void)setLeftBarButtonItemImage:(UIImage*)normalimage  highlightImage:(UIImage*)highlightImage
{
    [self addImageBarButtonItem:YES image:normalimage highlightImage:highlightImage];
}

- (void)setRightBarButtonItemImage:(UIImage*)normalimage  highlightImage:(UIImage*)highlightImage
{
    [self addImageBarButtonItem:NO image:normalimage highlightImage:highlightImage];
}

- (void)addImageBarButtonItem:(BOOL)isLeft image:(UIImage*)normalimage  highlightImage:(UIImage*)highlightImage
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 44, 44);
    [button setImage:normalimage forState:UIControlStateNormal];
    [button setImage:highlightImage forState:UIControlStateHighlighted];
    
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:button];
    if (isLeft) {
        button.imageEdgeInsets = UIEdgeInsetsMake(0, -14, 0, 14);
        [button addTarget:self action:@selector(handlerLeftAction:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = item;
    }
    else
    {
        button.imageEdgeInsets = UIEdgeInsetsMake(0, 13, 0, -13);
        [button addTarget:self action:@selector(handlerRightAction:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = item;
    }
}

- (void)handlerLeftAction:(UIButton*)button
{
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)handlerRightAction:(UIButton*)button
{

}

- (void)backButtonInside
{
    [self popViewPageAnimated:YES];
}

//导航栏刷新按钮响应
- (void)refreshDataInside
{
    
}
//导航栏发布按钮响应
- (void)releaseInformationInside
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)update:(id)data msgID:(int)msgid faildCode:(EDataStatusCode)errCode
{
    //子类实现自已的数据更新
}

- (void)handleData:(int)msgID progress:(float)rate
{
    //子类实现自已的数据更新
}

@end


@implementation UIBaseViewPage(UINavigator)

-(void)pushPageWithName:(NSString*)pageName
{
    [self pushPageWithName:pageName animation:YES withParams:nil];
}

-(void)pushPageWithName:(NSString*)pageName animation:(BOOL)animation
{
    [self pushPageWithName:pageName animation:animation withParams:nil];
}

- (void)pushPageWithName:(NSString *)pageName withParams:(NSDictionary *)pararmInfo
{
    [self pushPageWithName:pageName animation:YES  withParams:pararmInfo];
}

-(void)pushPageWithName:(NSString*)pageName animation:(BOOL)animation withParams:(NSDictionary*)pararmInfo
{
#if 1
    if (pageName == nil || [pageName isEqualToString:@""]) {
        return ;
    }
    
    Class  classObj = NSClassFromString(pageName);
    if (classObj != nil && [classObj isSubclassOfClass:[UIViewController class]]) {
        id page = [[classObj alloc] init];
        if ([page respondsToSelector:@selector(initWithParam:)]) {
            [page initWithParam:pararmInfo];
        }
        UIViewController * pushVc = page;
        pushVc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:page animated:animation];
    }
#else
    [[UIPageNavigator getInstance] activatePageWithName:pageName animation:animation withParams:pararmInfo];
#endif
}

- (void)popViewPageAnimated:(BOOL)animated
{
//    [[UIPageNavigator getInstance] goBackWithParams:nil animated:animated];
      [self.navigationController popViewControllerAnimated:animated];
}

- (void)popToRootViewPageAnimated:(BOOL)animated
{
    [self.navigationController popToRootViewControllerAnimated:animated];
}

- (void)popViewPageAnimated:(UIViewController*)viewPage withAnimated:(BOOL)animated withParams:(NSDictionary*)paramInfo
{
    if (viewPage == nil) {
        return ;
    }
    
    id vp = viewPage;
    if (vp && [vp respondsToSelector:@selector(backViewWithParam:)]) {
        [vp backViewWithParam:paramInfo];
    }
    
    [self.navigationController popToViewController:viewPage animated:YES];

}

- (void)presentViewPage:(NSString*)pageName animated:(BOOL)animation completion:(void (^)(void))completion
{
    [self presentViewPage:pageName animated:animation completion:completion];
}

- (void)presentViewPage:(NSString*)pageName animated:(BOOL)animation paramInfo:(NSDictionary *)info completion:(void (^)(void))completion
{
    [self presentViewPage:pageName animated:animation paramInfo:info completion:completion];
}

- (void)dismissViewPageAnimated:(BOOL)animation completion:(void (^)(void))completion
{
    [self dismissViewPageAnimated:animation completion:completion];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return toInterfaceOrientation == UIInterfaceOrientationPortrait;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate {
    return NO;
}

@end


