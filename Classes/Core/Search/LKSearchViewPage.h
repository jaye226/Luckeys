//
//  LKSearchViewPage.h
//  Luckeys
//
//  Created by 李锦华 on 15/11/15.
//  Copyright © 2015年 Luckeys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKSearchHistoryDelegate.h"
#import "LKSearchHistoryCell.h"
#import "LKTypeListTableViewCell.h"
@interface LKSearchViewPage : LKBaseViewPage<UITextFieldDelegate,UIScrollViewDelegate,LKSearchHistoryDelegate,LKDeleteHistoryDelegate,LKHiddenKeyBoardDelegete,UITableViewDataSource,UITableViewDelegate,LKTypeListTableViewCellDelegate>

@end
