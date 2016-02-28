//
//  LKTypeListTableViewCell.h
//  Luckeys
//
//  Created by BearLi on 15/9/29.
//  Copyright © 2015年 Luckeys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKTypeData.h"

#define kTypeListCellHeight  BoundsOfScale(270)
#define kTypeLikeButtonY 15

@protocol LKTypeListTableViewCellDelegate;

@interface LKTypeListTableViewCell : UITableViewCell

@property (nonatomic,strong) UIButton * likeImage;
@property (nonatomic,strong) UIButton * typeButton;
@property (nonatomic,weak) id<LKTypeListTableViewCellDelegate> delegate;
@property (nonatomic,strong) LKTypeData * typeData;

+ (CGFloat)heightForContent:(NSString*)content;

- (void)resetLikeImage:(LKTypeData*)data;

@end


@protocol LKTypeListTableViewCellDelegate <NSObject>

@optional
//喜欢按钮点击回调
- (void)likeButtonClick:(UIButton*)button;

//分类按钮点击回调
- (void)typeButtonClick:(UIButton*)button;

@end