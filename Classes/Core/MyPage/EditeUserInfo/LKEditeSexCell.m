//
//  LKEditeSexCell.m
//  Luckeys
//
//  Created by 李锦华 on 15/10/17.
//  Copyright © 2015年 Luckeys. All rights reserved.
//

#import "LKEditeSexCell.h"

@implementation LKEditeSexCell


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
    NSArray *sexArr=[NSArray arrayWithObjects:@"男性",@"女性",@"其他",nil];
    for (int i=0; i<sexArr.count; i++) {
        UIButton *sexButton=[UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat butttonWith= (UI_IOS_WINDOW_WIDTH)/3;
        sexButton.frame=CGRectMake(i*butttonWith,0,butttonWith, BoundsOfScale(44));
        [sexButton setTitleColor:UIColorRGB(0x666666) forState:UIControlStateNormal];
        [sexButton setTitleColor:UIColorRGB(0xff4f4f) forState:UIControlStateHighlighted];
        [sexButton setTitle:[sexArr objectAtIndex:i] forState:UIControlStateNormal];
        sexButton.tag=500+i;
        [sexButton addTarget:self action:@selector(clickSexButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:sexButton];
        if(i!=2){
            UIView *sepLine=[[UIView alloc] initWithFrame:CGRectMake((i+1)*butttonWith, BoundsOfScale(10), 1, BoundsOfScale(24))];
            [sepLine setBackgroundColor:UIColorRGB(KSepLineColor_e)];
            [self.contentView addSubview:sepLine];
        }
    }
    UIView *sepLine=[[UIView alloc] initWithFrame:CGRectMake(BoundsOfScale(16),BoundsOfScale(43.5),UI_IOS_WINDOW_WIDTH-BoundsOfScale(32), 0.5)];
    [sepLine setBackgroundColor:UIColorRGB(KSepLineColor_e)];
    [self.contentView addSubview:sepLine];
    
    UIButton *manBtn=(UIButton*)[self.contentView viewWithTag:500];
    UIButton *womenBtn=(UIButton*)[self.contentView viewWithTag:501];
    UIButton *otherBtn=(UIButton*)[self.contentView viewWithTag:502];
    
    if(![[LKShareUserInfo share].userInfo.sex intValue]){
        return;
    }
    
    if([[LKShareUserInfo share].userInfo.sex intValue]==0){
        [womenBtn setTitleColor:UIColorRGB(0xff4f4f) forState:UIControlStateNormal];
    }else if([[LKShareUserInfo share].userInfo.sex intValue]==1){
        [manBtn setTitleColor:UIColorRGB(0xff4f4f) forState:UIControlStateNormal];
    }else if([[LKShareUserInfo share].userInfo.sex intValue]==2){
        [otherBtn setTitleColor:UIColorRGB(0xff4f4f) forState:UIControlStateNormal];
    }

}

-(void)clickSexButton:(UIButton*)sender{
    //选择的btn
    UIButton *manBtn=(UIButton*)[self.contentView viewWithTag:500];
    UIButton *womenBtn=(UIButton*)[self.contentView viewWithTag:501];
    UIButton *otherBtn=(UIButton*)[self.contentView viewWithTag:502];
    if(sender.tag==500){
        [manBtn setTitleColor:UIColorRGB(0xff4f4f) forState:UIControlStateNormal];
        [womenBtn setTitleColor:UIColorRGB(0x666666) forState:UIControlStateNormal];
        [otherBtn setTitleColor:UIColorRGB(0x666666) forState:UIControlStateNormal];
    }else if(sender.tag==501){
        [manBtn setTitleColor:UIColorRGB(0x666666) forState:UIControlStateNormal];
        [womenBtn setTitleColor:UIColorRGB(0xff4f4f) forState:UIControlStateNormal];
        [otherBtn setTitleColor:UIColorRGB(0x666666) forState:UIControlStateNormal];
    }else{
        [manBtn setTitleColor:UIColorRGB(0x666666) forState:UIControlStateNormal];
        [womenBtn setTitleColor:UIColorRGB(0x666666) forState:UIControlStateNormal];
        [otherBtn setTitleColor:UIColorRGB(0xff4f4f) forState:UIControlStateNormal];
    }

    
    if(_selectSexDelegate&&[_selectSexDelegate respondsToSelector:@selector(selectSex:)]){
        [_selectSexDelegate selectSex:(int)(sender.tag-500)];
    }
}
@end
