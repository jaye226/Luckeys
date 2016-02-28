//
//  LKShowBettingListView.m
//  Luckeys
//
//  Created by lishaowei on 15/12/29.
//  Copyright © 2015年 Luckeys. All rights reserved.
//

#import "LKShowBettingListView.h"

@interface LKShowBettingListView () <UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    UIView *_bjView;
}
@end

@implementation LKShowBettingListView

@synthesize dataArray = _dataArray;

+ (void)showListView:(NSArray *)array
{
    LKShowBettingListView *showBettingListView = [[LKShowBettingListView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    showBettingListView.dataArray = array;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addView];
    }
    return self;
}

- (void)addView
{
    self.backgroundColor = UIColorRGBA(0x969696, 0.5);
    
    self.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchesInside)];
    [self addGestureRecognizer:tapGestureRecognizer];
    
    _bjView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height/2, self.width, self.height/2)];
    _bjView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_bjView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _bjView.width, 50)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor blackColor];
    label.text = @"我的奖券";
    [_bjView addSubview:label];
    
    UIView *lineView=[[UIView alloc] initWithFrame:CGRectMake(0, label.height-SINGLE_LINE_ADJUST_OFFSET, _bjView.width, SINGLE_LINE_BOUNDS)];
    lineView.backgroundColor = UIColorRGB(0xe9e9e9);
    [_bjView addSubview:lineView];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, _bjView.width, _bjView.height-50) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_bjView addSubview:_tableView];
    
    [kUIWindow addSubview:self];
}

- (void)touchesInside
{
    [self removeFromSuperview];
}

#pragma mark - UITableViewDelegate、UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _bjView.width, 40)];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = [UIColor blackColor];
        label.tag = 100+indexPath.row;
        [cell.contentView addSubview:label];
        
        UIView *lineView=[[UIView alloc] initWithFrame:CGRectMake(BoundsOfScale(15), 40-SINGLE_LINE_ADJUST_OFFSET, UI_IOS_WINDOW_WIDTH-BoundsOfScale(15)*2, SINGLE_LINE_BOUNDS)];
        lineView.backgroundColor = UIColorRGB(0xe9e9e9);
        [cell.contentView addSubview:lineView];
        
    }
    
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:100+indexPath.row];
    label.text = [_dataArray objectAtIndex:indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

@end
