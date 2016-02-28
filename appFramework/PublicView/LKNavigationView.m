//
//  LKNavigationView.m
//  Luckeys
//
//  Created by lishaowei on 15/12/3.
//  Copyright © 2015年 Luckeys. All rights reserved.
//

#import "LKNavigationView.h"

#define kButtonSize CGSizeMake(44, 44)
#define kNaviLeftButtonAdjustDistance   BoundsOfScale(10.0)    //距离边界距离
#define kNaviRightButtonAdjustDistance  BoundsOfScale(10.0)

@interface LKNavigationView ()
{
    UIImageView *_bgImgView;    //背景
    UILabel *_titleLab;     //title文本
}
@end

@implementation LKNavigationView

@synthesize textField = _textField;
@synthesize delegate = _delegate;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        UIView *lineView=[[UIView alloc] initWithFrame:CGRectMake(0, self.maxY-SINGLE_LINE_ADJUST_OFFSET, self.width, SINGLE_LINE_BOUNDS)];
        lineView.backgroundColor = UIColorRGB(0xe9e9e9);
        [self addSubview:lineView];
        [self bringSubviewToFront:lineView];
    }
    return self;
}

-(void)setNavigationBackgroundColor:(UIColor *)bgColor andBackgroundImage:(NSString *)imageName{
    if (imageName == nil && bgColor == nil) {
        return;
    }
    
    if(bgColor){
        if (!CGColorEqualToColor(self.backgroundColor.CGColor, bgColor.CGColor)) {
            self.backgroundColor = bgColor;
            if (nil == _bgImgView) {
                _bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
                _bgImgView.contentMode = UIViewContentModeScaleToFill;
                [self addSubview:_bgImgView];
                
            }
            _bgImgView.image = [UIColor createImageWithColor:bgColor];
        }
    }
    
    if (imageName.length > 0) {
        if (_bgImgView == nil) {
            _bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
            _bgImgView.contentMode = UIViewContentModeScaleToFill;
            [self addSubview:_bgImgView];
        }
        if ([imageName hasPrefix:@"http:"]) {
            [_bgImgView sd_setImageWithURL:[NSURL URLWithString:imageName]];
        }
        else {
            _bgImgView.image = [UIImage imageWithName:imageName];
        }
    }
    [self sendSubviewToBack:_bgImgView];
}

