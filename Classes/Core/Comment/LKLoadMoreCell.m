//
//  PAFeatureLoadMoreCell.m
//  MLPlayer
//
//  Created by lishaowei on 15/7/10.
//  Copyright (c) 2015年 w. All rights reserved.
//

#import "LKLoadMoreCell.h"

@interface LKLoadMoreCell ()
{
    UILabel *loadMoreLabel;
    UIActivityIndicatorView *activeView;
}

@end

@implementation LKLoadMoreCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self initLayout];
        
    }
    return self;
}

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initLayout];
    }
    return self;
}

- (void)initLayout
{
    self.backgroundColor = [UIColor whiteColor];
    
    activeView = [[UIActivityIndicatorView alloc]init];
    activeView.tag = 1000001;
    [activeView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    activeView.frame = CGRectMake((UI_IOS_WINDOW_WIDTH-150)/2+10, (44-20)/2, 20, 20);
    [self.contentView addSubview:activeView];

    loadMoreLabel = [[UILabel alloc] initWithFrame:CGRectMake((UI_IOS_WINDOW_WIDTH-150)/2+45, (44-20)/2, 150, 20)];
    loadMoreLabel.text = @"加载中...";
    loadMoreLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:loadMoreLabel];
}

- (void)startLoadMore
{
    activeView.frame = CGRectMake((UI_IOS_WINDOW_WIDTH-150)/2+10, (44-20)/2, 20, 20);
    
    loadMoreLabel.frame = CGRectMake((UI_IOS_WINDOW_WIDTH-150)/2+45, (44-20)/2, 150, 20);
    loadMoreLabel.textAlignment = NSTextAlignmentLeft;
    loadMoreLabel.text = @"加载中...";
    [activeView startAnimating];
}

- (void)stopLoadMore
{
    loadMoreLabel.frame = CGRectMake((UI_IOS_WINDOW_WIDTH-150)/2, (44-20)/2, 150, 20);
    loadMoreLabel.textAlignment = NSTextAlignmentCenter;
    loadMoreLabel.text = @"点击加载更多";
    [activeView stopAnimating];
}

+ (CGFloat)getCellHeight
{
    return kLoadMoreCellHeight;
}

@end
