//
//  LKHistoryCell.h
//  Luckeys
//
//  Created by 李锦华 on 15/10/12.
//  Copyright © 2015年 Luckeys. All rights reserved.
//  中奖信息cell

#import <UIKit/UIKit.h>

@class LKHistoryBettingData;
@protocol LKHistoryPrizeDelegate;

@interface LKHistoryPrizeCell : UITableViewCell

@property (nonatomic,strong) UIButton * showBtn;//晒一晒
@property (nonatomic,assign) id<LKHistoryPrizeDelegate> delegate;
-(void)setPrizeCellData:(LKHistoryBettingData*)data;
+ (CGFloat)getHistoryCellHeight:(LKHistoryBettingData *)data;
@end


@protocol LKHistoryPrizeDelegate <NSObject>

/**
 *  晒一晒按钮回调
 *
 *  @param button 按钮
 */
- (void)handleShowButton:(LKHistoryBettingData *)data;



@end
