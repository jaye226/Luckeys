//
//  LKSearchData.h
//  MLPlayer
//
//  Created by 李锦华 on 15/8/28.
//  Copyright (c) 2015年 w. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, SearchType) {
    Search_HomePage,
    Search_Find,
    Search_Discussion,
};

@interface LKSearchData : PADataObject 
@property(nonatomic,strong)NSString *umId;
@property(nonatomic,strong)NSString *searchKey;
@property(nonatomic,strong)NSString *searchDate;
@property(nonatomic,assign)NSInteger searchType;
@end
