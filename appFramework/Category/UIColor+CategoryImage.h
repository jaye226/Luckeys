//
//  UIColor+CategoryImage.h
//  KaiKaiBa
//
//  Created by SunChao on 15/7/25.
//  Copyright (c) 2015年 battery. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (CategoryImage)


+ (UIImage*)createImageWithColor: (UIColor*) color;
+ (UIImage*)createLongImageWithColor: (UIColor*) color;

@end



@interface UIColor (Hex)

+ (UIColor *)colorWithHex:(long)hexColor;
+ (UIColor *)colorWithHex:(long)hexColor alpha:(float)opacity;

@end