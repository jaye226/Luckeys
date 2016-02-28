//
//  LKShowBettingListView.h
//  Luckeys
//
//  Created by lishaowei on 15/12/29.
//  Copyright © 2015年 Luckeys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LKShowBettingListView : UIView

@property (nonatomic,strong)NSArray *dataArray;

+ (void)showListView:(NSArray *)array;

@end
