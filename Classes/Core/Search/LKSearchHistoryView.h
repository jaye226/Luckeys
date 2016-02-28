//
//  SearchHistoryView.h
//  MLPlayer
//
//  Created by 李锦华 on 15/8/31.
//  Copyright (c) 2015年 w. All rights reserved.
//  搜索历史纪录

#import <UIKit/UIKit.h>
#import "LKSearchHistoryDelegate.h"
@class LKSearchData;
@interface LKSearchHistoryView : UIView<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
@property(nonatomic,weak)id<LKSearchHistoryDelegate>selectSearchdelegate;
@property(nonatomic,weak)id<LKDeleteHistoryDelegate>deleteHistoryDelegate;
@property(nonatomic,weak)id<LKHiddenKeyBoardDelegete>hiddenKeyBoardDelegete;
-(void)refreshTable:(NSArray*)newArray;
-(void)resetContentoffset;
@end
