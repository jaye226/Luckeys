//
//  LKBindingPhoneCell.m
//  Luckeys
//
//  Created by 李锦华 on 15/10/4.
//  Copyright © 2015年 Luckeys. All rights reserved.
//

#import "LKBindingPhoneCell.h"

@implementation LKBindingPhoneCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.width = UI_IOS_WINDOW_WIDTH;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createView];
    }
    return self;
}

-(void)createView{
    _bindingLabel=[[UILabel alloc] initWithFrame:CGRectZero];
    _bindingLabel.backgroundColor=[UIColor clearColor];
    _bindingLabel.font=[UIFont systemFontOfSize:14];
    _bindingLabel.textColor=UIColorRGB(kContentColor_six);
    [self.contentView addSubview:_bindingLabel];
    
    _phoneNumLabel=[[UILabel alloc] initWithFrame:CGRectZero];
    _phoneNumLabel.backgroundColor=[UIColor clearColor];
    _phoneNumLabel.font=[UIFont systemFontOfSize:15];
    _phoneNumLabel.textColor=UIColorRGB(kContentColor_three);
    [self.contentView addSubview:_phoneNumLabel];
    
    _sepLine=[[UIView alloc] initWithFrame:CGRectMake(18, 69.5, UI_IOS_WINDOW_WIDTH-36, 0.5)];
    _sepLine.backgroundColor=UIColorRGB(KSepLineColor_e);
    [self.contentView addSubview:_sepLine];
}

-(void)setViewsFrame:(NSString*)phoneNum boolWith:(BOOL)isMy{
    CGSize bingSize=[LKTools getStringSize:@"已绑手机号" fontSize:14];
    CGSize phoneNumSize=[LKTools getStringSize:STR_IS_NULL(phoneNum) fontSize:15];
    CGFloat originY=(70-(bingSize.height+phoneNumSize.height+6))/2;
    _bindingLabel.frame=CGRectMake(18, originY, bingSize.width, bingSize.height);
    _phoneNumLabel.frame=CGRectMake(18, CGRectGetMaxY(_bindingLabel.frame)+6, phoneNumSize.width+20, phoneNumSize.height);
    _bindingLabel.text=@"已绑手机号";
    
    if (phoneNum.length > 0 && phoneNum.length == 11) {
        if (isMy)
        {
            _phoneNumLabel.text=phoneNum;
        }
        else
        {
            _phoneNumLabel.text=[NSString stringWithFormat:@"%@*****%@",[phoneNum substringToIndex:3],[phoneNum substringFromIndex:8]];

        }
    }else{
        _phoneNumLabel.text=@"无";
    }

}
@end
