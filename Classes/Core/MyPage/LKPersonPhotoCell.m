//
//  LKPersonPhotoCell.m
//  Luckeys
//
//  Created by 李锦华 on 15/10/17.
//  Copyright © 2015年 Luckeys. All rights reserved.
//

#import "LKPersonPhotoCell.h"

@implementation LKPersonPhotoCell{
    UIImageView *photoImageView;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createView];
    }
    return self;
}

-(void)createView{
    CGSize photoTextSize=[LKTools getStringSize:@"头像" fontSize:16];
    UILabel *photoLabel=[[UILabel alloc] initWithFrame:CGRectMake(BoundsOfScale(16), (BoundsOfScale(89)-photoTextSize.height)/2, photoTextSize.width+20, photoTextSize.height)];
    [photoLabel setBackgroundColor:[UIColor clearColor]];
    [photoLabel setTextColor:UIColorRGB(0x666666)];
    photoLabel.text=@"头像";
    [self.contentView addSubview:photoLabel];
    
    self.width=UI_IOS_WINDOW_WIDTH-BoundsOfScale(36);
    photoImageView=[[UIImageView alloc] initWithFrame:CGRectMake(self.width-BoundsOfScale(76), BoundsOfScale(13), BoundsOfScale(60), BoundsOfScale(60))];
    [photoImageView setBackgroundColor:[UIColor clearColor]];
    photoImageView.userInteractionEnabled=YES;
    [self.contentView addSubview:photoImageView];
    
    UIView *sepLine=[[UIView alloc] initWithFrame:CGRectMake(BoundsOfScale(16),BoundsOfScale(88.5),  self.width-BoundsOfScale(32), 0.5)];
    [sepLine setBackgroundColor:UIColorRGB(KSepLineColor_e)];
    [self.contentView addSubview:sepLine];
}

-(void)setPhotoImageView:(NSString*)imageUrl{
    [photoImageView setImageFromURL:[NSURL URLWithString:imageUrl] placeHolderImage:[UIImage imageNamed:@"ll"]];
}
@end
