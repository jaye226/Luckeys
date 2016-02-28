//
//  UILabel+BoundsCate.h
//  MLPlayer
//
//  Created by BearLi on 15/11/16.
//  Copyright © 2015年 w. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (BoundsCate)

/**
 *  字体的大小
 *  [UIFont systemFontOfSize:systemFont]
 */
@property (nonatomic,assign) CGFloat systemFont;

/**
 *  计算Text的宽, (固定高的情况下)
 *
 *  @return 返回文本宽度
 */
- (CGFloat)widthForText;

/**
 *  计算Text的高, (固定宽的情况下)
 *
 *  @return 返回文本高度
 */
- (CGFloat)heightForText;

@end
