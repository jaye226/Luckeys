//
//  UIImageView+SDImage.h
//  MLPlayer
//
//  Created by BearLi on 15/11/2.
//  Copyright © 2015年 w. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (SDImage)

/**
 *  封装SDImage加载图片,附带block回调image
 *
 *  @param imageUrl    图片Url
 *  @param placeholder 占位图
 *  @param block       回调,方便使用image,可nil
 */
- (void)setImageUrl:(NSString*)imageUrl placeholderImage:(UIImage*)placeholder complete:(void(^)(UIImage * image))block;

@end
