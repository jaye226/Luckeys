//
//  LKPersonLikeData.h
//  Luckeys
//
//  Created by 李锦华 on 15/10/17.
//  Copyright © 2015年 Luckeys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LKPersonLikeData : PADataObject
@property(nonatomic,strong)NSString *userUuid;
@property(nonatomic,strong)NSString *createDate;
@property(nonatomic,strong)NSString *nickName;
@property(nonatomic,strong)NSString *userHead;
@end
