//
//  PBTableView.m
//  Luckeys
//
//  Created by BearLi on 15/9/26.
//  Copyright © 2015年 Luckeys. All rights reserved.
//

#import "PBTableView.h"

@interface PBTableView ()<UIScrollViewDelegate>

@property (nonatomic,assign) CGFloat topHeight;
@property (nonatomic,assign) CGFloat topY;
@property (nonatomic,assign) CGFloat currentOffSet;

@end

@implementation PBTableView


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.backgroundColor = [UIColor clearColor];
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    
    //tableView 上 add button 快速点击看不到效果和焦点在按钮上滑动时，滑不动的解决方案
    for (id view in self.subviews)
    {
        // looking for a UITableViewWrapperView
        if ([NSStringFromClass([view class]) isEqualToString:@"UITableViewWrapperView"])
        {
            // this test is necessary for safety and because a "UITableViewWrapperView" is NOT a UIScrollView in iOS7
            if([view isKindOfClass:[UIScrollView class]])
            {
                // turn OFF delaysContentTouches in the hidden subview
                UIScrollView *scroll = (UIScrollView *) view;
                scroll.delaysContentTouches = NO;
            }
            break;
        }
    }
    self.delaysContentTouches = NO;

}

- (BOOL)touchesShouldCancelInContentView:(UIView *)view
{
    return YES;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