-(void)setNavigationTitle:(NSString*)title titleColor:(UIColor*)color titleFont:(UIFont*)font
{
    if(title == nil)
    {
        return;
    }
    
    UIFont *txtFont = font ? font : [UIFont systemFontOfSize:18];
    CGFloat tilteYY = (UI_NavView_height-20-20)/2+20;
    CGFloat lineH = 20;
    
    if(_titleLab == nil){
        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(kButtonSize.width+kNaviLeftButtonAdjustDistance,tilteYY,self.frame.size.width - 2*kNaviLeftButtonAdjustDistance - 2*kButtonSize.width,lineH)];
//        [_titleLab setCenter:CGPointMake(self.frame.size.width / 2, self.frame.size.height - (kButtonSize.height + 4) / 2)];
        _titleLab.backgroundColor = [UIColor clearColor];
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.tag = 4043;
        [self addSubview:_titleLab];
    }
    
    CGSize detailSize = [title sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(200, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    
    if (detailSize.width > _titleLab.frame.size.width)
    {
        title = [NSString stringWithFormat:@"%@...",[title substringToIndex:12]];
        txtFont = [UIFont systemFontOfSize:15];
    }
    
    UIColor *txtColor = color ? color : [UIColor blackColor];
    _titleLab.textColor = txtColor;
    _titleLab.font = txtFont;
    _titleLab.text = title;
}


//左侧按钮设置
- (void)addLeftButtonImage:(NSString *)imageString
{
    [self addNavButtonImageWith:imageString selectdImageWith:nil titleWith:nil titleColorWith:nil selectdColorWith:nil fontWith:nil directionWith:NO];
}

- (void)addLeftButtonImageWith:(NSString *)imageString selectdWith:(NSString *)selectdString
{
    [self addNavButtonImageWith:imageString selectdImageWith:selectdString titleWith:nil titleColorWith:nil
                selectdColorWith:nil fontWith:nil  directionWith:NO];
}

- (void)addLeftButtonTitleWith:(NSString *)titleString titleColorWith:(UIColor *)titleColor fontWith:(UIFont *)font
{
    [self addNavButtonImageWith:nil selectdImageWith:nil titleWith:titleString titleColorWith:titleColor
                selectdColorWith:nil fontWith:font directionWith:NO];
}

- (void)addLeftButtonTitleWith:(NSString *)titleString titleColorWith:(UIColor *)titleColor selectdColorWith:(UIColor *)selectdColor fontWith:(UIFont *)font
{
    [self addNavButtonImageWith:nil selectdImageWith:nil titleWith:titleString titleColorWith:titleColor
                selectdColorWith:selectdColor fontWith:font directionWith:NO];
}

//右侧按钮设置
- (void)addRightButtonImage:(NSString *)imageString
{
    [self addNavButtonImageWith:imageString selectdImageWith:nil titleWith:nil titleColorWith:nil selectdColorWith:nil fontWith:nil directionWith:YES];
}

- (void)addRightButtonImageWith:(NSString *)imageString selectdWith:(NSString *)selectdString
{
    [self addNavButtonImageWith:imageString selectdImageWith:selectdString titleWith:nil titleColorWith:nil
               selectdColorWith:nil fontWith:nil  directionWith:YES];
}

- (void)addRightButtonTitleWith:(NSString *)titleString titleColorWith:(UIColor *)titleColor fontWith:(UIFont *)font
{
    [self addNavButtonImageWith:nil selectdImageWith:nil titleWith:titleString titleColorWith:titleColor
               selectdColorWith:nil fontWith:font directionWith:YES];
}

- (void)addRightButtonTitleWith:(NSString *)titleString titleColorWith:(UIColor *)titleColor selectdColorWith:(UIColor *)selectdColor fontWith:(UIFont *)font
{
    [self addNavButtonImageWith:nil selectdImageWith:nil titleWith:titleString titleColorWith:titleColor selectdColorWith:selectdColor fontWith:font directionWith:YES];
}

/**
 *  设置导航栏按钮
 *
 *  @param imageString        图片
 *  @param selectdImageString 选中图片
 *  @param titleString        title
 *  @param titleColor         title颜色
 *  @param selectdColor       title选中颜色
 *  @param font               字体大小
 *  @param directionBool      左右位置（NO左侧  YES右侧）
 */
- (void)addNavButtonImageWith:(NSString *)imageString selectdImageWith:(NSString *)selectdImageString titleWith:(NSString *)titleString titleColorWith:(UIColor *)titleColor selectdColorWith:(UIColor *)selectdColor fontWith:(UIFont *)font directionWith:(BOOL)directionBool
{
    if (!directionBool)
    {
        UIButton *leftButton = nil;
        if ([self viewWithTag:20000])
        {
            leftButton = [self viewWithTag:20000];
        }
        else
        {
            leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        }
        if (imageString.length > 0)
        {
            leftButton.frame = CGRectMake(0, 20, kButtonSize.width, kButtonSize.height);

            [leftButton setImage:[UIImage imageWithName:imageString] forState:UIControlStateNormal];
            if (selectdImageString.length > 0)
            {
                [leftButton setImage:[UIImage imageWithName:selectdImageString] forState:UIControlStateHighlighted];
            }
        }
        else
        {
            leftButton.frame = CGRectMake(BoundsOfScale(8), 20, kButtonSize.width, kButtonSize.height);

            [leftButton setTitleColor:titleColor forState:UIControlStateNormal];
            if (font)
            {
                leftButton.titleLabel.font = font;
            }
            else
            {
                leftButton.titleLabel.font = [UIFont systemFontOfSize:14];
            }
            [leftButton setTitle:titleString forState:UIControlStateNormal];
            if (selectdColor)
            {
                [leftButton setTitleColor:titleColor forState:UIControlStateHighlighted];
            }
        }
        leftButton.tag = 20000;
        [self addSubview:leftButton];
        [leftButton addTarget:self action:@selector(changeLeftBtnInside) forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        UIButton *rightButton = nil;
        if ([self viewWithTag:20001])
        {
            rightButton = [self viewWithTag:20001];
        }
        else
        {
            rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        }
        if (imageString.length > 0)
        {
            rightButton.frame = CGRectMake(self.width-kButtonSize.width, 20, kButtonSize.width, kButtonSize.height);

            [rightButton setImage:[UIImage imageWithName:imageString] forState:UIControlStateNormal];
            if (selectdImageString.length > 0)
            {
                [rightButton setImage:[UIImage imageWithName:selectdImageString] forState:UIControlStateHighlighted];
            }
        }
        else
        {
            rightButton.frame = CGRectMake(self.width-kButtonSize.width-BoundsOfScale(8), 20, kButtonSize.width, kButtonSize.height);

            [rightButton setTitleColor:titleColor forState:UIControlStateNormal];
            if (font)
            {
                rightButton.titleLabel.font = font;
            }
            else
            {
                rightButton.titleLabel.font = [UIFont systemFontOfSize:14];
            }
            [rightButton setTitle:titleString forState:UIControlStateNormal];
            if (selectdColor)
            {
                [rightButton setTitleColor:titleColor forState:UIControlStateHighlighted];
            }
        }
        rightButton.tag = 20001;
        [self addSubview:rightButton];
        [rightButton addTarget:self action:@selector(changeRightBtnInside) forControlEvents:UIControlEventTouchUpInside];
    }
    
}

/**
 *  移除左侧按钮
 */
- (void)removeLeftBtn
{
    UIButton *button = (UIButton *)[self viewWithTag:20000];
    if (button)
    {
        [button removeFromSuperview];
    }
}

/**
 *  移除右侧按钮
 */
- (void)removeRightBtn
{
    UIButton *button = (UIButton *)[self viewWithTag:20001];
    if (button)
    {
        [button removeFromSuperview];
    }
}

- (void)changeLeftBtnInside
{
    if ([self.delegate respondsToSelector:@selector(changeNavLeftBtnInside)])
    {
        [self.delegate changeNavLeftBtnInside];
    }
}

- (void)changeRightBtnInside
{
    if ([self.delegate respondsToSelector:@selector(changeNavRightBtnInside)])
    {
        [self.delegate changeNavRightBtnInside];
    }
}

@end
