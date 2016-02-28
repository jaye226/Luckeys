
//
//  PBLoadMoreFooterView.m
//  TestLoadMoreFooter
//
//  Created by BearLi on 15/11/18.
//  Copyright © 2015年 llx. All rights reserved.
//

#import "PBLoadMoreFooterView.h"
#import <objc/message.h>

#define kLoadMoreStatusNormal   [LanguageManager pBLoadMorePullUpString];
#define kLoadMoreStatusPull     [LanguageManager pBLoadMoreReleaseString];
#define kLoadMoreStatusLoading  [LanguageManager pBLoadMoreLoadingString];
#define kLoadMoreStatusNoMore   [LanguageManager pBLoadMoreNoDataString];

CGFloat const kLoadMoreFooterHeight = 44.0;

NSString * const KeyPathScrollViewContentOffset = @"contentOffset";
NSString * const KeyPathScrollViewContentSize   = @"contentSize";
NSString * const KeyPathPanState      = @"state";

NSString * const kUDLoadMoreLastDate    =  @"PBLoadMoreLastDate";

@interface PBLoadMoreFooterView()

@property (nonatomic, assign) BOOL hideWhenNoData;

@property (nonatomic, strong) UIColor * textColor;

@property (nonatomic, assign) BOOL autoLoadMore;   //自动加载更多

@property (nonatomic, assign) BOOL hideLastTime;   //隐藏时间,默认YES

/** 如果设置了scorlView的contentInset.bottom,同步赋值*/
@property (nonatomic, assign) CGFloat ignoreBottom;

@property (nonatomic, strong) UIActivityIndicatorView * activityView;

@property (nonatomic, strong) UILabel * loadStatusLabel;

@property (nonatomic, strong) UILabel * lastTimeLabel;

@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;

@property (nonatomic, assign) UIEdgeInsets lastInsets;

@property (nonatomic, weak) id target;

@property (nonatomic, assign) SEL action;

@end

@implementation PBLoadMoreFooterView

- (void)dealloc
{
    [_activityView stopAnimating];
    [self removeObservers];
}

+ (instancetype)loadMoreViewWithBlock:(PBLoadMoreViewLoadingBlock)block {
    PBLoadMoreFooterView * footerView = [[self alloc] init];
    footerView.loadingBlock = nil;
    footerView.loadingBlock = [block copy];
    return footerView;
}

+ (instancetype)loadMoreViewWithTarget:(id)target action:(SEL)select {
    PBLoadMoreFooterView * footerView = [[self alloc] init];
    footerView.target = target;
    footerView.action = select;
    return footerView;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    // 如果不是UIScrollView，不做任何事情
    if (newSuperview && ![newSuperview isKindOfClass:[UIScrollView class]])
        return;
    
    [self removeObservers];
    if (newSuperview) {
        _scrollView = (UIScrollView*)newSuperview;
        CGRect frame = self.frame;
        frame.origin.x = 0;
        frame.origin.y = _scrollView.contentSize.height;
        frame.size.width = CGRectGetWidth(newSuperview.bounds);
        frame.size.height = kLoadMoreFooterHeight;
        self.frame = frame;
        self.ignoreBottom = _scrollView.contentInset.bottom;
        [self addObservers];
    }
    
}

- (void)setUp {
    if (CGRectGetWidth(self.bounds) <= 0 || CGRectGetHeight(self.bounds) < kLoadMoreFooterHeight) {
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, kLoadMoreFooterHeight);
    }
    self.backgroundColor = [UIColor clearColor];
    _hideLastTime = YES;
    _autoLoadMore = YES;
    _hideWhenNoData = YES;
    _textColor = [UIColor grayColor];
    
    _loadStatusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), 18)];
    _loadStatusLabel.center = CGPointMake(_loadStatusLabel.center.x, kLoadMoreFooterHeight/2.0);
    _loadStatusLabel.backgroundColor = [UIColor clearColor];
    _loadStatusLabel.textColor = _textColor;
    _loadStatusLabel.text = @"没有数据了";
    _loadStatusLabel.font = [UIFont boldSystemFontOfSize:14];
    _loadStatusLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_loadStatusLabel];
    
    _lastTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_loadStatusLabel.frame.origin.x, 0, CGRectGetWidth(_loadStatusLabel.bounds), 20)];
    _lastTimeLabel.center = CGPointMake(_loadStatusLabel.center.x, kLoadMoreFooterHeight/2.0+CGRectGetMidY(_lastTimeLabel.bounds) +5);
    _lastTimeLabel.textColor = _loadStatusLabel.textColor;
    _lastTimeLabel.backgroundColor = [UIColor clearColor];
    _lastTimeLabel.font = [UIFont systemFontOfSize:11];
    _lastTimeLabel.textAlignment = _loadStatusLabel.textAlignment;
    [self addSubview:_lastTimeLabel];
    _lastTimeLabel.hidden = _hideLastTime;
    [self loadMoreLastDate];

    _activityView = [[UIActivityIndicatorView alloc] init];
    _activityView.center = CGPointMake(40+CGRectGetMidX(_activityView.bounds), kLoadMoreFooterHeight/2.0);
    _activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self addSubview:_activityView];
    
    self.loadStatus = PBLoadMoreStatusNoMore;
}

