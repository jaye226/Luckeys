//
//  LKBaskView.h
//  CardBrowser
//
//  Created by BearLi on 15/10/12.
//  Copyright © 2015年 llx. All rights reserved.

//晒一晒

#import <UIKit/UIKit.h>

@protocol LKBaskViewDelegate <NSObject>

- (void)handleBaskButtonAction:(NSInteger)buttonIndex;

@end


@interface LKBaskView : UIView

@property (nonatomic)BOOL isShareLocal;
@property (nonatomic,weak) id<LKBaskViewDelegate> delegate;

- (id) init;
- (id)initWithFrame:(CGRect)frame;
- (void)updateIsShareLocal:(BOOL)isShareLocal;

@end
