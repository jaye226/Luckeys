//
//  UIImage+Extra.h
//  KaiKaiBa
//
//  Created by lishaowei on 15/8/2.
//  Copyright (c) 2015年 battery. All rights reserved.
//

#import <UIKit/UIKit.h>

#define UIImageNamed(_name)     [UIImage imageWithName:_name]

@interface UIImage (Extra)

+ (UIImage *)imageWithName:(NSString *)imageName;

+ (UIImage *)imageScaleNamed:(NSString *)name;

+ (UIImage *)imageWithColor:(UIColor *)color;

+ (NSData *)UIImageExchangeToNSData:(UIImage *)aImage;

- (UIImage *)scaleImageToScale:(float)scaleSize;

/**
 *  毛玻璃效果
 *
 *  @param blur         模糊度  0~1
 *  @param tintColor    背景填充色 ,可nil
 *
 *  @return 毛玻璃图
 */
-(UIImage *)boxblurImageWithBlur:(CGFloat)blur tintColor:(UIColor*)tintColor;

-(UIImage *)boxblurImageWithBlur:(CGFloat)blur;

@end
