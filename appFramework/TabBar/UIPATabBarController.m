//
//  CustomTabBarController.m
//  UIVoice

#import "UIPATabBarController.h"

#define kTabBarItemHeight  49
#define kTabBarItemWidth   60
#define kTabBarItemSize  CGSizeMake(kTabBarItemWidth,kTabBarItemHeight)

NSString *const PATabBarItemClickNotification = @"PATabBarItemClickNotification";

@interface UIPATabBarController ()<TabBarBtnItemDelegate>
{
    BOOL firstOpen;
    
    NSMutableArray * _normalImages;
    NSMutableArray * _selectedImages;
}

@property(nonatomic, strong)NSMutableArray *tabBarItemArray;

@end

@implementation UIPATabBarController

- (void)dealloc
{
    
}

-(CGFloat)tabBarHeight
{
    return kTabBarItemHeight;
}

- (id)initTabPages:(NSArray*)pages items:(NSArray*)items
{
    self = [super init];
    
    if (self) {
        _normalImages = [NSMutableArray arrayWithCapacity:items.count];
        _selectedImages = [NSMutableArray arrayWithCapacity:items.count];
        NSMutableArray * tabItems = [[NSMutableArray alloc] initWithCapacity:items.count];
        for (int i = 0; i < items.count; i ++) {
            NSString * pageStr = @"";
            if (i < pages.count) {
                pageStr = pages[i];
            }
            Class page = NSClassFromString(pageStr);
            LKNavigationController * nav;
            if (page) {
                UIViewController * vc = [[page alloc] init];
                nav = [[LKNavigationController alloc] initWithRootViewController:(UIViewController*)vc];
                [nav.navigationBar setBackgroundImage:[UIColor createLongImageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
                
                NSDictionary *itemDic = items[i];
                NSString *itemTitle = itemDic[kTabItemTitle];
                nav.tabBarItem = [[UITabBarItem alloc] initWithTitle:itemTitle image:nil tag:i];
                [tabItems addObject:nav];
            }
            
            NSDictionary *itemDic = items[i];
            NSString *selImgName = itemDic[kTabItemSelImage];
            NSString *imgName = itemDic[kTabItemNorImage];
            UIImage * normal = [UIImage imageWithName:imgName];
            UIImage * selImage = [UIImage imageWithName:selImgName];
            if (normal) {
              [_normalImages addObject:normal];
            }
            if (selImage) {
                [_selectedImages addObject:selImage];
            }
            
        }
        if (tabItems.count > 0) {
            self.viewControllers = tabItems;
            [self setTabBarAppearanceWithImages:items];
        }
    }
    return self;
}

- (void)setTabBarAppearanceWithImages:(NSArray*)items
{
    UITabBar *tabBar = self.tabBar;
    tabBar.backgroundImage = SetPngImage(@"bg_toolbar",@"png");

    NSInteger count = [tabBar.items count];
    for (int i = 0; i < count; i++)
    {
        NSDictionary *itemDic = items[i];
        NSString *selImgName = itemDic[kTabItemSelImage];
        NSString *imgName = itemDic[kTabItemNorImage];
        
        UITabBarItem *item = [tabBar.items objectAtIndex:i];
        UIImage * sel = [UIImage imageWithName:selImgName];
        UIImage * nor = [UIImage imageWithName:imgName];
        [item setFinishedSelectedImage:sel withFinishedUnselectedImage:nor];
        // 选中时的字体属性
        [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                      [UIColor redColor], NSForegroundColorAttributeName,
                                      [UIFont systemFontOfSize:10.0], NSFontAttributeName,
                                      nil] forState:UIControlStateSelected];
        
        // 未选中时的字体属性
        [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                      [UIColor blackColor], NSForegroundColorAttributeName,
                                      [UIFont systemFontOfSize:10.0], NSFontAttributeName,
                                      nil] forState:UIControlStateNormal];
        
        item.titlePositionAdjustment = UIOffsetMake(0, -2);
    }
    
}

