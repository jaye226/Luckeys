//
//  LKShareCellDelegate.h
//  Luckeys
//
//  Created by lishaowei on 15/10/17.
//  Copyright © 2015年 Luckeys. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LKFriendsData.h"

typedef enum : NSUInteger {
    SHARE_LIKEBTN = 0,  //喜欢
    SHARE_COMMENTBTN,   //评论
    SHARE_HEADIMAGE,    //头像
    SHARE_DITY          //商品
} ChangeShareType;

@protocol LKShareCellDelegate <NSObject>

- (void)changeShareCellWithBtn:(ChangeShareType)type withData:(LKFriendsData *)data;

/**
 *  点击图片
 *
 *  @param array
 *  @param index 
 */
- (void)changeArrayImageViewWith:(NSArray *)array selectWith:(NSInteger)index;


@end
