//
//  PBUILabel.h
//  Luckeys
//
//  Created by BearLi on 15/11/15.
//  Copyright © 2015年 Luckeys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PBUILabel : UILabel

/** 系统字体大小 */
@property (nonatomic,assign) CGFloat systemFont;

@end

@interface UILabel (BoundsCate)

/**
 *  根据text计算宽度
 *
 *  @return 返回label的宽度
 */
- (CGFloat)widthWithText;

/**
 *  计算高度
 *
 *  @return 返回高度
 */
- (CGFloat)heightWithText;

@end