- (void)initTabBarButtonItems:(NSArray*)itemButtons
{
    if (itemButtons == nil || itemButtons.count <= 0) {
        return;
    }
    
    if (self.tabBarItemArray == nil) {
        _tabBarItemArray = [[NSMutableArray alloc] init];
    }
    
    NSArray *subViews = self.tabBar.subviews;
    for (UIView *sub in subViews) {
        if ([NSStringFromClass(sub.class) isEqualToString:@"UITabBarButton"]) {
            [sub removeFromSuperview];
        }
    }
    
    //左右固定边距
    CGFloat lrGrapWid = 30;
    CGFloat width = kTabBarItemWidth;
    CGFloat height = kTabBarItemHeight;
    
    if (itemButtons.count == 2) {//两个处理
        for (NSInteger i = 0; i < 2; i++) {
            NSDictionary *itemDic = itemButtons[i];
            
            NSString *imgName = itemDic[kTabItemNorImage];
            NSString *selImgName = itemDic[kTabItemSelImage];
            NSString *itemTitle = itemDic[kTabItemTitle];
            
            CGRect rect;
            if (i == 0) {
                rect = CGRectMake(lrGrapWid, 0, width, height);
            }
            else{
                rect = CGRectMake(self.view.frame.size.width - lrGrapWid - width, 0, width, height);
            }
            
            UITabBarItemView *tabBarBg = [[UITabBarItemView alloc] initWithFrame:rect normalImageName:imgName selectedImageName:selImgName title:itemTitle];
            tabBarBg.center = CGPointMake( i ? (CGRectGetMidX(self.view.bounds)/2.0 + CGRectGetMidX(self.view.bounds)) : (CGRectGetMidX(self.view.bounds)/2.0), tabBarBg.center.y);
            tabBarBg.tag = i;
            tabBarBg.tabBarDelegate = self;
            [self.tabBar addSubview:tabBarBg];
            [self.tabBarItemArray addObject:tabBarBg];
        }
    }
    else if (itemButtons.count == 3) {//三个处理
        for (NSInteger i = 0; i < 3; i++) {
            NSDictionary *itemDic = itemButtons[i];
            
            NSString *imgName = itemDic[kTabItemNorImage];
            NSString *selImgName = itemDic[kTabItemSelImage];
            NSString *itemTitle = itemDic[kTabItemTitle];
            
            CGRect rect;
            if (i == 0) {
                rect = CGRectMake(lrGrapWid, 0, width, height);
            }
            else if(i == 2){
                rect = CGRectMake(self.view.frame.size.width - lrGrapWid - width, 0, width, height);
            }
            else{
                CGFloat xx = (self.view.frame.size.width - width)/2;
                rect = CGRectMake(xx, 0, width, height);
            }
            
            UITabBarItemView *tabBarBg = [[UITabBarItemView alloc] initWithFrame:rect normalImageName:imgName selectedImageName:selImgName title:itemTitle];
            tabBarBg.tag = i;
            tabBarBg.tabBarDelegate = self;
            [self.tabBar addSubview:tabBarBg];
            [self.tabBarItemArray addObject:tabBarBg];
        }
    }
    else if (itemButtons.count > 3){//其它下均排
        lrGrapWid = 8;
        CGFloat cItemX = 0;
        for (NSInteger i = 0; i < itemButtons.count; i++) {
            NSDictionary *itemDic = itemButtons[i];
            
            NSString *imgName = itemDic[kTabItemNorImage];
            NSString *selImgName = itemDic[kTabItemSelImage];
            NSString *itemTitle = itemDic[kTabItemTitle];

            CGFloat xWid = self.view.frame.size.width - lrGrapWid*2;
            CGFloat itemWid = xWid/itemButtons.count;
            CGFloat tmpX = cItemX;
            if ((itemWid - width)/2 > 0) {
                tmpX += (itemWid - width)/2;
            }
            CGRect rect = CGRectMake(tmpX, 0, width, height);
            cItemX += itemWid;

            UITabBarItemView *tabBarBg = [[UITabBarItemView alloc] initWithFrame:rect normalImageName:imgName selectedImageName:selImgName title:itemTitle];
            tabBarBg.tag = i;
            tabBarBg.tabBarDelegate = self;
            [self.tabBar addSubview:tabBarBg];
            [self.tabBarItemArray addObject:tabBarBg];
        }
    }
    else{//一个情况
        NSDictionary *itemDic = itemButtons[0];
        
        NSString *imgName = itemDic[kTabItemNorImage];
        NSString *selImgName = itemDic[kTabItemSelImage];
        NSString *itemTitle = itemDic[kTabItemTitle];
        
        CGRect rect = CGRectMake((self.view.frame.size.width - width)/2, 0, width, height);
 
        UITabBarItemView *tabBarBg = [[UITabBarItemView alloc] initWithFrame:rect normalImageName:imgName selectedImageName:selImgName title:itemTitle];
        tabBarBg.tag = 0;
        tabBarBg.tabBarDelegate = self;
        [self.tabBar addSubview:tabBarBg];
        [self.tabBarItemArray addObject:tabBarBg];
    }
    
    
    //默认选中第一个
    [self selectTabBarItemAtIndex:0];
   
    self.tabBar.backgroundImage = [[UIImage imageNamed:@"tabbar"] stretchableImageWithLeftCapWidth:0 topCapHeight:2];
}


