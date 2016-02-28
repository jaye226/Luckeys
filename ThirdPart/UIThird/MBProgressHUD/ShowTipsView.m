//
//  ShowTipsView.m
//
//  Created by apple on 14-3-15.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "ShowTipsView.h"
#import "PALoadHUD.h"

@implementation ShowTipsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


+ (void)showHUDWithMessage:(NSString*)msg andView:(UIView*)view
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = msg;
    hud.labelFont = [UIFont systemFontOfSize:15];
    hud.margin = 10.f;
    if (CGRectGetHeight([UIScreen mainScreen].bounds) > 480) {
        hud.yOffset = 150.f;
    }else{
        hud.yOffset = 100;
    }
    
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1.5];
    
}


+ (void)showLoadHUDWithMSG:(NSString*)msg andView:(UIView*)view
{
    PALoadHUD *hud = [PALoadHUD hudForView:view];
    if (!hud) {
        [PALoadHUD showLoadHUDWithMessage:@"" inView:view];
    }else{
        [hud.layer removeAllAnimations];
        [hud dismiss:NO];
        [PALoadHUD showLoadHUDWithMessage:@"" inView:view];
    }
    
//    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
//    hud.mode = MBProgressHUDModeIndeterminate;
//    if (msg.length > 0) {
//        hud.labelText = msg;
//        hud.labelFont = [UIFont systemFontOfSize:15];
//    }
//    hud.margin = 10;
//    hud.removeFromSuperViewOnHide = YES;
//    [hud show:YES];
}

+ (void)hideHUDWithView:(UIView *)view
{
//    MBProgressHUD * hud = [MBProgressHUD HUDForView:view];
//    hud.hidden = YES;
//    [hud removeFromSuperview];
    
    [self hideLoadHUDFromView:view];
}

+ (void)hideLoadHUDFromView:(UIView*)view
{
    PALoadHUD * hud = [PALoadHUD hudForView:view];
    if (hud) {
        [hud.layer removeAllAnimations];
        [hud dismiss:NO];
    }
}


- (void)hudWasHidden:(MBProgressHUD *)hud
{
    [hud removeFromSuperview];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
