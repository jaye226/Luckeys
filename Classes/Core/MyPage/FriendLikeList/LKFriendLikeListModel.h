//
//  LKFriendLikeListModel.h
//  Luckeys
//
//  Created by lishaowei on 15/11/21.
//  Copyright © 2015年 Luckeys. All rights reserved.
//

#import "NBaseModel.h"

#define kRequstFriendLikeListTag       6001
#define kRequstFriendLikeMoreTag       6002

@interface LKFriendLikeListModel : NBaseModel

@property (nonatomic,strong) NSMutableArray *infoArray;
@property (nonatomic, strong) NSMutableArray *loadMoreArray;

@end
