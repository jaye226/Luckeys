//
//  LKFriendLikeCell.h
//  Luckeys
//
//  Created by 李锦华 on 15/10/17.
//  Copyright © 2015年 Luckeys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKPersonLikeData.h"

@protocol LKFriendLikeCellDelegate <NSObject>

- (void)changeHeadBtnUpInside:(LKPersonLikeData*)likeData;

@end

@interface LKFriendLikeCell : UITableViewCell

@property (nonatomic, strong) id <LKFriendLikeCellDelegate> delegate;

-(void)setContent:(LKPersonLikeData*)likeData;

@end
