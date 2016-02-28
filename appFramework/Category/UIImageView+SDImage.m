//
//  UIImageView+SDImage.m
//  MLPlayer
//
//  Created by BearLi on 15/11/2.
//  Copyright © 2015年 w. All rights reserved.
//

#import "UIImageView+SDImage.h"

@implementation UIImageView (SDImage)

- (void)setImageUrl:(NSString*)imageUrl placeholderImage:(UIImage*)placeholder complete:(void(^)(UIImage * image))block {
    if (imageUrl.length == 0) {
        return;
    }
    UIImage * cacheImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:imageUrl];
    if (cacheImage) {
        self.image = cacheImage;
        if (block) {
            block(cacheImage);
        }
    }
    else{
        
        [self sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:placeholder completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image) {
                if (block) {
                    block(image);
                }
            }
        }];
    }
}

@end
