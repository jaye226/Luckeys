//
//  AppDelegate.m
//  Luckeys
//
//  Created by lishaowei on 15/9/14.
//  Copyright (c) 2015年 Luckeys. All rights reserved.
//

#import "AppDelegate.h"
#import "LKLoginHomeViewPage.h"
#import "LKNavigationController.h"
#import "LKPayManger.h"
#import "UMSocialSinaSSOHandler.h"
#import "UMSocialSinaHandler.h"
#import "UMSocialQQHandler.h"
#import <AlipaySDK/AlipaySDK.h>

#define UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define _IPHONE80_ 80000

#define kAlertActice 10000

@interface AppDelegate ()<UIAlertViewDelegate>

@property (nonatomic,assign) BOOL isUploadToken;
@property (nonatomic,strong) NSDictionary * pushUserInfo;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    [UMessage startWithAppkey:@"55eafa6767e58eef8300f77a" launchOptions:launchOptions];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (![[userDefaults objectForKey:@"kRemoteNotification"] boolValue]) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
        if(UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
        {
            //register remoteNotification types
            UIMutableUserNotificationAction *action1 = [[UIMutableUserNotificationAction alloc] init];
            action1.identifier = @"action1_identifier";
            action1.title=@"Accept";
            action1.activationMode = UIUserNotificationActivationModeForeground;//当点击的时候启动程序
            
            UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];  //第二按钮
            action2.identifier = @"action2_identifier";
            action2.title=@"Reject";
            action2.activationMode = UIUserNotificationActivationModeBackground;//当点击的时候不启动程序，在后台处理
            action2.authenticationRequired = YES;//需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
            action2.destructive = YES;
            
            UIMutableUserNotificationCategory *categorys = [[UIMutableUserNotificationCategory alloc] init];
            categorys.identifier = @"category1";//这组动作的唯一标示
            [categorys setActions:@[action1,action2] forContext:(UIUserNotificationActionContextDefault)];
            
            UIUserNotificationSettings *userSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert
                                                                                         categories:[NSSet setWithObject:categorys]];
            [UMessage registerRemoteNotificationAndUserNotificationSettings:userSettings];
            
        } else{
            //register remoteNotification types
            [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge
             |UIRemoteNotificationTypeSound
             |UIRemoteNotificationTypeAlert];
        }
#else
        
        //register remoteNotification types
        [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert];
        
#endif
    }

    //for log
    [UMessage setLogEnabled:YES];
    
    [UMSocialData setAppKey:@"55eafa6767e58eef8300f77a"];
    [UMSocialWechatHandler setWXAppId:@"wxa23f475c7751896e" appSecret:@"d4624c36b6795d1d99dcf0547af5443d" url:@"http://www.luckeys.cn"];
    
    //[UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:@"3649449269" RedirectURL:@"http://www.luckeys.cn"];
    [UMSocialSinaHandler openSSOWithRedirectURL:@"http://www.luckeys.cn"];
    [UMSocialQQHandler setQQWithAppId:@"1104839227" appKey:@"aCEf7LorNEu0U14X" url:[@"http://www.luckeys.cn" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    //微信支付向微信注册APP
    [WXApi registerApp:@"wxa23f475c7751896e" withDescription:@"Luckeys"];
    
    LKLoginHomeViewPage *loginHome = [[LKLoginHomeViewPage alloc] init];
    LKNavigationController *nav = [[LKNavigationController alloc] initWithRootViewController:loginHome];
    kShareSlider.sldierNav = nav;
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    
    [self addNotification];
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return  [WXApi handleOpenURL:url delegate:[LKPayManger sharedManager]];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {

    BOOL result = [WXApi handleOpenURL:url delegate:[LKPayManger sharedManager]];
    if (!result)
    {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic){
            NSLog(@"result = %@",resultDic);
        }];
    }
    return result;
}

- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess) name:kNotiLKLoginSuccessNotification object:nil];
}

- (void)loginSuccess {
    [self uploadToken];
}

- (void)uploadToken {
    NSString * token = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDeviceToken];
    if (token.length > 0&& [LKShareUserInfo share].userInfo.userUuid.length > 0) {
        if (_isUploadToken == NO ) {
            [[MLHttpRequestManager sharedMLHttpRequestManager] sendHttpRequestWithTag:111 URLString:kURL_AddDeviceToken requestType:Request_Normal bodyString:@{@"iosDeviceToken":token,@"userUuid":[LKShareUserInfo share].userInfo.userUuid} jsCallBack:nil Finished:^(Result_TYPE success, int requestTag, id callbackData) {
                if (success == Result_Success) {
                    _isUploadToken = YES;
                }
                else {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self uploadToken];
                    });
                }
            }];
        }
    }else
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self uploadToken];
        });
    }
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"注册推送失败:%@",error);
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    if (deviceToken.length == 0) {
        return;
    }
    NSString * token = [[[[deviceToken description]
                        stringByReplacingOccurrencesOfString:@"<" withString:@""]
                        stringByReplacingOccurrencesOfString:@">" withString:@""]
                        stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"token:%@",token);
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:kUserDeviceToken];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self uploadToken];
    [UMessage registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"%@",userInfo);
    [UMessage setAutoAlert:NO];
    [UMessage didReceiveRemoteNotification:userInfo];
    _pushUserInfo = userInfo;
    NSString * message = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
    if (application.applicationState == UIApplicationStateActive) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"查看", nil];
        alert.tag = kAlertActice;
        [alert show];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == kAlertActice) {
        if (buttonIndex == 1) {
            NSString * uuid = _pushUserInfo[@"activityUuid"];
            LKBaseViewPage * vc = (LKBaseViewPage*)[kShareSlider getSldierTopViewController];
            [vc pushPageWithName:@"LKDetailsViewPage" withParams:@{@"activityUuid":STR_IS_NULL(uuid),@"title":STR_IS_NULL(_pushUserInfo[@"activityName"])}];
        }
    }
}

@end
