//
//  SearchAssociateView.h
//  MLPlayer
//
//  Created by 李锦华 on 15/8/31.
//  Copyright (c) 2015年 w. All rights reserved.
//  搜索联想
#import <UIKit/UIKit.h>
#import "LKSearchHistoryDelegate.h"
@interface LKSearchAssociateView : UIView<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,weak)id<LKSearchAssociateDelegate>selectAssociateDelegate;
@property(nonatomic,weak)id<LKHiddenKeyBoardDelegete>hiddenKeyBoardDelegete;
-(void)refreshTable:(NSArray*)newArray;
@end
