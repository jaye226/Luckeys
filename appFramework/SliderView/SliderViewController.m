//
//  SliderViewController.m
//


#import "SliderViewController.h"
#import "LKLoginViewPage.h"

static SliderViewController * sldier = nil;

CGFloat const transFormScale = 1;

@interface SliderViewController () <UIAlertViewDelegate>

{
    CGRect _leftStartFrame;
    CGRect _rightStartFrame;
    
    UIView * _leftShadeView;
    UIView * _rightShadeView;
    
    UITabBarItem * _currentItem;
}

@property (nonatomic) BOOL isShowLeft;
@property (nonatomic) BOOL isShowRight;

@property (nonatomic) CGPoint stratPoint;

@end

@implementation SliderViewController

+ (SliderViewController*)shareSliderVC
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!sldier) {
            sldier = [[SliderViewController alloc] init];
        }
    });
    return sldier;
}

+(id)allocWithZone:(struct _NSZone *)zone
{
    if(sldier == nil){
        return [super allocWithZone:zone];
    }
    return sldier;
}

+ (id)copyWithZone:(struct _NSZone *)zone
{
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.hidden = YES;
    if (kSystemVesion >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }

    _isShowLeft = NO;
    _isShowRight = NO;
    [self setupView];
    [self setupChildViewController];
    
//    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizer:)];
//    pan.direction = UISwipeGestureRecognizerDirectionLeft;
//    [self.view addGestureRecognizer:pan];
    
}


- (void)setupView
{
    if (!_leftView) {
        _leftStartFrame = CGRectMake(0, kSystemVesion >= 7.0 ? 0 : -20, CGRectGetWidth(self.view.bounds) - kLeftXOffSet, CGRectGetHeight(self.view.bounds));
        _leftView = [[UIView alloc] initWithFrame:_leftStartFrame];
        [self.view addSubview:_leftView];
    }

    if (!_rightView) {
        _rightStartFrame = CGRectMake(CGRectGetWidth(self.view.bounds), kSystemVesion >= 7.0 ? 0 : -20,CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds));
        _rightView = [[UIView alloc] initWithFrame:_rightStartFrame];
        [self.view addSubview:_rightView];
    }
    
    if (!_mainView) {
        _mainView = [[UIView alloc] initWithFrame:CGRectMake(0, kSystemVesion >= 7.0 ? 0 : -20, CGRectGetWidth(self.view.bounds),CGRectGetHeight(self.view.bounds))];
       
        [self.view addSubview:_mainView];
    }
}

