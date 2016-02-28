//
//  LKWalletTableViewCell.h
//  Luckeys
//
//  Created by BearLi on 15/11/21.
//  Copyright © 2015年 Luckeys. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kBackOffsetX 18.0

@interface LKWalletTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView * tipImage;
@property (nonatomic, strong) PBUILabel * tipTitle;

@property (nonatomic, strong) UIImageView * sepImage;

@end
