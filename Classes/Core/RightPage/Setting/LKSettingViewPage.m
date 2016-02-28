//
//  LKSettingViewPage.m
//  Luckeys
//
//  Created by 李锦华 on 15/11/21.
//  Copyright © 2015年 Luckeys. All rights reserved.
//

#import "LKSettingViewPage.h"

#define UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define _IPHONE80_ 80000

@interface LKSettingViewPage ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *_titleArr;
    UITableView* _settingTableView;
}
@end

@implementation LKSettingViewPage

- (void)viewDidLoad {
    self.title=@"设置";
    [super viewDidLoad];
    [self initData];
    [self addTableView];
}

-(void)initData{
    _titleArr=[NSArray arrayWithObjects:@"推送通知",@"清除缓存",@"修改密码",nil];
}

-(void)addTableView{
    _settingTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 64+BoundsOfScale(18), UI_IOS_WINDOW_WIDTH, UI_IOS_WINDOW_HEIGHT-64) style:UITableViewStylePlain];
    [_settingTableView setBackgroundColor:[UIColor clearColor]];
    _settingTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _settingTableView.delegate=self;
    _settingTableView.dataSource=self;
    _settingTableView.layer.cornerRadius=10.0f;
    _settingTableView.clipsToBounds=YES;
    _settingTableView.scrollEnabled=NO;
    [self.view addSubview:_settingTableView];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentity=@"normalCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentity];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentity];
        cell.textLabel.textColor= UIColorRGB(0x999999);
        cell.textLabel.font = [UIFont systemFontOfSize:FontOfScale(15)];
        UIView *lineView=[[UIView alloc] initWithFrame:CGRectMake(BoundsOfScale(15), 43-SINGLE_LINE_ADJUST_OFFSET, UI_IOS_WINDOW_WIDTH-BoundsOfScale(30), SINGLE_LINE_BOUNDS)];
        lineView.backgroundColor = UIColorRGB(0xe9e9e9);
        [cell.contentView addSubview:lineView];

        if(indexPath.row==0){
            CGFloat with = 65;
            if (IS_IPHONE_6P) {
                with = 70;
            }
            UISwitch *notiSwitch=[[UISwitch alloc] initWithFrame:CGRectMake(UI_IOS_WINDOW_WIDTH-with, 7, 0, 0)];
            BOOL switchState=[[NSUserDefaults standardUserDefaults] boolForKey:@"kRemoteNotification"];
            notiSwitch.on=!switchState;
            [cell.contentView addSubview:notiSwitch];
            [notiSwitch addTarget:self action:@selector(changeSwitchState:) forControlEvents:UIControlEventValueChanged];
        }
    }
    if(indexPath.row==1){
        cell.detailTextLabel.text=[NSString stringWithFormat:@"%.1fM",[[SDImageCache sharedImageCache] checkTmpSize]];
        cell.detailTextLabel.textColor=[UIColor redColor];
    }
    cell.textLabel.text=_titleArr[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.row==1){
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"" message:@"确认清楚缓存?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        [alert show];
    }
}

-(void)changeSwitchState:(UISwitch*)sender{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if(sender.on)
    {
        [userDefaults setBool:NO forKey:@"kRemoteNotification"];
        [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert];
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
    else
    {
        
        [userDefaults setBool:YES forKey:@"kRemoteNotification"];
        [UMessage unregisterForRemoteNotifications];
    }
    [userDefaults synchronize];
}

-(void)clearMemory{
    [[SDImageCache sharedImageCache] clearMemory];
    [[SDImageCache sharedImageCache] clearDisk];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex==1){
        
        while ([[SDImageCache sharedImageCache] checkTmpSize])
        {
            [self clearMemory];
        }

        [_settingTableView reloadData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
