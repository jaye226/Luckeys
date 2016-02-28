//
//  SearchHistoryView.m
//  MLPlayer
//
//  Created by 李锦华 on 15/8/31.
//  Copyright (c) 2015年 w. All rights reserved.
//

#import "LKSearchHistoryView.h"
#import "LKSearchHistoryCell.h"
#import "LKSearchData.h"

@implementation LKSearchHistoryView{
    UITableView *_searchHistoryTableView;
    NSMutableArray *_searchHistoryArray;
}

- (void)dealloc
{
    _searchHistoryTableView.delegate=nil;
    _searchHistoryTableView.dataSource=nil;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _searchHistoryArray=[[NSMutableArray alloc] initWithCapacity:0];
        [self addTableView];
    }
    return self;
}

-(void)addTableView{
    if(!_searchHistoryTableView){
        _searchHistoryTableView=[[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
    }
    _searchHistoryTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _searchHistoryTableView.delegate=self;
    _searchHistoryTableView.dataSource=self;
    [self addSubview:_searchHistoryTableView];
}

-(void)refreshTable:(NSArray*)newArray{
    [_searchHistoryArray removeAllObjects];
    [_searchHistoryArray addObjectsFromArray:newArray];
    [_searchHistoryTableView reloadData];
}

-(void)resetContentoffset{
    _searchHistoryTableView.contentOffset=CGPointMake(0, 0);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_searchHistoryArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(IS_IPHONE_6P){
        return 160/3;
    }else{
        return 42;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"Cell";
    LKSearchHistoryCell *cell = (LKSearchHistoryCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell){
        cell=[[LKSearchHistoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.deleteButton.hidden=NO;
    cell.deleteButton.tag=200+indexPath.row;
    [cell.deleteButton addTarget:self action:@selector(deleteSomeoneHistory:) forControlEvents:UIControlEventTouchUpInside];
    if(_searchHistoryArray.count>indexPath.row){
        LKSearchData *data=[_searchHistoryArray objectAtIndex:indexPath.row];
        cell.searchKeyLabel.text=[data.searchKey stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    if(indexPath.row==_searchHistoryArray.count-1){
        cell.sepLineView.hidden=YES;
    }else{
        cell.sepLineView.hidden=NO;
    }
    cell.searchKeyLabel.font=[UIFont systemFontOfSize:FontOfScale(13)];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(_searchHistoryArray.count==0){
        return 0.01;
    }else{
        if(IS_IPHONE_6P){
            return 36;
        }
        return 27;
    }
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView=[[UIView alloc] initWithFrame:CGRectZero];
    [headView setBackgroundColor:UIColorRGB(0xf1f1f1)];
    UILabel *titleLabel=[[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.text=@"历史记录";
    titleLabel.textColor=UIColorRGB(0x333333);
    titleLabel.font=[UIFont systemFontOfSize:FontOfScale(13)];
    [headView addSubview:titleLabel];
    
    UIButton *deleteButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [deleteButton setImage:[UIImage imageNamed:@"icon_delete_normal"] forState:UIControlStateNormal];
    [deleteButton setImage:[UIImage imageNamed:@"icon_delete_pressed"] forState:UIControlStateHighlighted];
    [deleteButton addTarget:self action:@selector(deleteAllSearchHistory) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:deleteButton];
    
    if(IS_IPHONE_6P){
        headView.frame=CGRectMake(0, 0, tableView.frame.size.width, 36);
        titleLabel.frame=CGRectMake(22.5, 0, 100, 36);
        deleteButton.frame=CGRectMake(tableView.frame.size.width-(38+61/3), 0, 38+61/3, 36);
    }else{
        headView.frame=CGRectMake(0, 0, tableView.frame.size.width, 27);
        titleLabel.frame=CGRectMake(12.5, 0, 100, 27);
        deleteButton.frame=CGRectMake(tableView.frame.size.width-(20+31/2), 0, 20+31/2, 27);
    }
    if(_searchHistoryArray.count==0){
        return nil;
    }else{
        return headView;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(_searchHistoryArray.count>indexPath.row){
        LKSearchData *data=[_searchHistoryArray objectAtIndex:indexPath.row];
        if(_selectSearchdelegate&&[_selectSearchdelegate respondsToSelector:@selector(selectSearchHistory:)]){
            [_selectSearchdelegate selectSearchHistory:data];
        }
    }
}

/**
 *  删除某条历史记录button触发
 *
 *  @param sender 触发button
 */
-(void)deleteSomeoneHistory:(UIButton*)sender{
    NSInteger index=sender.tag-200;
    if(_searchHistoryArray.count>index){
        LKSearchData *data=[_searchHistoryArray objectAtIndex:index];
        if(_deleteHistoryDelegate&&[_deleteHistoryDelegate respondsToSelector:@selector(deleteSearchHistory:)]){
            [_deleteHistoryDelegate deleteSearchHistory:data];
        }
     }
}

/**
 *  清空历史记录
 */
-(void)deleteAllSearchHistory{
    UIAlertView *deleteAlert=[[UIAlertView alloc] initWithTitle:nil message:@"是否清空历史记录?" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
    [deleteAlert show];
}

#pragma mark 
//UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex==1){
        if(_deleteHistoryDelegate&&[_deleteHistoryDelegate respondsToSelector:@selector(deleteSearchHistory:)]){
            [_deleteHistoryDelegate deleteSearchHistory:nil];
        }
    }
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(_hiddenKeyBoardDelegete&&[_hiddenKeyBoardDelegete respondsToSelector:@selector(hiddenKeyBoard)]){
        [_hiddenKeyBoardDelegete hiddenKeyBoard];
    }
}


@end