- (void)loadMoreLastDate {
    NSDate *date = [NSDate date];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];

    [formatter setDateFormat:@"MM-dd HH:mm"];
    if(_lastTimeLabel){
        _lastTimeLabel.text = [NSString stringWithFormat:@"最近加载: %@", [formatter stringFromDate:date]];
        [[NSUserDefaults standardUserDefaults] setObject:_lastTimeLabel.text forKey:kUDLoadMoreLastDate];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}


- (void)setIgnoreBottom:(CGFloat)ignoreBottom {
    if (ignoreBottom != _ignoreBottom) {
        _ignoreBottom = ignoreBottom;
        
    }
    if (_ignoreBottom < 0) {
        _ignoreBottom = 0;
    }
}

- (void)setHideLastTime:(BOOL)hideLastTime {
    _hideLastTime = hideLastTime;
    if (_hideLastTime) {
        _lastTimeLabel.hidden = YES;
        _loadStatusLabel.center = CGPointMake(_loadStatusLabel.center.x, kLoadMoreFooterHeight/2.0);
    }
    else {
        _lastTimeLabel.hidden = NO;
        _loadStatusLabel.center = CGPointMake(_loadStatusLabel.center.x, kLoadMoreFooterHeight/2.0-CGRectGetMidY(_loadStatusLabel.bounds)+5);
    }
}

- (void)setTextColor:(UIColor *)textColor {
    if (textColor && !CGColorEqualToColor(textColor.CGColor, _textColor.CGColor)) {
        _textColor = textColor;
        _loadStatusLabel.textColor = textColor;
        _lastTimeLabel.textColor = textColor;
    }
}

- (void)setLoadStatus:(PBLoadMoreStatus)loadStatus {
    if (_loadStatus == loadStatus) return;
    
    _loadStatus = loadStatus;
    switch (loadStatus) {
        case PBLoadMoreStatusNormal:
            [_activityView stopAnimating];
            _loadStatusLabel.text = @"上拉加载更多";
            break;
        case PBLoadMoreStatusPull:
            [_activityView stopAnimating];
            _loadStatusLabel.text = @"松开加载更多";
            break;
        case PBLoadMoreStatusLoading:
            [_activityView startAnimating];
            _loadStatusLabel.text = @"正在加载";
            break;
        case PBLoadMoreStatusNoMore:
            [_activityView stopAnimating];
            _loadStatusLabel.text = @"没有数据了";

            break;
        default:
            break;
    }
    CGRect frame = self.frame;
    if (_hideWhenNoData && _loadStatus == PBLoadMoreStatusNoMore) {
        self.hidden = YES;
        frame.size.height = 0;
    }
    else {
        self.hidden = NO;
        frame.size.height = kLoadMoreFooterHeight;
    }
    self.frame = frame;

    _loadStatusLabel.width = [_loadStatusLabel widthForText]+4;
    _loadStatusLabel.centerX = CGRectGetMidX(self.bounds);
    CGFloat space = CGRectGetWidth(self.bounds)-_loadStatusLabel.x;
    _activityView.center = CGPointMake(space/2.0, kLoadMoreFooterHeight/2.0);
}

- (void)beginLoadData {
    if (self.loadStatus == PBLoadMoreStatusLoading) return;
    self.loadStatus = PBLoadMoreStatusLoading;
    
    [UIView animateWithDuration:0.25 animations:^{
        [_scrollView setContentInset:UIEdgeInsetsMake(_lastInsets.top, 0, (_lastInsets.bottom >0?_lastInsets.bottom :0)+kLoadMoreFooterHeight, 0)];
//        if (_scrollView.contentSize.height >= CGRectGetHeight(_scrollView.bounds)) {

            [_scrollView setContentOffset:CGPointMake(0, _scrollView.contentSize.height-CGRectGetHeight(_scrollView.bounds)+kLoadMoreFooterHeight+_lastInsets.bottom)];
//        }
    }];
   
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_loadingBlock) {
            _loadingBlock();
        }
        
        if (self.target && [self.target respondsToSelector:self.action]) {
            objc_msgSend(_target, _action);
        }
    });
    
}

