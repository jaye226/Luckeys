//
//  LKBaskView.m
//  CardBrowser
//
//  Created by BearLi on 15/10/12.
//  Copyright © 2015年 llx. All rights reserved.
//

#import "LKBaskView.h"

#define kBaskButtonTag 234
#define kBaskLabelTag  342

@interface LKBaskView ()
{
    
    NSInteger _startIndex;
    NSInteger _endIndex;
    BOOL _isShow;
    
    BOOL _isClick;
}

@property (nonatomic,strong) NSMutableArray * buttonsAry;
@property (nonatomic,strong) NSMutableArray * frameAry;

@end

@implementation LKBaskView

- (void)dealloc
{
    _delegate = nil;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (id) init;
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    
    self.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backTapGestureRecognizer:)];
    [self addGestureRecognizer:tap];
    
    _buttonsAry = [NSMutableArray arrayWithCapacity:0];
    _frameAry = [NSMutableArray arrayWithCapacity:0];

    UIImageView * backImage = [[UIImageView alloc] initWithFrame:self.bounds];
    backImage.image = [[UIImage imageWithName:@"login_bg"] boxblurImageWithBlur:1];
    [self addSubview:backImage];
    
    NSInteger lineCount = 3;
    NSInteger count = 6;
    
    NSArray * imageArray = @[@"btn01",@"btn02",@"btn03",@"btn04",@"btn05",@"btn06"];
    NSArray * selArray = @[@"btn01_pressed",@"btn02_pressed",@"btn03_pressed",@"btn04_pressed",@"btn05_pressed",@"btn06_pressed"];
    NSArray * titleArray = @[@"朋友圈",@"好友",@"QQ好友",@"新浪微博",@"复制链接",@"本地"];

    NSMutableArray * frameAry = [[NSMutableArray alloc] initWithCapacity:count];
    NSMutableArray * btnAty = [[NSMutableArray alloc] initWithCapacity:count];
    
//    NSInteger line = count%lineCount ==0 ? count/lineCount : count/lineCount+1;   //行数
    
    CGFloat width = 122/2.0;
    CGFloat height = 122/2.0;
    
    //每行的间距
    CGFloat edge = 20;
    CGFloat font = 15;
    if (self.window.bounds.size.height < 568) {
        width = height = 110/2.0;
        font = 13.5;
    }

    CGFloat yOffSet = CGRectGetMidY(self.bounds);
    CGFloat space = (CGRectGetWidth(self.bounds)-count*width)/(count+1);
    space = (CGRectGetWidth(self.bounds)-lineCount*width)/(lineCount+1);
    for (int i = 0; i < count; i ++) {
        
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(space + i%lineCount * (space +width),CGRectGetHeight(self.bounds), width, height+20+5)];
        view.backgroundColor = [UIColor clearColor];
        [self addSubview:view];
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0,0, width, height);
        [button setImage:[UIImage imageNamed:imageArray[i%count]] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:selArray[i%count]] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = kBaskButtonTag +i;
        [view addSubview:button];
        
        CGRect rect = CGRectMake(space + i%lineCount * (space +width),yOffSet+i/lineCount*(height+20+5 +edge), width, view.bounds.size.height);
        [frameAry addObject:[NSValue  valueWithCGRect:rect]];
        [btnAty addObject:view];
        
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(button.frame.origin.x, button.frame.origin.y + button.bounds.size.height + 5, button.bounds.size.width, 20)];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:font];
        label.textColor = [UIColor whiteColor];
        label.tag = kBaskLabelTag+i;
        label.text = titleArray[i];
        [view addSubview:label];
        
    }
    [_buttonsAry removeAllObjects];
    [_buttonsAry addObjectsFromArray:btnAty];
    [_frameAry removeAllObjects];
    [_frameAry addObjectsFromArray:frameAry];
    
    _startIndex = 0;
    _endIndex = count-1;
    _isShow = YES;
    _isClick = NO;
    
    [self stratAnimation];
}

- (void)backTapGestureRecognizer:(UITapGestureRecognizer *)tap
{
    [self dismiss];
}

- (void)stratAnimation
{
    [UIView beginAnimations:@"ShortcutsShow" context:nil];
    [UIView setAnimationDuration:0.25];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationWillStartSelector:@selector(animationStarted)];
    [UIView setAnimationDidStopSelector:@selector(animationStoped)];
    if (_isShow == NO) {
        
        UIButton * btn = [_buttonsAry objectAtIndex:_endIndex];
        btn.frame = CGRectMake(btn.frame.origin.x, CGRectGetHeight(self.bounds), CGRectGetWidth(btn.bounds), CGRectGetHeight(btn.bounds));
        _endIndex --;
    }
    else
    {
        UIButton * btn = [_buttonsAry objectAtIndex:_startIndex];
        CGRect rect = [[_frameAry objectAtIndex:_startIndex] CGRectValue];
        
        btn.frame = rect;
        CAKeyframeAnimation * animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.y"];
        animation.delegate = self;
        animation.duration = 0.5;
        animation.values = @[@(-35),@(0)];
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [btn.layer addAnimation:animation forKey:@"transformY"];
        _startIndex ++;
        
    }
    
    [UIView commitAnimations];
}

- (void)animationStarted
{
    if (_isShow == NO) {
        if (_endIndex < 0) {
            return;
        }
    }
    else
    {
        if (_startIndex >= _buttonsAry.count) {
            return;
        }
    }
    [self stratAnimation];
}

//动画结束后跳转
- (void)animationStoped
{
    

}


- (void)buttonClick:(UIButton*)button
{
    if ( _isShow) {
        _isShow = NO;
        [self stratAnimation];
        
        [UIView animateWithDuration:0.25 animations:^{
            
        } completion:^(BOOL finished) {
            [self dismiss];
            if (_delegate && [_delegate respondsToSelector:@selector(handleBaskButtonAction:)]) {
                [_delegate handleBaskButtonAction:button.tag - kBaskButtonTag];
            }
        }];
    }
}

- (void)dismiss
{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.alpha = 0;
    self.backgroundColor = [UIColor clearColor];
    [self removeFromSuperview];
    
    if (_isClick == YES ) {
        _isClick = NO;

    }
}

- (void)updateIsShareLocal:(BOOL)isShareLocal
{
    self.isShareLocal = isShareLocal;
    if (!isShareLocal)
    {
        UIView *buttonView = [self viewWithTag:kBaskButtonTag+_buttonsAry.count-1];
        buttonView.hidden = YES;
        UIView *labelView = [self viewWithTag:kBaskLabelTag+_buttonsAry.count-1];
        labelView.hidden = YES;
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
