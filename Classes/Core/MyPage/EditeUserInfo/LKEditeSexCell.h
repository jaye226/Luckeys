//
//  LKEditeSexCell.h
//  Luckeys
//
//  Created by 李锦华 on 15/10/17.
//  Copyright © 2015年 Luckeys. All rights reserved.
//  性别编辑cell
@protocol SelectSexDelegate <NSObject>

-(void)selectSex:(int)sexIndex;

@end

#import <UIKit/UIKit.h>

@interface LKEditeSexCell : UITableViewCell
@property(nonatomic,weak)id<SelectSexDelegate>selectSexDelegate;
@end
