//
//  PBArrowMarkView.h
//  Luckeys
//
//  Created by BearLi on 15/10/2.
//  Copyright © 2015年 Luckeys. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    eArrowDirectionDown = 0,
    eArrowDirectionUp,
    eArrowDirectionLeft,
    eArrowDirectionRight
} eArrowDirection;

/**
 *  箭头指示器view
 */
@interface PBArrowMarkView : UIView

@property (nonatomic,strong) UIColor * fillColor;

/**
 *  真实要显示的参照总长度
 */
@property (nonatomic,assign) CGFloat realWidth;

/**
 *  箭头宽度,默认 15;
 */
@property (nonatomic,assign) CGFloat arrowWidth;

/**
 *  箭头高度,默认 10;
 */
@property (nonatomic,assign) CGFloat arrowHeight;

/**
 *  箭头指向坐标
 */
@property (nonatomic,assign) CGPoint arrowPoint;

/**
 *  箭头方向,目前支持down,up
 *  default:down
 */
@property (nonatomic,assign) eArrowDirection arrowDirection;


@end
