//
//  LKNavigationView.h
//  Luckeys
//
//  Created by lishaowei on 15/12/3.
//  Copyright © 2015年 Luckeys. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LKNavigationViewDelegate <NSObject>

- (void)changeNavLeftBtnInside;

- (void)changeNavRightBtnInside;

@end

@interface LKNavigationView : UIView

@property(nonatomic,strong)UITextField *textField;

@property (nonatomic,weak) id <LKNavigationViewDelegate> delegate;

/**
 *  设置导航栏背景
 *
 *  @param bgColor
 *  @param imageName 
 */
-(void)setNavigationBackgroundColor:(UIColor *)bgColor andBackgroundImage:(NSString *)imageName;

/**
 *  设置导航栏title
 *
 *  @param title
 *  @param color
 *  @param font  
 */
-(void)setNavigationTitle:(NSString*)title titleColor:(UIColor*)color titleFont:(UIFont*)font;

/**
 *  设置导航栏左侧按钮 (只有图片)
 *
 *  @param imageString
 */
- (void)addLeftButtonImage:(NSString *)imageString;

/**
 *  设置导航栏左侧按钮 (只有图片)
 *
 *  @param imageString   默认图标
 *  @param selectdString 选择图标
 */
- (void)addLeftButtonImageWith:(NSString *)imageString selectdWith:(NSString *)selectdString;

/**
 *  设置导航栏左侧按钮 (文字)
 *
 *  @param titleString 显示文字
 *  @param titleColor  文字颜色
 *  @param font        字体大小
 */
- (void)addLeftButtonTitleWith:(NSString *)titleString titleColorWith:(UIColor *)titleColor fontWith:(UIFont *)font;

/**
 *  设置导航栏左侧按钮 (文字)
 *
 *  @param titleString  显示文字
 *  @param titleColor   文字颜色
 *  @param selectdColor 选中文字颜色
 *  @param font         字体大小
 */
- (void)addLeftButtonTitleWith:(NSString *)titleString titleColorWith:(UIColor *)titleColor selectdColorWith:(UIColor *)selectdColor fontWith:(UIFont *)font;

/**
 *  设置导航栏右侧按钮 (只有图片)
 *
 *  @param imageString
 */
- (void)addRightButtonImage:(NSString *)imageString;

/**
 *  设置导航栏右侧按钮 (只有图片)
 *
 *  @param imageString   默认图标
 *  @param selectdString 选择图标
 */
- (void)addRightButtonImageWith:(NSString *)imageString selectdWith:(NSString *)selectdString;

/**
 *  设置导航栏右侧按钮 (文字)
 *
 *  @param titleString 显示文字
 *  @param titleColor  文字颜色
 *  @param font        字体大小
 */
- (void)addRightButtonTitleWith:(NSString *)titleString titleColorWith:(UIColor *)titleColor fontWith:(UIFont *)font;

/**
 *  设置导航栏右侧按钮 (文字)
 *
 *  @param titleString  显示文字
 *  @param titleColor   文字颜色
 *  @param selectdColor 选中文字颜色
 *  @param font         字体大小
 */
- (void)addRightButtonTitleWith:(NSString *)titleString titleColorWith:(UIColor *)titleColor selectdColorWith:(UIColor *)selectdColor fontWith:(UIFont *)font;

/**
 *  移除左侧按钮
 */
- (void)removeLeftBtn;

/**
 *  移除右侧按钮
 */
- (void)removeRightBtn;

@end