- (void)setupChildViewController
{
    
    if (_leftController) {
        [self addChildViewController:_leftController];
        [_leftView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [_leftView addSubview:_leftController.view];
        _leftView.alpha = 0.;
        [_leftController didMoveToParentViewController:self];
    }
    
    if (_rightController) {
        [self addChildViewController:_rightController];
        [_rightView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [_rightView addSubview:_rightController.view];
        _rightView.alpha = 0.;
        [_rightController didMoveToParentViewController:self];
    }
    
    if (_mainController) {
        [self addChildViewController:_mainController];
        [_mainView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [_mainView addSubview:_mainController.view];
        [_mainController didMoveToParentViewController:self];
    }
}


- (void)setLeftController:(UIViewController *)leftController
{
    if (!leftController) {
        return;
    }
    if (_leftController != leftController) {
        [_leftController willMoveToParentViewController:nil];
        [_leftController removeFromParentViewController];
        _leftController = leftController;
        [self makeLeftView];
        
    }
}

- (void)makeLeftView {
    if (_leftController) {
        [self addChildViewController:_leftController];
        [_leftView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [_leftView addSubview:_leftController.view];
        _leftView.alpha = 0.;
        [_leftController didMoveToParentViewController:self];
    }
}

- (void)setRightController:(UIViewController *)rightController
{
    if (!rightController) {
        return;
    }
    
    if (_rightController != rightController) {
        [_rightController willMoveToParentViewController:nil];
        [_rightController removeFromParentViewController];
        _rightController = rightController;
        [self makeRightView];
    
    }
}

- (void)makeRightView
{
    if (_rightController) {
        [self addChildViewController:_rightController];
        [_rightView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [_rightView addSubview:_rightController.view];
        _rightView.alpha = 0.;
        [_rightController didMoveToParentViewController:self];
    }
}

- (void)setMainController:(UIViewController *)mainController
{
    if (!mainController) {
        return;
    }
    
    if (_mainController != mainController) {
        [_mainController willMoveToParentViewController:nil];
        [_mainController removeFromParentViewController];
        _mainController = mainController;
        [self makeMainView];
    }
}

- (void)makeMainView {
    if (_mainController) {
        [self addChildViewController:_mainController];
        [_mainView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [_mainView addSubview:_mainController.view];
        [_mainController didMoveToParentViewController:self];
    }
}

- (void)panGestureRecognizer:(UIPanGestureRecognizer *)pan
{
    
    //当前移动的点
    CGPoint locationPoint = [pan locationInView:pan.view];

    if (pan.state == UIGestureRecognizerStateBegan) {
        //起始点
        _stratPoint = [pan locationInView:pan.view];
    }
   

    if (pan.state == UIGestureRecognizerStateChanged) {
        
        if (locationPoint.x < _stratPoint.x)
        {
            if (_rightView.frame.origin.x > CGRectGetWidth(self.view.bounds)/2.0 ) {
                CGRect rect = _rightView.frame;
//                _rightView.alpha = 1;
                
                rect.origin.x -= 5;
                _rightView.frame = rect;
            }
            else{
                _isShowRight = NO;
                [self showRightController];
            }

        }
        else
        {
            if (locationPoint.x > _stratPoint.x) {
                CGRect rect = _rightView.frame;
                
                rect.origin.x += 5;
                _rightView.frame = rect;
            }
            else{

            }
        }
    }
    
    if (pan.state == UIGestureRecognizerStateEnded) {
        
        if (locationPoint.x < _stratPoint.x) {
            _isShowRight = NO;
            [self showRightController];
        }
        else
        {
            _isShowRight = YES;
            [self hiddenController];
        }
    }
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self hiddenController];
}

#pragma mark show

- (void)showLeftController
{
    if (_isShowLeft == NO) {
        [self addLeftShadeView];
        [UIView animateWithDuration:DurationTime delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _mainView.layer.shadowOpacity = 0.4;
            _mainView.transform = CGAffineTransformMakeScale(transFormScale, transFormScale);
            
            _leftView.alpha = 1;
            _leftView.frame = CGRectMake(0, _leftView.frame.origin.y, CGRectGetWidth(self.view.frame)-kLeftXOffSet, CGRectGetHeight(_leftView.frame));
            _mainView.x = _leftView.maxX;
        } completion:^(BOOL finished) {
            _isShowLeft = YES;
        }];
        
        CABasicAnimation * an = [CABasicAnimation animationWithKeyPath:@"opacity"];
        an.fromValue = @0;
        an.toValue = @1;
        an.duration = DurationTime;
        an.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        [_leftShadeView.layer addAnimation:an forKey:@"leftShadeAnimation"];
    }
}

//左侧透明遮罩view
- (void)addLeftShadeView
{
    if (!_leftShadeView) {
        _leftShadeView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.bounds)-kLeftXOffSet, 0, kLeftXOffSet, CGRectGetHeight(self.view.bounds))];
        _leftShadeView.backgroundColor = [UIColor clearColor];
    }
    [self.view addSubview:_leftShadeView];
}


- (void)showRightController
{
    if (_isShowRight == NO) {
        [self addRightShadeView];
        [UIView animateWithDuration:DurationTime delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _mainView.layer.shadowOpacity = 0.4;
            _mainView.transform = CGAffineTransformMakeScale(transFormScale, transFormScale);
            
            _rightView.alpha = 1;
            _rightView.frame = CGRectMake(kRightXOffSet, _rightView.frame.origin.y, CGRectGetWidth(_rightView.frame), CGRectGetHeight(_rightView.frame));
            _mainView.x = - (CGRectGetWidth(self.view.bounds) - kRightXOffSet);
//            [self.view bringSubviewToFront:_rightView];
            
        } completion:^(BOOL finished) {
            _isShowRight = YES;
        }];
        
        CABasicAnimation * an = [CABasicAnimation animationWithKeyPath:@"opacity"];
        an.fromValue = @0;
        an.toValue = @1;
        an.duration = DurationTime;
        an.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        [_rightShadeView.layer addAnimation:an forKey:@"rightShadeAnimation"];
    }
}

//右侧透明遮罩view
- (void)addRightShadeView
{
    if (!_rightShadeView) {
        _rightShadeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kRightXOffSet, CGRectGetHeight(self.view.bounds))];
        _rightShadeView.backgroundColor = [UIColor clearColor];
    }
    [self.view addSubview:_rightShadeView];
}

#pragma mark hidden

