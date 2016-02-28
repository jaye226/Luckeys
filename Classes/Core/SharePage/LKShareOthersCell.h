//
//  LKOthersCell.h
//  Luckeys
//
//  Created by lishaowei on 15/10/17.
//  Copyright © 2015年 Luckeys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKShareCellDelegate.h"
#import "LKFriendsData.h"

@interface LKShareOthersCell : UITableViewCell

@property (nonatomic, weak) id <LKShareCellDelegate> delegate;

- (void)updateCell:(LKFriendsData *)data;

+ (CGFloat)getCellHeight:(LKFriendsData *)data;

@end
