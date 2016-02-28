//
//  KKCommentView.h
//  KaiKaiBa
//
//  Created by lishaowei on 15/9/26.
//  Copyright © 2015年 battery. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KKCommentViewDelegate <NSObject>

@required
- (void)sendChange:(NSString *)sendString;

@end

@interface KKCommentView : UIView

@property (nonatomic, strong)UITextField *commentTextField;
@property (nonatomic, assign)CGFloat viewHeight;
@property (nonatomic, weak)id <KKCommentViewDelegate> delegate;

- (void)hiddenKeyboard;

@end
