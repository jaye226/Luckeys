//
//  UILabel+BoundsCate.m
//  MLPlayer
//
//  Created by BearLi on 15/11/16.
//  Copyright © 2015年 w. All rights reserved.
//

#import "UILabel+BoundsCate.h"
#import <objc/runtime.h>

@implementation UILabel (BoundsCate)

static const char kSystemFontKey = 'f';

- (void)setSystemFont:(CGFloat)systemFont {
    if (systemFont != self.systemFont) {
        self.font = [UIFont systemFontOfSize:systemFont];
        NSNumber * number = [NSNumber numberWithFloat:systemFont];
        
        [self willChangeValueForKey:@"systemFont"];
        objc_setAssociatedObject(self, &kSystemFontKey,number, OBJC_ASSOCIATION_ASSIGN);
        [self didChangeValueForKey:@"systemFont"];
    }
}

- (CGFloat)systemFont {
    id obj = objc_getAssociatedObject(self, &kSystemFontKey);
    
    if (obj && [obj isKindOfClass:[NSNumber class]]) {
        return  ((NSNumber*)obj).floatValue;
    }
    else {
        //如果没取到,返回系统初始17.
        return 17.0;
    }
}

- (CGFloat)widthForText {
    if (self.text.length == 0) {
        return CGRectGetWidth(self.bounds);
    }
    
    CGRect rect = [self computeRectConstantWidth:NO];
    return rect.size.width;
}


- (CGFloat)heightForText {
    if (self.text.length == 0) {
        return CGRectGetHeight(self.bounds);
    }
    CGRect rect = [self computeRectConstantWidth:YES];
    return rect.size.height;
}

/**
 *  计算文本Rect
 *
 *  @param widthConst 宽是否已知不变
 *
 *  @return 返回Rect
 */
- (CGRect)computeRectConstantWidth:(BOOL)widthConst {
//    NSMutableParagraphStyle * style = [[NSMutableParagraphStyle alloc] init];
//    style.lineBreakMode = self.lineBreakMode;
//    style.alignment = self.textAlignment;
//    NSDictionary * attDict = @{NSForegroundColorAttributeName:self.textColor,
//                               NSFontAttributeName:self.font,
//                               NSParagraphStyleAttributeName:style
//                               };
    CGSize size = CGSizeZero;
    if (widthConst) {
        //宽固定,算高
        size = CGSizeMake(CGRectGetWidth(self.bounds), 100000.0);
    }
    else {
        size = CGSizeMake(100000.0, CGRectGetHeight(self.bounds));
    }
    CGRect rect = CGRectZero;

    CGSize comSize = [self.text sizeWithFont:self.font constrainedToSize:size lineBreakMode:self.lineBreakMode];
    rect = CGRectMake(0, 0, comSize.width,comSize.height);
    
    return rect;
}

@end
