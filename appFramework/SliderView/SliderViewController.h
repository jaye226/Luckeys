//
//  SliderViewController.h
//

#import <UIKit/UIKit.h>

#define kShareSlider    [SliderViewController shareSliderVC]

#define kLeftXOffSet  BoundsOfScale(100)
#define kRightXOffSet BoundsOfScale(100)

#define DurationTime 0.3

@interface SliderViewController : UIViewController <UITabBarControllerDelegate>


@property (nonatomic, strong) UIView * mainView;
@property (nonatomic, strong) UIView * leftView;
@property (nonatomic, strong) UIView * rightView;

@property (nonatomic, strong) UIViewController * mainController;
@property (nonatomic, strong) UIViewController * leftController;
@property (nonatomic, strong) UIViewController * rightController;

/** 如应用采用nav切换,赋值为该nav */
@property (nonatomic,strong) UINavigationController * sldierNav;

/**
 *  方便读取,默认为nil
    如应用采用tab切换,赋值为该tab
 */
@property (nonatomic,strong) UITabBarController * sldierTabbar;

+ (SliderViewController*)shareSliderVC;

- (void)showLeftController;

- (void)showRightController;

- (void)hiddenController;

/**
 *  清理views,用于注销操作
 *
 *  @param clearTab 是否清理主tab
 */
- (void)clearViewsWithTab:(BOOL)clearTab;

- (UIViewController*)getSldierTopViewController;

@end
