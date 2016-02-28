//
//  LKNavigationController.m
//  Luckeys
//
//  Created by lishaowei on 15/9/19.
//  Copyright © 2015年 Luckeys. All rights reserved.
//

#import "LKNavigationController.h"

@interface LKNavigationController ()<UINavigationControllerDelegate>

@end

@implementation LKNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        //自定义了leftBarButtonItem之后，返回功能消失，需要添加这么一句：
        self.interactivePopGestureRecognizer.delegate = (id <UIGestureRecognizerDelegate>)self;
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
