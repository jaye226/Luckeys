//
//  LKEditePersonDataCell.h
//  Luckeys
//
//  Created by 李锦华 on 15/10/17.
//  Copyright © 2015年 Luckeys. All rights reserved.
//  编辑个人信息cell

#import <UIKit/UIKit.h>
#import "LKTextField.h"

@interface LKEditePersonDataCell : UITableViewCell

@property(nonatomic,strong)LKTextField *detailField;
@property(nonatomic,strong)UIView *sepLine;
@property(nonatomic,strong)NSIndexPath *indexPath;

-(void)setTitleLabelText:(NSString*)titleText;
-(void)setDetailFieldText:(NSString*)detailText;
@end