- (void)setTabBarBackground:(NSString*)bgImgName
{
    if (bgImgName==nil || [bgImgName isEqualToString:@""]) {
        return;
    }
    self.tabBar.backgroundImage = [[UIImage imageNamed:bgImgName] stretchableImageWithLeftCapWidth:0 topCapHeight:2];
}


-(void)clickTabBarItem:(NSInteger)index
{
    if (index >= 0 && index < self.viewControllers.count) {
        
        NSMutableDictionary *dicInfo = [[NSMutableDictionary alloc] init];
        
        UIViewController *selVC = ((UINavigationController*)self.selectedViewController).topViewController;
        NSString *className = NSStringFromClass([selVC class]);
        
        dicInfo[@"prevClassName"] = className;
        dicInfo[@"prevIndex"] = [NSNumber numberWithInteger:self.selectedIndex];
        
        self.selectedIndex = index;
        [self selectTabBarItemAtIndex:index];
        
        dicInfo[@"curIndex"] = [NSNumber numberWithInteger:index];
        UIViewController *curVC = ((UINavigationController*)self.selectedViewController).topViewController;
        NSString *curClassName = NSStringFromClass([curVC class]);
        dicInfo[@"curClassName"] = curClassName;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:PATabBarItemClickNotification object:dicInfo];
    }
}

//自定义了TabBarController 之后必须实现以下
//不调用父类是为了 解决Unbalanced calls to begin/end appearance transitions for 系统提示Bug
-(void)viewWillAppear:(BOOL)animated
{
    [self.selectedViewController beginAppearanceTransition: YES animated: animated];
}

-(void) viewDidAppear:(BOOL)animated
{
    [self.selectedViewController endAppearanceTransition];
}

-(void) viewWillDisappear:(BOOL)animated
{
    [self.selectedViewController beginAppearanceTransition: NO animated: animated];
}

-(void) viewDidDisappear:(BOOL)animated
{
    [self.selectedViewController endAppearanceTransition];
}

- (void)selectTabBarItemAtIndex:(NSInteger)index
{
    for(UITabBarItemView *tabBarBg in _tabBarItemArray)
    {
        NSInteger thisIndex = [_tabBarItemArray indexOfObject:tabBarBg];
        if(index == thisIndex)
        {
            tabBarBg.itemSelected = YES;
        }else {
            tabBarBg.itemSelected = NO;
        }
    }
}

- (UIImage*)normalImageWithIndex:(NSInteger)index {
    if (_normalImages.count == 0 || index >= _normalImages.count) {
        return nil;
    }
    return _normalImages[index];
}

- (UIImage*)selectedImageWithIndex:(NSInteger)index {
    if (_selectedImages.count == 0 || index >= _selectedImages.count) {
        return nil;
    }
    return _selectedImages[index];
}

-(BOOL)shouldAutorotate
{
    return NO;
}

@end

@implementation UITabBarItemView