- (void)endLoadMoreData {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.loadStatus == PBLoadMoreStatusLoading) {
            [_scrollView setContentInset:UIEdgeInsetsMake(_lastInsets.top, _lastInsets.left, _lastInsets.bottom-kLoadMoreFooterHeight, _lastInsets.right)];
        }
        self.loadStatus = PBLoadMoreStatusNormal;
        [self loadMoreLastDate];
    });
}

- (void)noMoreData {
    dispatch_async(dispatch_get_main_queue(), ^{
    
        if (self.loadStatus == PBLoadMoreStatusLoading) {
            [_scrollView setContentInset:UIEdgeInsetsMake(_lastInsets.top, _lastInsets.left, _lastInsets.bottom-kLoadMoreFooterHeight, _lastInsets.right)];
        }
        self.loadStatus = PBLoadMoreStatusNoMore;
        [self loadMoreLastDate];
    });
}

- (void)scrollViewContentOffsetDidChange:(NSDictionary*)change {
    //在loading,或没有数据直接返回
    if (self.loadStatus == PBLoadMoreStatusLoading || self.loadStatus == PBLoadMoreStatusNoMore) return;
    
    CGFloat offsetY = _scrollView.contentOffset.y;
    CGFloat pullOffsetY = [self getScrollViewPullOffsetY];
    if (offsetY >= pullOffsetY) {
        self.loadStatus = PBLoadMoreStatusPull;
    }
    else {
        self.loadStatus = PBLoadMoreStatusNormal;
    }
}

- (void)scrollViewContentSizeDidChange:(NSDictionary*)change {
    if ([_scrollView isKindOfClass:[UITableView class]] || [_scrollView isKindOfClass:[UICollectionView class]]) {
        _lastInsets = _scrollView.contentInset;
        
        CGRect frame = self.frame;
        // 内容的高度
        CGFloat contentHeight = _scrollView.contentSize.height + _ignoreBottom;
        // 表格的高度
        CGFloat scrollHeight = CGRectGetHeight(_scrollView.bounds) - _lastInsets.top - (_lastInsets.bottom>0?_lastInsets.bottom:0) + _ignoreBottom;
        // 设置位置和尺寸
        frame.origin.y = MAX(contentHeight, scrollHeight) ;

        if (_scrollView.contentSize.height == 0) {
            frame.size.height = 0;
        }
        else {
            frame.size.height = kLoadMoreFooterHeight;
        }
        self.frame = frame;
    }
}

- (void)scrollViewPanStateDidChange:(NSDictionary*)change {
    
    //不是准备松开状态,返回
    if (_loadStatus != PBLoadMoreStatusPull && _loadStatus != PBLoadMoreStatusNoMore) return;
    
    if (_scrollView.panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
    
        [self beginLoadData];
    }
}


- (CGFloat)getScrollViewPullOffsetY {
    CGFloat h = self.scrollView.frame.size.height - _lastInsets.bottom - _lastInsets.top;
    CGFloat deltaH  = self.scrollView.contentSize.height - h;
    if (deltaH > 0) {
        deltaH = deltaH - _lastInsets.top;
    }
    else {
        deltaH = -_lastInsets.top;
    }
    CGFloat pullOffsetY = deltaH + kLoadMoreFooterHeight;
    return pullOffsetY;
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{

    if ([keyPath isEqualToString:KeyPathScrollViewContentSize]) {
        [self scrollViewContentSizeDidChange:change];
    }
    if (self.hidden == YES) {
        return;
    }
    
    if ([keyPath isEqualToString:KeyPathScrollViewContentOffset]) {
        [self scrollViewContentOffsetDidChange:change];
    }
    else if ([keyPath isEqualToString:KeyPathPanState]) {
        [self scrollViewPanStateDidChange:change];
    }
}


- (void)addObservers {
    if (_scrollView) {
        NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
        [_scrollView addObserver:self forKeyPath:KeyPathScrollViewContentOffset options:options context:nil];
        [_scrollView addObserver:self forKeyPath:KeyPathScrollViewContentSize options:options context:nil];
        _panGesture = _scrollView.panGestureRecognizer;
        [_panGesture addObserver:self forKeyPath:KeyPathPanState options:options context:nil];
    }
}

- (void)removeObservers {
    [self.superview removeObserver:self forKeyPath:KeyPathScrollViewContentOffset];
    [self.superview removeObserver:self forKeyPath:KeyPathScrollViewContentSize];
    [_panGesture removeObserver:self forKeyPath:KeyPathPanState];
    _panGesture = nil;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
