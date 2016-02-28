//
//  LKPrizeCell.h
//  Luckeys
//
//  Created by 李锦华 on 15/10/4.
//  Copyright © 2015年 Luckeys. All rights reserved.
//  中奖信息cell(我的页面)

#import <UIKit/UIKit.h>
@class LKTypeData;
@interface LKPrizeCell : UITableViewCell
@property(nonatomic,strong)UIImageView *typeImageView;
@property(nonatomic,strong)UILabel *prizeTitleLabel;
@property(nonatomic,strong)UILabel *timeLabel;
@property(nonatomic,strong)UIButton *loveButton;
@property(nonatomic,strong)UILabel *loveCountLabel;
-(void)setViewsFrame:(LKTypeData *)prizeData;
@end
