//
//  LKDetailsHeadView.h
//  Luckeys
//
//  Created by lishaowei on 15/10/12.
//  Copyright © 2015年 Luckeys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKDetailsData.h"

@protocol LKDetailsHeadViewDelegate <NSObject>

- (void)endCountdown;

- (void)changeWinUserBtn:(LKDetailsData *)detailsData;

- (void)changeWinHeadImageViewBtn:(NSString *)userId;

- (void)changeLike;

@end

@interface LKDetailsHeadView : UIView

@property (nonatomic, weak)id <LKDetailsHeadViewDelegate> delegate;

- (id)initWithData:(LKDetailsData *)detailsData;

//更新中奖人点赞信息
- (void)updateWinUser:(LKDetailsData *)detailsData;

- (void)updateLike:(LKDetailsData *)detailsData;

@end
