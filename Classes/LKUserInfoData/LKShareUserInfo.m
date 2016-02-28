//
//  LKShareUserInfo.m
//  Luckeys
//
//  Created by BearLi on 15/10/17.
//  Copyright © 2015年 Luckeys. All rights reserved.
//

#import "LKShareUserInfo.h"

static LKShareUserInfo * _shareUser;

@implementation LKShareUserInfo

+ (LKShareUserInfo*)share {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareUser = [[LKShareUserInfo alloc] init];
    });
    return _shareUser;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        _userInfo = [[LKUserData alloc] init];
    }
    return self;
}

@end