- (void)hiddenController
{
    if (_isShowLeft) {
        [UIView animateWithDuration:DurationTime delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _mainView.transform = CGAffineTransformIdentity;
            _mainView.x = 0;
            
            _leftView.frame = _leftStartFrame;
            _leftView.alpha = 0.;
            [_leftShadeView removeFromSuperview];
        } completion:^(BOOL finished) {
            _isShowLeft = NO;
            _mainView.layer.shadowOpacity = 0;
        }];
    }
    
    
    if (_isShowRight) {
        [self resetTabbar];
        [UIView animateWithDuration:DurationTime delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _mainView.transform = CGAffineTransformIdentity;
            _mainView.x = 0;
            
            _rightView.frame = _rightStartFrame;
            _rightView.alpha = 0.;
            [_rightShadeView removeFromSuperview];
        } completion:^(BOOL finished) {
            _isShowRight = NO;
            _mainView.layer.shadowOpacity = 0;
        }];
    }
}


- (void)clearViewsWithTab:(BOOL)clearTab; {
    [_leftController removeFromParentViewController];
    [_rightController removeFromParentViewController];
    [_mainController removeFromParentViewController];
    if (clearTab) {
        _sldierTabbar = nil;
    }
}


- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    if (![LKShareUserInfo share].isLogin)
    {
        NSLog(@"%d",tabBarController.selectedIndex);
        if (tabBarController.selectedIndex != 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您还没有登录，请先登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert show];
        }
        
        //by change jaye
//        return NO;
    }
    _currentItem = tabBarController.tabBar.items[tabBarController.selectedIndex];
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController * nav = (UINavigationController*)viewController;
        if ([nav.viewControllers[0] isKindOfClass:[self.rightController class]]) {
            [self showRightController];
            [self setHighlightTabBar:tabBarController index:[tabBarController.viewControllers indexOfObject:viewController]];
            return NO;
        }
        else
        {
            return YES;
        }
    }
    else
    {
        if ([viewController isKindOfClass:[self.rightController class]]) {
            [self showRightController];
            [self setHighlightTabBar:tabBarController index:[tabBarController.viewControllers indexOfObject:viewController]];
            return NO;
        }
        else
        {
            return YES;
        }
    }
}

- (UIViewController*)getSldierTopViewController {
    if (_sldierTabbar) {
        UINavigationController * nav = (UINavigationController*)(kShareSlider.sldierTabbar.selectedViewController);
        return nav.topViewController;
    }
    else {
        return _sldierNav.topViewController;
    }
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    
}

- (void)setHighlightTabBar:(UITabBarController*)tabBarController index:(NSInteger)highlightIndex
{
    UIPATabBarController * controller = (UIPATabBarController*)tabBarController;
    UITabBar *tabBar = controller.tabBar;
    if (_currentItem) {
        NSInteger currentIndex = [tabBar.items indexOfObject:_currentItem];
        [_currentItem setFinishedSelectedImage:[controller normalImageWithIndex:currentIndex] withFinishedUnselectedImage:[controller selectedImageWithIndex:currentIndex]];
        [_currentItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                      [UIColor blackColor], NSForegroundColorAttributeName,
                                      [UIFont systemFontOfSize:10.0], NSFontAttributeName,
                                      nil] forState:UIControlStateSelected];

    }
    
    if (highlightIndex < tabBar.items.count && highlightIndex >= 0) {
        UITabBarItem * item = tabBar.items[highlightIndex];
        [item setFinishedSelectedImage:[controller normalImageWithIndex:highlightIndex] withFinishedUnselectedImage:[controller selectedImageWithIndex:highlightIndex]];
        [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                      [UIColor redColor], NSForegroundColorAttributeName,
                                      [UIFont systemFontOfSize:10.0], NSFontAttributeName,
                                      nil] forState:UIControlStateNormal];
    }
}

- (void)resetTabbar {
    if (!_sldierTabbar) {
        return;
    }
    UIPATabBarController * controller = (UIPATabBarController*)_sldierTabbar;
    
    UITabBar *tabBar = controller.tabBar;
    NSInteger count = [tabBar.items count];
    
    for (int i = 0; i < count;  i ++) {
        UITabBarItem *item = [tabBar.items objectAtIndex:i];
        [item setFinishedSelectedImage:[controller selectedImageWithIndex:i] withFinishedUnselectedImage:[controller normalImageWithIndex:i]];
        [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                          [UIColor redColor], NSForegroundColorAttributeName,
                                          [UIFont systemFontOfSize:10.0], NSFontAttributeName,
                                          nil] forState:UIControlStateSelected];
        
        [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                          [UIColor blackColor], NSForegroundColorAttributeName,
                                          [UIFont systemFontOfSize:10.0], NSFontAttributeName,
                                          nil] forState:UIControlStateNormal];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        LKLoginViewPage *loginVC = [[LKLoginViewPage alloc] init];
        loginVC.isGVC = YES;
        [self.navigationController pushViewController:loginVC animated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
