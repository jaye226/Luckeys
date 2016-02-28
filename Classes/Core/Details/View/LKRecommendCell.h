//
//  LKRecommendCell.h
//  nstest
//
//  Created by lishaowei on 15/10/12.
//  Copyright © 2015年 Luckeys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKRecommendActivityData.h"

@interface LKRecommendCell : UITableViewCell

- (void)updateWithData:(LKRecommendActivityData *)recommendActivityData;

+ (CGFloat)getCellHeight;

@end
