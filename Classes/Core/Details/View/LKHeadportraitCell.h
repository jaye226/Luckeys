//
//  LKHeadportraitCell.h
//  Luckeys
//
//  Created by lishaowei on 15/10/12.
//  Copyright © 2015年 Luckeys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKBetUserData.h"

@protocol LKHeadportraitCellDelegate <NSObject>

- (void)changeHeadportraitBet:(LKBetUserData *)data;

/**
 *  显示投注码
 *
 *  @param codeArray
 */
- (void)showHeadporInside:(NSArray *)codeArray;

@end

@interface LKHeadportraitCell : UITableViewCell

@property (nonatomic, weak)id <LKHeadportraitCellDelegate> delegate;

- (void)updateWithData:(NSArray *)listdata;

+ (CGFloat)getCellHeight:(NSArray *)listdata;

@end
