//
//  LKShareMsgModel.h
//  Luckeys
//
//  Created by BearLi on 15/11/1.
//  Copyright © 2015年 Luckeys. All rights reserved.
//

#import "NBaseModel.h"

#define kQuerySharePageRefshTag     900010  //朋友圈下拉刷新
#define kQueryShareMoreRefshTag     900011  //朋友圈加载更多 

#define kCollectionRefshTag         101000  //收藏刷新
#define kCollectionTag              101010
#define kLikeTag                    101011

#define kRequstCommentTag           202010  //评论
#define kWinUserBtn                 201010  //点赞

@interface LKShareMsgModel : NBaseModel

@property (nonatomic,assign) NSInteger collectionNextPage;
@property (nonatomic,assign) NSInteger shareNextPage;
@property (nonatomic,strong) NSMutableArray * collectionArray;
@property (nonatomic,strong) NSMutableArray * shareArray;

@end
