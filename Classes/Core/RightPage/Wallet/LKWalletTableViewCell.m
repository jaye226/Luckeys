//
//  LKWalletTableViewCell.m
//  Luckeys
//
//  Created by BearLi on 15/11/21.
//  Copyright © 2015年 Luckeys. All rights reserved.
//

#import "LKWalletTableViewCell.h"

@implementation LKWalletTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.width = UI_IOS_WINDOW_WIDTH;
        self.height = BoundsOfScale(44.0);
        [self setup];
    }
    return self;
}

- (void)setup {
    _tipImage = [[UIImageView alloc] initWithFrame:CGRectMake(kBackOffsetX + 17, 0, 16, 16)];
    _tipImage.centerY = self.height/2.0;
    [self.contentView addSubview:_tipImage];
    
    _tipTitle = [[PBUILabel alloc] initWithFrame:CGRectMake(_tipImage.maxX + 12, 0, 200, self.height)];
    _tipTitle.systemFont = 16;
    _tipTitle.textColor = UIColorRGB(0x666666);
    _tipTitle.centerY = _tipImage.centerY;
    [self.contentView addSubview:_tipTitle];
    
    UIImage * arrow = UIImageNamed(@"wallet_menu_arrow");
    UIImageView * arrowImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.width - kBackOffsetX -20 - arrow.size.width, 0, arrow.size.width, arrow.size.height)];
    arrowImage.centerY = self.height/2.0;
    arrowImage.image = arrow;
    [self.contentView addSubview:arrowImage];
    
    UIImageView * sepImage = [[UIImageView alloc] initWithFrame:CGRectMake(kBackOffsetX+16, self.height-0.5, self.width-2*(kBackOffsetX+16), 0.5)];
    sepImage.image = [UIImage imageWithColor:UIColorRGB(0xe1e1e1)];
    [self.contentView addSubview:sepImage];
    _sepImage = sepImage;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
