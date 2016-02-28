//
//  UIDetailsSectionCell.h
//  Luckeys
//
//  Created by lishaowei on 15/10/12.
//  Copyright © 2015年 Luckeys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDetailsSectionCell : UITableViewCell

+ (CGFloat)getCellHeight;

- (void)setNameWith:(NSString *)nameStr withHidden:(BOOL)hiddenBool;

@end
