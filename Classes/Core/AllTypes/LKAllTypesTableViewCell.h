//
//  LKAllTypesTableViewCell.h
//  Luckeys
//
//  Created by BearLi on 15/9/26.
//  Copyright © 2015年 Luckeys. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kAllTypesStartX 25.0

@interface LKAllTypesTableViewCell : UITableViewCell

@property (nonatomic,strong) UIImageView * image;
@property (nonatomic,strong) UILabel * title;

- (void)setImage:(UIImage *)image withTitle:(NSString *)titleStr;

- (void)createView;
@end
