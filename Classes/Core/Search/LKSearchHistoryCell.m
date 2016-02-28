//
//  SearchHistoryCell.m
//  MLPlayer
//
//  Created by 李锦华 on 15/8/31.
//  Copyright (c) 2015年 w. All rights reserved.
//

#import "LKSearchHistoryCell.h"

@implementation LKSearchHistoryCell


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat originX=25/2;
        if(IS_IPHONE_6P){
            originX=45/3;
        }
        _searchKeyLabel=[[UILabel alloc] initWithFrame:CGRectMake(originX, 0, UI_IOS_WINDOW_WIDTH-40, [[self class] getCellHeight]-0.5)];
        [_searchKeyLabel setTextColor:UIColorRGB(0x666666)];
        [self.contentView addSubview:_searchKeyLabel];

        _sepLineView=[[UIView alloc] initWithFrame:CGRectMake(0, [[self class] getCellHeight]-1,UI_IOS_WINDOW_WIDTH, 0.5)];
        [_sepLineView setBackgroundColor:UIColorRGB(0xe7e7e7)];
        [self.contentView addSubview:_sepLineView];
        
        _deleteButton=[UIButton buttonWithType:UIButtonTypeCustom];
        if(IS_IPHONE_6P){
            _deleteButton.frame=CGRectMake(UI_IOS_WINDOW_WIDTH-(38+61/3), 0, (38+61/3), self.frame.size.height);
            
        }else{
            _deleteButton.frame=CGRectMake(UI_IOS_WINDOW_WIDTH-(20+31/2), 0, (20+31/2), self.frame.size.height);
        }
        [_deleteButton setImage:[UIImage imageNamed:@"search_delete_someoneHistory"] forState:UIControlStateNormal];
        _deleteButton.hidden=YES;
        [self.contentView addSubview:_deleteButton];
    }
    return self;
}

+(CGFloat)getCellHeight{
    if(IS_IPHONE_6P){
        return 160/3;
    }else{
        return 42;
    }
}
@end
