//
//  ShowTipsView.h
//
//  Created by apple on 14-3-15.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
@interface ShowTipsView : UIView
<MBProgressHUDDelegate>
+ (void)showLoadHUDWithMSG:(NSString*)msg andView:(UIView*)view;

+ (void)showHUDWithMessage:(NSString*)msg andView:(UIView*)view;

+ (void)hideHUDWithView:(UIView *)view;

@end
