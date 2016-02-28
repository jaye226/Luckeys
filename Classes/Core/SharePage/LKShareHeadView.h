//
//  LKShareHeadView.h
//  Luckeys
//
//  Created by lishaowei on 15/10/17.
//  Copyright © 2015年 Luckeys. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LKShareHeadViewDelegate <NSObject>

/**
 *  点击头像
 */
- (void)changeHeadImage;

/**
 *  点击背景
 */
- (void)changeBackgroundImage;

@end

@interface LKShareHeadView : UIView

@property (nonatomic,weak)id <LKShareHeadViewDelegate> delegate;

- (void)updateShareHeadeView;

@end
