//
//  LKBindingPhoneCell.h
//  Luckeys
//
//  Created by 李锦华 on 15/10/4.
//  Copyright © 2015年 Luckeys. All rights reserved.
//  绑定手机号码cell

#import <UIKit/UIKit.h>

@interface LKBindingPhoneCell : UITableViewCell
@property(nonatomic,strong)UILabel *bindingLabel;
@property(nonatomic,strong)UILabel *phoneNumLabel;
@property(nonatomic,strong)UIView *sepLine;
-(void)setViewsFrame:(NSString*)phoneNum boolWith:(BOOL)isMy;
@end
