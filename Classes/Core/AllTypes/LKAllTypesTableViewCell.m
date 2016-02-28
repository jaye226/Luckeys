//
//  LKAllTypesTableViewCell.m
//  Luckeys
//
//  Created by BearLi on 15/9/26.
//  Copyright © 2015年 Luckeys. All rights reserved.
//

#import "LKAllTypesTableViewCell.h"

@implementation LKAllTypesTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)createView
{
    self.backgroundColor = UIColorMakeRGB(240, 240, 240);
    _image = [[UIImageView alloc] initWithFrame:CGRectMake(kAllTypesStartX, 25/2, 20, 20)];
    [self.contentView addSubview:_image];
    
    _title = [[UILabel alloc] initWithFrame:CGRectMake(_image.maxX+10, 0, 100, self.contentView.height)];
    _title.backgroundColor = [UIColor clearColor];
    _title.textColor = UIColorMakeRGB(99, 99, 99);
    [self.contentView addSubview:_title];
    
    UIImageView *arrowImage = [[UIImageView alloc] initWithFrame:CGRectMake(UI_IOS_WINDOW_WIDTH-kLeftXOffSet-BoundsOfScale(20), 30/2, 10, 15)];
    arrowImage.image = [UIImage imageNamed:@"type_menu_arrow"];
    [self.contentView addSubview:arrowImage];
    
}

- (void)setImage:(UIImage *)image withTitle:(NSString *)titleStr
{
    _image.image = image;
    _title.text = titleStr;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
