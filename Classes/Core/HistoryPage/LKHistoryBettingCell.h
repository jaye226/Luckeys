//
//  LKHistoryBettingCell.h
//  Luckeys
//
//  Created by 李锦华 on 15/10/12.
//  Copyright © 2015年 Luckeys. All rights reserved.
//  历史投注

@protocol BettingLikeDelegate <NSObject>

-(void)bettingLike:(NSInteger)tag;

@end

#import <UIKit/UIKit.h>
@class LKHistoryBettingData;
@interface LKHistoryBettingCell : UITableViewCell
@property(nonatomic,strong)UIButton *likeBtn;
@property(nonatomic,assign)id<BettingLikeDelegate>bettingDelegate;
-(void)setBettingCellData:(LKHistoryBettingData*)data;
@end
