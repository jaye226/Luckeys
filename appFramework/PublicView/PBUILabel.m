//
//  PBUILabel.m
//  Luckeys
//
//  Created by BearLi on 15/11/15.
//  Copyright © 2015年 Luckeys. All rights reserved.
//

#import "PBUILabel.h"

@implementation PBUILabel

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.backgroundColor = [UIColor clearColor];
    self.systemFont = 17.0;
}

- (void)setSystemFont:(CGFloat)systemFont {
    if (_systemFont != systemFont) {
        _systemFont = systemFont;
        self.font = [UIFont systemFontOfSize:_systemFont];
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


@implementation UILabel (BoundsCate)

- (CGFloat)widthWithText {
    if (self.text.length == 0) {
        return CGRectGetWidth(self.bounds);
    }
    CGRect rect = [self computeRectConstantWidth:NO];
    return rect.size.width;
}

- (CGFloat)heightWithText {
    if (self.text.length == 0) {
        return CGRectGetHeight(self.bounds);
    }
    CGRect rect = [self computeRectConstantWidth:YES];
    return rect.size.height;
}

- (CGRect)computeRectConstantWidth:(BOOL)widthConst {
    NSMutableParagraphStyle * style = [[NSMutableParagraphStyle alloc] init];
    style.lineBreakMode = self.lineBreakMode;
    style.alignment = self.textAlignment;
    
    NSDictionary * attDict = @{NSForegroundColorAttributeName:self.textColor,
                               NSFontAttributeName:self.font,
                               NSParagraphStyleAttributeName:style
                               };
    
    CGSize size = CGSizeZero;
    if (widthConst) {
        //宽固定,算高
        size = CGSizeMake(CGRectGetWidth(self.bounds), 100000);
    }
    else {
        size = CGSizeMake(100000, CGRectGetHeight(self.bounds));
    }
    CGRect rect = [self.text boundingRectWithSize:size
                                          options:NSStringDrawingUsesLineFragmentOrigin |   NSStringDrawingUsesFontLeading
                                       attributes:attDict
                                          context:NULL];
    return rect;
}

@end
