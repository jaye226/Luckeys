//
//  CustomTabBarController.h
//  UIVoice

#import <UIKit/UIKit.h>
#import "SliderViewController.h"

extern const  NSString *const PATabBarItemClickNotification;

#define kTabItemNorImage    @"tabItemImgName"
#define kTabItemSelImage    @"tabItemSelImgName"
#define kTabItemTitle       @"tabItemTitle"

@protocol TabBarBtnItemDelegate<NSObject>

@required
-(void)clickTabBarItem:(NSInteger)index;
@end

@interface UIPATabBarController : UITabBarController
{
    
}

@property(nonatomic,readonly) CGFloat                tabBarHeight;

@property (nonatomic,strong) SliderViewController * sliderVC;
- (id)initTabPages:(NSArray*)pages items:(NSArray*)items;

//初始化tabBar Item Button
//itemButtons: Item Button 数组包含 每一个item button 字典信息
- (void)initTabBarButtonItems:(NSArray*)itemButtons;

//设置TabBar背影图片
- (void)setTabBarBackground:(NSString*)bgImgName;

//返回对应item的 未选中图片
- (UIImage*)normalImageWithIndex:(NSInteger)index;

//返回对应item的 选中图片
- (UIImage*)selectedImageWithIndex:(NSInteger)index;

@end


@interface UITabBarItemView : UIButton
{
    UIImageView *_backgroundView;
    
    UIImageView *_imageView;
    UILabel *_titleLabel;
}

@property(nonatomic,weak) id<TabBarBtnItemDelegate> tabBarDelegate;

@property (nonatomic,assign)BOOL itemSelected;

- (UITabBarItemView*)initWithFrame:(CGRect)frame normalImageName:(NSString*)normalImgName selectedImageName:(NSString*)selectedImgName title:(NSString*)title;

-(void)changeItemImgText:(NSString*)norImgName selImage:(NSString*)selImg text:(NSString*)title;

@end