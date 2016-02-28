//
//  PBLoadMoreFooterView.h
//  TestLoadMoreFooter
//
//  Created by BearLi on 15/11/18.
//  Copyright © 2015年 llx. All rights reserved.
//

#import <UIKit/UIKit.h>

//加载更多显示高度
//UIKIT_EXTERN CGFloat const kLoadMoreFooterHeight;

typedef void (^PBLoadMoreViewLoadingBlock)();

typedef enum : NSUInteger {
    /**
     *  一般状态
     */
    PBLoadMoreStatusNormal = 0,
    
    /**
     *  松手刷新
     */
    PBLoadMoreStatusPull,
    
    /**
     *  刷新中
     */
    PBLoadMoreStatusLoading,
    
    /**
     *  没有数据了,默认
     */
    PBLoadMoreStatusNoMore,
    
} PBLoadMoreStatus;

@interface PBLoadMoreFooterView : UIView

@property (nonatomic, assign) PBLoadMoreStatus loadStatus;

@property (nonatomic, weak, readonly) UIScrollView * scrollView;


/**
 *  加载事件回调
 */
@property (nonatomic, strong) PBLoadMoreViewLoadingBlock loadingBlock;

//block回调注意
//如果调用了[target action],要弱引用对象，否则销毁不了视图  (__weak Target weakTarget = target)

+ (instancetype)loadMoreViewWithBlock:(PBLoadMoreViewLoadingBlock)block;

/**
 *  初始化方法
 *
 *  @param target 事件响应者
 *  @param select 回调方法
 *
 *  @return 加载更多view
 */
+ (instancetype)loadMoreViewWithTarget:(id)target action:(SEL)select;

/** 加载结束后调用*/
- (void)endLoadMoreData;

- (void)noMoreData;
///**
// *  scrollView滑动事件
// *
// *  @param change 状态改变的新旧值
// */
//- (void)scrollViewContentOffsetDidChange:(NSDictionary*)change;
//
///**
// *  scrollView显示内容size变化
// *
// *  @param change 状态改变的新旧值
// */
//- (void)scrollViewContentSizeDidChange:(NSDictionary *)change;
//
//
//- (void)scrollViewPanStateDidChange:(NSDictionary*)change;

@end


