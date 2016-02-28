//
//  SearchHistoryCell.h
//  MLPlayer
//
//  Created by 李锦华 on 15/8/31.
//  Copyright (c) 2015年 w. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LKSearchHistoryCell : UITableViewCell
@property(nonatomic,strong)UILabel *searchKeyLabel; //搜索关键字显示label
@property(nonatomic,strong)UIView  *sepLineView;    //分割线
@property(nonatomic,strong)UIButton *deleteButton;  //记录删除button
+(CGFloat)getCellHeight;
@end
