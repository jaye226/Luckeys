//
//  LKSearchHistoryDelegate.h
//  MLPlayer
//
//  Created by 李锦华 on 15/9/1.
//  Copyright (c) 2015年 w. All rights reserved.
//

#import <Foundation/Foundation.h>
//选择某条历史记录
@protocol LKSearchHistoryDelegate <NSObject>
-(void)selectSearchHistory:(LKSearchData*)data;
@end

@protocol LKDeleteHistoryDelegate <NSObject>
-(void)deleteSearchHistory:(LKSearchData*)data;
@end

//选择某条联想数据
@protocol LKSearchAssociateDelegate <NSObject>
-(void)selectSearchAssociate:(LKSearchData*)data;
@end


//隐藏键盘
@protocol LKHiddenKeyBoardDelegete <NSObject>
-(void)hiddenKeyBoard;
@end
