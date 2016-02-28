//
//  LKRegisterInfoCell.h
//  Luckeys
//
//  Created by 李锦华 on 15/10/4.
//  Copyright © 2015年 Luckeys. All rights reserved.
//  注册信息cell

#import <UIKit/UIKit.h>
@class LKPersonInfoData;
@interface LKRegisterInfoCell : UITableViewCell
@property(nonatomic,strong)UILabel *nickNameLabel; //昵称
@property(nonatomic,strong)UILabel *addressLabel;  //地址
@property(nonatomic,strong)UILabel *registerTimeLabel;//用户注册时间
@property(nonatomic,strong)UIButton *selectButton; //勾选按钮
@property(nonatomic,strong)UIView *sepLine;
-(void)setViewsFrame:(LKUserData*)personData;
@end
