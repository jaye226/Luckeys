//
//  LKHomeMsgModel.h
//  Luckeys
//
//  Created by BearLi on 15/10/17.
//  Copyright © 2015年 Luckeys. All rights reserved.
//

#import "NBaseModel.h"

@interface LKHomeMsgModel : NBaseModel

@property (nonatomic,strong,readonly) NSArray * dataArray;
@property (nonatomic,assign) NSInteger nextPage;
@property (nonatomic,assign) NSInteger totalPage;
@property (nonatomic,strong) NSString * message;
@end
