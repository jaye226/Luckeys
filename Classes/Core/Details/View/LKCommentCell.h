//
//  LKCommentCell.h
//  nstest
//
//  Created by lishaowei on 15/10/12.
//  Copyright © 2015年 Luckeys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKCommentData.h"

@protocol LKCommentCellDelegate <NSObject>

- (void)changeLikeBtn:(LKCommentData *)commentData;

- (void)changeHeadBtn:(LKCommentData *)commentData;

@end

@interface LKCommentCell : UITableViewCell

@property (nonatomic, weak)id <LKCommentCellDelegate> delegate;

- (void)updateWithData:(LKCommentData *)commentData;

+ (CGFloat)getCellHeight:(LKCommentData *)commentData;

@end
