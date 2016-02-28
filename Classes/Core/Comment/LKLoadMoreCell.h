//
//  PAFeatureLoadMoreCell.h
//  MLPlayer
//
//  Created by lishaowei on 15/7/10.
//  Copyright (c) 2015年 w. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kLoadMoreCellHeight 44.0

@interface LKLoadMoreCell : UITableViewCell

- (void)startLoadMore;

- (void)stopLoadMore;

+ (CGFloat)getCellHeight;

@end
