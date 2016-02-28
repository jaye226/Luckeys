//
//  PADeviceInfo.h
//  MLPlayer
//
//  Created by txt on 15/6/20.
//  Copyright (c) 2015年 w. All rights reserved.
//

#import <Foundation/Foundation.h>

# if ! __has_feature(objc_arc)
#define CMRELEASE(x) if (x != nil) {[x release];}
# else
#define CMRELEASE(__x)
# endif

#define STR_IS_NULL(str)  (str)?(str):@""

/*========================================屏幕适配============================================*/

#define kSystemVesion [[[UIDevice currentDevice] systemVersion] floatValue]

#define kNavBarHeight 64.0

#define CURR_IOS_DEVICE_VERSION [[[UIDevice currentDevice] systemVersion] floatValue] //获取当前系统版本号

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define __iOS6  ((CURR_IOS_DEVICE_VERSION >= 6.0) ? YES : NO)
#define __iOS5  ((CURR_IOS_DEVICE_VERSION >= 5.0 && CURR_IOS_DEVICE_VERSION < 6.0) ? YES : NO)
#define LowerThaniOS6  ((CURR_IOS_DEVICE_VERSION < 6.0) ? YES : NO)

#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define IS_IPHONE_6 ((IS_IPHONE) && (SCREEN_MAX_LENGTH == 667.0))
#define IS_IPHONE_6P ((IS_IPHONE) && (SCREEN_MAX_LENGTH == 736.0))
#define UI_iphone5_WIDTH 320.0
#define  kNaviRightButtonX  (UI_IOS_WINDOW_WIDTH * (10.0 / 320))

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200

#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#define UI_IOS_WINDOW_WIDTH (isPad?1024:([[UIScreen mainScreen] bounds].size.width))
#define UI_IOS_WINDOW_HEIGHT (isPad?768:([[UIScreen mainScreen] bounds].size.height))

#define UI_NavView_height   64.0

//屏幕适配ui尺寸
#define BoundsOfScale(x) (x)*(UI_IOS_WINDOW_WIDTH/320.0)

//6p字体尺寸+2
#define FontOfScale(font) (IS_IPHONE_6P ? (font+2) :(font))

//设置1像素分割线
#define SINGLE_LINE_BOUNDS          (1 / [UIScreen mainScreen].scale)
#define SINGLE_LINE_ADJUST_OFFSET   ((1 / [UIScreen mainScreen].scale) / 2)

#endif

/*========================================屏幕适配============================================*/

#define kNavHeight  64 //只支持iOS7以上，高度为状态栏加上导航栏高度
#define kTabBarHeight 49  //底部tarheight高度
#define kPagesNavHeight 40

#define kIOSVersions [[[UIDevice currentDevice] systemVersion] floatValue] //获得iOS版本
#define kIS_IOS8     (kIOSVersions >= 8.0)  //获得iOS版本
#define kUIWindow    [[[UIApplication sharedApplication] delegate] window] //获得window

/*========================================颜色定义============================================*/

#define UIColorRGBA(color,nAlpha) UIColorMakeRGBA(color>>16, (color&0x00ff00)>>8,color&0x0000ff,nAlpha)
#define UIColorMakeRGBA(r, g, b, a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:a]

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define ColorWithRGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]

#define UIColorMakeRGB(nRed, nGreen, nBlue) UIColorMakeRGBA(nRed, nGreen, nBlue, 1.0f)
#define UIColorRGB(color) UIColorMakeRGB(color>>16, (color&0x00ff00)>>8,color&0x0000ff)


#define LEARN_DESC_COLOR		[UIColor colorWithRed:136.0f/255.0f green:136.0f/255.0f blue:136.0f/255.0f alpha:1.0f];