- (UITabBarItemView*)initWithFrame:(CGRect)frame normalImageName:(NSString*)normalImgName selectedImageName:(NSString*)selectedImgName title:(NSString*)title
{
    CGRect bgRect = frame;
    if(self = [super initWithFrame:frame])
    {
        bgRect.origin = CGPointZero;

        UIImage  *_normalImage = [UIImage imageNamed:normalImgName];
        UIImage  * _selectedImage = [UIImage imageNamed:selectedImgName];
        CGSize size = _normalImage.size;
        
        CGFloat gap = 4.0;
        CGFloat yOffset = gap;
        CGRect imgViewRect = CGRectMake((frame.size.width-size.width)*0.5, yOffset, size.width, size.height);
        _imageView = [[UIImageView alloc] initWithFrame:imgViewRect];
        _imageView.image = _normalImage;
        _imageView.highlightedImage = _selectedImage;
        [self addSubview:_imageView];
        
        UIFont *font;
        CGSize titleSize;
        
        CGSize nSize = CGSizeMake(1111, 20000);
        
        CGFloat tmpYY;
        if (IS_IPHONE_6P){
            font = [UIFont boldSystemFontOfSize:11.0];
            titleSize = [title boundingRectWithSize:nSize
                                            options:NSStringDrawingTruncatesLastVisibleLine
                         | NSStringDrawingUsesLineFragmentOrigin
                         | NSStringDrawingUsesFontLeading
                                         attributes:@{NSFontAttributeName: font}
                                            context:nil].size;
            
            imgViewRect.origin.y -= 4;
            _imageView.frame = imgViewRect;
            tmpYY = imgViewRect.origin.y + imgViewRect.size.height;
        }
        else{
            font = [UIFont boldSystemFontOfSize:11.0];
            titleSize = [title sizeWithFont:font constrainedToSize:nSize
                              lineBreakMode:NSLineBreakByWordWrapping];
            tmpYY = frame.size.height - titleSize.height - 5.0;
        }
        
        CGRect rect = CGRectMake(gap, tmpYY, frame.size.width-gap*2, titleSize.height);
        _titleLabel = [[UILabel alloc] initWithFrame:rect];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor whiteColor];//[UtilsTool getColrWithR:0xA0 g:0xA0 b:0xA0];
        _titleLabel.text = title;
        _titleLabel.font = font;
        [self addSubview:_titleLabel];
        
        CGFloat contentEdge = 0.0;  //image与label的间距
        CGFloat edge = CGRectGetHeight(frame) - CGRectGetHeight(_imageView.bounds) - CGRectGetHeight(_titleLabel.bounds) - contentEdge;
        CGRect UIFrame = _imageView.frame;
        UIFrame.origin.y = edge/2.0;
        _imageView.frame = UIFrame;
        
        UIFrame = _titleLabel.frame;
        UIFrame.origin.y = CGRectGetHeight(frame) - edge/2.0 - UIFrame.size.height;
//        UIFrame.origin.y = CGRectGetMaxY(_imageView.frame);
        _titleLabel.frame = UIFrame;
        
        [self addTarget:self action:@selector(clickTabBarButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void)clickTabBarButton
{
    if(self.tabBarDelegate && [self.tabBarDelegate respondsToSelector:@selector(clickTabBarItem:)]){
        [self.tabBarDelegate clickTabBarItem:self.tag];
    }
    
}


-(void)changeItemImgText:(NSString*)norImgName selImage:(NSString*)selImg text:(NSString*)title
{
    UIImage  *_normalImage = [UIImage imageNamed:norImgName];
    UIImage  * _selectedImage = [UIImage imageNamed:selImg];
    
    _imageView.image = _normalImage;
    _imageView.highlightedImage = _selectedImage;
    
    _titleLabel.text = title;
}

- (void)setItemSelected:(BOOL)select
{   
    _itemSelected = select;
    
    if(select)
    {
        _backgroundView.highlighted = YES;
        _imageView.highlighted = YES;
        _titleLabel.textColor = [UIColor grayColor];
    }else {
        _backgroundView.highlighted = NO;
        _imageView.highlighted = NO;
        _titleLabel.textColor = [UIColor grayColor];
    }
}


@end
