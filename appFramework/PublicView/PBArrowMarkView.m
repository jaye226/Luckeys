//
//  PBArrowMarkView.m
//  Luckeys
//
//  Created by BearLi on 15/10/2.
//  Copyright © 2015年 Luckeys. All rights reserved.
//

#import "PBArrowMarkView.h"

@implementation PBArrowMarkView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    _fillColor = UIColorMakeRGBA(0, 0, 0, 0.7);
    _arrowWidth = 15;
    _arrowHeight = 10;
    _arrowDirection = eArrowDirectionDown;
    _realWidth = self.superview ? CGRectGetWidth(self.superview.bounds) : UI_IOS_WINDOW_WIDTH;
    self.backgroundColor = [UIColor clearColor];
}

- (void)setFillColor:(UIColor *)fillColor
{
    if (_fillColor != fillColor && fillColor) {
        _fillColor = fillColor;
        [self setNeedsDisplay];
    }
}

- (void)setArrowDirection:(eArrowDirection)arrowDirection
{
    if (_arrowDirection != arrowDirection) {
        _arrowDirection = arrowDirection;
        [self setNeedsDisplay];
    }
}


- (void)setArrowPoint:(CGPoint)arrowPoint
{
    _arrowPoint = arrowPoint;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    //重新计算箭头坐标
    self.centerX = _arrowPoint.x;
    CGPoint point = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetHeight(self.bounds));
    CGFloat maxWidth = _realWidth;
    CGFloat minWidth = 0;
    switch (_arrowDirection) {
        case eArrowDirectionDown :
        case eArrowDirectionUp:
            if (_arrowPoint.x + CGRectGetMidX(self.bounds) > maxWidth) {
                //超过最大长度
                point.x = CGRectGetWidth(self.bounds)- (maxWidth - _arrowPoint.x);
                self.centerX = maxWidth-CGRectGetMidX(self.bounds);
            }
            else if (_arrowPoint.x - CGRectGetMidX(self.bounds) < minWidth)
            {
                //小于起始点
                point.x = _arrowPoint.x;
                self.centerX = minWidth + CGRectGetMidX(self.bounds);
            }
            break;
        case eArrowDirectionLeft | eArrowDirectionRight:
            
            break;
        default:
            break;
    }
    _arrowPoint = point;
    
    
    //draw view
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, _fillColor.CGColor);
    
    if (_arrowDirection == eArrowDirectionDown) {
        CGContextMoveToPoint(context,0, 0);
        CGContextAddLineToPoint(context, CGRectGetWidth(self.bounds), 0);
        CGContextAddLineToPoint(context, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - _arrowHeight);
        CGContextAddLineToPoint(context, 0, CGRectGetHeight(self.bounds)-_arrowHeight);
        CGContextAddLineToPoint(context, 0, 0);
        CGContextFillPath(context);
        
        CGContextMoveToPoint(context, _arrowPoint.x, self.bounds.size.height);
        CGContextAddLineToPoint(context, _arrowPoint.x-_arrowWidth/2.0, self.bounds.size.height - _arrowHeight);
        CGContextAddLineToPoint(context, _arrowPoint.x+_arrowWidth/2.0, self.bounds.size.height - _arrowHeight);
        CGContextAddLineToPoint(context, _arrowPoint.x, self.bounds.size.height);
        CGContextFillPath(context);
    }
    else if (_arrowDirection == eArrowDirectionUp)
    {
        CGContextMoveToPoint(context,0, _arrowHeight);
        CGContextAddLineToPoint(context, CGRectGetWidth(self.bounds), _arrowHeight);
        CGContextAddLineToPoint(context, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
        CGContextAddLineToPoint(context, 0, CGRectGetHeight(self.bounds));
        CGContextAddLineToPoint(context, 0, _arrowHeight);
        CGContextFillPath(context);
        
        CGContextMoveToPoint(context, _arrowPoint.x, 0);
        CGContextAddLineToPoint(context, _arrowPoint.x-_arrowWidth/2.0, _arrowHeight);
        CGContextAddLineToPoint(context, _arrowPoint.x+_arrowWidth/2.0, _arrowHeight);
        CGContextAddLineToPoint(context, _arrowPoint.x, 0);
        CGContextFillPath(context);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
