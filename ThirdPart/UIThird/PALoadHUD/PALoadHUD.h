//
//  PALoadHUD.h
//  MLPlayer
//
//  Created by BearLi on 15/9/11.
//  Copyright (c) 2015年 w. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString * const kHUDLoadMessage = @"加载中";

@interface PALoadHUD : UIView

@property (nonatomic,strong) NSString * message;

/**
 *  延迟消失时间,防止请求太快成功消失,默认0.5s
 */
@property (nonatomic,assign) CGFloat dismissDelay;


/**
 *  加载HUD
 *
 *  @param message 提示文本,可直接传 kHUDLoadMessage
 *  @param view    要添加的父视图
 *
 *  @return HUD
 */
+ (id)showLoadHUDWithMessage:(NSString*)message inView:(UIView*)view;

- (id)initWithMessage:(NSString*)message inView:(UIView*)view;

/**
 *  从父视图上获取HUD
 *
 *  @param view HUD的父视图
 *
 *  @return 返回HUD
 */
+ (PALoadHUD*)hudForView:(UIView*)view;

/**
 *  移除HUD,防止太快消失,默认延迟0.5s
 *
 *  @param view HUD的父视图
 */
+ (void)hideLoadHUDFromView:(UIView*)view;

+ (void)hideLoadHUDFromView:(UIView*)view aniamtionWith:(BOOL)aniamtion;

/**
 *  移除方法
 *
 *  @param aniamtion 动画
 */
- (void)dismiss:(BOOL)aniamtion;

- (void)dismiss:(BOOL)aniamtion afterTime:(CGFloat)delay;

@end
