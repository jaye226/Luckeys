//
//  LKMyInfoCell.m
//  Luckeys
//
//  Created by 李锦华 on 15/10/4.
//  Copyright © 2015年 Luckeys. All rights reserved.
//

#import "LKMyInfoCell.h"
@implementation LKMyInfoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.width = UI_IOS_WINDOW_WIDTH;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createView];
    }
    return self;
}

-(void)createView{
    _nickNameLabel=[[UILabel alloc] initWithFrame:CGRectMake(BoundsOfScale(16), 0, 30, BoundsOfScale(44))];
    _nickNameLabel.backgroundColor=[UIColor clearColor];
    _nickNameLabel.font=[UIFont systemFontOfSize:32/2];
    _nickNameLabel.textColor=UIColorRGB(kContentColor_six);
    [self.contentView addSubview:_nickNameLabel];
    
    _detailLabel=[[UILabel alloc] initWithFrame:CGRectMake(BoundsOfScale(16), 0, 30, BoundsOfScale(44))];
    _detailLabel.backgroundColor=[UIColor clearColor];
    _detailLabel.font=[UIFont systemFontOfSize:32/2];
    _detailLabel.textColor=UIColorRGB(kContentColor_three);
    [self.contentView addSubview:_detailLabel];
    
    UIView *sepLine=[[UIView alloc] initWithFrame:CGRectMake(BoundsOfScale(36+32)/2, BoundsOfScale(44)-0.5, UI_IOS_WINDOW_WIDTH-BoundsOfScale(36+32), 0.5)];
    sepLine.backgroundColor=UIColorRGB(KSepLineColor_e);
    [self.contentView addSubview:sepLine];
}
@end
