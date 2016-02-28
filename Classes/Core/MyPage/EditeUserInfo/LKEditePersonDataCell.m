//
//  LKEditePersonDataCell.m
//  Luckeys
//
//  Created by 李锦华 on 15/10/17.
//  Copyright © 2015年 Luckeys. All rights reserved.
//

#import "LKEditePersonDataCell.h"

@implementation LKEditePersonDataCell
{
    UILabel *titleLabel;
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
    CGSize photoTextSize=[LKTools getStringSize:@"头像头像" fontSize:16];
    titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(BoundsOfScale(16), (BoundsOfScale(44)-photoTextSize.height)/2, photoTextSize.width+10, photoTextSize.height)];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setTextColor:UIColorRGB(0x666666)];
    [self.contentView addSubview:titleLabel];
    
    _detailField=[[LKTextField alloc] initWithFrame:CGRectMake(titleLabel.maxX,titleLabel.y,UI_IOS_WINDOW_WIDTH-BoundsOfScale(32)-titleLabel.maxX, photoTextSize.height)];
    [_detailField setBackgroundColor:[UIColor clearColor]];
    _detailField.textAlignment=NSTextAlignmentRight;
    _detailField.returnKeyType = UIReturnKeyDone;
    [_detailField setTextColor:UIColorRGB(0x333333)];
    [self.contentView addSubview:_detailField];
    
    _sepLine=[[UIView alloc] initWithFrame:CGRectMake(BoundsOfScale(16),BoundsOfScale(43.5),UI_IOS_WINDOW_WIDTH-BoundsOfScale(32), 0.5)];
    [_sepLine setBackgroundColor:UIColorRGB(KSepLineColor_e)];
    [self.contentView addSubview:_sepLine];
}

-(void)setTitleLabelText:(NSString*)titleText{
    [titleLabel setText:titleText];
}

-(void)setDetailFieldText:(NSString*)detailText{
    [_detailField setPlaceholder:detailText];
    _detailField.indexPath = self.indexPath;
}
@end
