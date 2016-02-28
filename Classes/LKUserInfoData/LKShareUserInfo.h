//
//  LKShareUserInfo.h
//  Luckeys
//
//  Created by BearLi on 15/10/17.
//  Copyright © 2015年 Luckeys. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LKUserData.h"

#define kShareUserInfo          [LKShareUserInfo share]

#define kUserPlaceholderImage   [UIImage imageWithName:@""]

/** 个人信息单例 */
@interface LKShareUserInfo : NSObject

@property (nonatomic,strong) LKUserData * userInfo;

@property (nonatomic,assign) BOOL isLogin;

+ (LKShareUserInfo*)share;

@end
