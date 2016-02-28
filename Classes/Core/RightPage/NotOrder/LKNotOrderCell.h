//
//  LKNotOrderCell.h
//  Luckeys
//
//  Created by lishaowei on 16/1/18.
//  Copyright © 2016年 Luckeys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKNotOrderData.h"

@interface LKNotOrderCell : UITableViewCell

+ (CGFloat)getCellHeight;

- (void)updateWithData:(LKNotOrderData *)data;

@end
