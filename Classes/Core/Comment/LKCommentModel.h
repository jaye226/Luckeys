//
//  LKCommentModel.h
//  Luckeys
//
//  Created by lishaowei on 15/11/15.
//  Copyright © 2015年 Luckeys. All rights reserved.
//

#import "NBaseModel.h"

#define kRequstCommentListTag       3001
#define kRequstCommentMoreTag       3002
#define kRequstCommentUsefulTag     3003
#define kRequstCommentTag           3004

@interface LKCommentModel : NBaseModel

@property (nonatomic, strong, readonly) NSMutableArray *infoArray;
@property (nonatomic, strong) NSMutableArray *loadMoreArray;

@end
