//
//  SearchAssociateView.m
//  MLPlayer
//
//  Created by 李锦华 on 15/8/31.
//  Copyright (c) 2015年 w. All rights reserved.
//

#import "LKSearchAssociateView.h"
#import "LKSearchHistoryCell.h"
#import "LKSearchData.h"

@implementation LKSearchAssociateView{
    UITableView *_searchAssociateTableView;
    NSMutableArray *_searchAssociateArray;
}

- (void)dealloc
{
    _searchAssociateTableView.dataSource = nil;
    _searchAssociateTableView.delegate = nil;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _searchAssociateArray=[[NSMutableArray alloc] initWithCapacity:0];
        [self addTableView];
    }
    return self;
}

-(void)addTableView{
    if(!_searchAssociateTableView){
        _searchAssociateTableView=[[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
    }
    _searchAssociateTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _searchAssociateTableView.delegate=self;
    _searchAssociateTableView.dataSource=self;
    [self addSubview:_searchAssociateTableView];
}

-(void)refreshTable:(NSArray*)newArray{
    [_searchAssociateArray removeAllObjects];
    [_searchAssociateArray addObjectsFromArray:newArray];
    [_searchAssociateTableView reloadData];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_searchAssociateArray count];
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
    if(_searchAssociateArray.count>indexPath.row){
        LKSearchData *data=[_searchAssociateArray objectAtIndex:indexPath.row];
        cell.searchKeyLabel.text=data.searchKey;
    }
    if(indexPath.row==_searchAssociateArray.count-1){
        cell.sepLineView.hidden=YES;
    }else{
        cell.sepLineView.hidden=NO;
    }
    cell.searchKeyLabel.font=[UIFont systemFontOfSize:FontOfScale(13)];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(_searchAssociateArray.count>indexPath.row){
        LKSearchData *data=[_searchAssociateArray objectAtIndex:indexPath.row];
        if(_selectAssociateDelegate&&[_selectAssociateDelegate respondsToSelector:@selector(selectSearchAssociate:)]){
            [_selectAssociateDelegate selectSearchAssociate:data];
            //更新搜索数据时间戳
            //data.searchDate= [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]];
            //[data save];
        }
    }
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(_hiddenKeyBoardDelegete&&[_hiddenKeyBoardDelegete respondsToSelector:@selector(hiddenKeyBoard)]){
        [_hiddenKeyBoardDelegete hiddenKeyBoard];
    }
}

@end
