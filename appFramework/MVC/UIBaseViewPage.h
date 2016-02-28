//
//  PABaseViewPage.h
//  MLPlayer
//
//  Created by txt on 15/6/3.
//  Copyright (c) 2015年 w. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NBaseModel.h"
#import "NBaseController.h"

@protocol UIBaseViewPageDelegate <NSObject>

- (void)pushViewPage:(NSString *)viewPageName paramsWith:(NSDictionary *)dic;

@end

//@class NBaseController;

@interface UIBaseViewPage : UIViewController<NModelDelegate>

//控制逻辑的控制器,它指向子类创建的具体控制器对象
@property(nonatomic,strong)  NBaseController  *controller;

//是否可以有手势滑动操作,默认为YES
@property(nonatomic,assign)  BOOL  canSlidGesture;

@property(nonatomic, weak) id<UIBaseViewPageDelegate> delegate;

/**
 *  初始化基类对象,由子类覆盖实现自定义传参处理,基类默认空实现
 *
 *  @param paramInfo  外部传进来的参数字典信息
 *
 */
- (void)initWithParam:(NSDictionary *)paramInfo;

/**
 *  从前一个页面返回,由具体子类,父类空现实
 *
 *  @param paramInfo 前一个页面,返回带回的参数
 */
- (void)backViewWithParam:(NSDictionary *)paramInfo;

/**
 *  通过类名注册具体的控制器
 *
 *  @param controllerName 控制器的类名
 */
- (void)registController:(NSString*)controllerName;

/**
 *  数据变化更新UI接口,由具体的子类覆盖实现,基类默认实现为nil
 *
 *  @param data   数据对象 1.如果数据读取成功,代表数据对象模型;2.如果数据读取失败,代表错误信息
 *  @param msgID  消息命令
 *  @param errCode 错误码,0代表成功,其它值代表相应的错误码,see the enum EDataStatusCode
 */
- (void)update:(id)data msgID:(int)msgid faildCode:(EDataStatusCode)errCode;

/**
 *  处理数据接口,由子类实现,父类实现不NULL,一般用在 网络上传,下载数据,数据解压等
 *
 *  @param msgID 消息ID
 *  @param rate  数据处理进度
 */
- (void)handleData:(int)msgID progress:(float)rate;

/**
 *  添加导航栏左按钮 (标题)
 *
 *  @param title          标题
 *  @param normalColor    正常色
 *  @param highlightColor 高亮色
 */
- (void)setLeftBarButtonItemTitle:(NSString*)title titleColor:(UIColor*)normalColor highlightColor:(UIColor*)highlightColor;

- (void)setRightBarButtonItemTitle:(NSString*)title titleColor:(UIColor*)normalColor highlightColor:(UIColor*)highlightColor;

/**
 *  添加导航栏左按钮 (图片)
 *
 *  @param normalimage    正常图片
 *  @param highlightImage 高亮图片
 */
- (void)setLeftBarButtonItemImage:(UIImage*)normalimage  highlightImage:(UIImage*)highlightImage;

- (void)setRightBarButtonItemImage:(UIImage*)normalimage  highlightImage:(UIImage*)highlightImage;
/**
 *  左导航栏按钮时间,子类覆盖实现
 *
 *  @param button 按钮对象
 */
- (void)handlerLeftAction:(UIButton*)button;

- (void)handlerRightAction:(UIButton*)button;

@end

//页面跳转所有接口
@interface UIBaseViewPage(UINavigator)

/**
 *  页面跳转,默认push动画
 *
 *  @param pageName 跳转页面
 */
-(void)pushPageWithName:(NSString*)pageName;

-(void)pushPageWithName:(NSString*)pageName withParams:(NSDictionary*)pararmInfo;

/**
 *  页面跳转
 *
 *  @param pageName  跳转的页面类
 *  @param animation 是否带动画
 */
-(void)pushPageWithName:(NSString*)pageName animation:(BOOL)animation;

/**
 *  页面跳转
 *
 *  @param pageName   页面类名
 *  @param animation  是否开启动画
 *  @param pararmInfo 传参信息
 */
-(void)pushPageWithName:(NSString*)pageName animation:(BOOL)animation withParams:(NSDictionary*)pararmInfo;

//弹出页面
- (void)popViewPageAnimated:(BOOL)animated;
//弹出页面,并且带回参数
- (void)popViewPageAnimated:(UIViewController*)viewPage withAnimated:(BOOL)animated withParams:(NSDictionary*)paramInfo;

//弹回到根页面
- (void)popToRootViewPageAnimated:(BOOL)animated;

//页面跳转 上下页面切换
- (void)presentViewPage:(NSString*)pageName animated:(BOOL)animation completion:(void (^)(void))completion;
//页面跳转 上下页面切换
- (void)presentViewPage:(NSString*)pageName animated:(BOOL)animation paramInfo:(NSDictionary *)info completion:(void (^)(void))completion;

- (void)dismissViewPageAnimated:(BOOL)animation completion:(void (^)(void))completion;

@end






