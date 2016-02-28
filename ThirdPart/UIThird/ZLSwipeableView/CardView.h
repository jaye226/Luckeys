//
//  CardView.h
//  ZLSwipeableViewDemo
//
//  Created by Zhixuan Lai on 11/1/14.
//  Copyright (c) 2014 Zhixuan Lai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKBettingData.h"

@protocol CardViewDelegate <NSObject>

- (void)selectButtonInsideWithBettingData:(LKBettingData *)data withBool:(BOOL)isSelectd;

@end

@interface CardView : UIView

@property UIColor *cardColor;

@property (nonatomic, weak)id <CardViewDelegate> delegate;
@property (nonatomic, strong)NSString *activityTypeUuid;    //类型

- (void)updateWith:(NSString *)nameString withTime:(NSString *)timeString WithBettingData:(LKBettingData *)data;

@end
