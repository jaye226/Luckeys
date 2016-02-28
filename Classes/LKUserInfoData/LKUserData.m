//
//  x
//  Luckeys
//
//  Created by BearLi on 15/10/17.
//  Copyright © 2015年 Luckeys. All rights reserved.
//

#import "LKUserData.h"

@implementation LKUserData

- (instancetype)init
{
    self = [super init];
    if (self) {
        _userUuid = @"";
        _userName = @"";
        _userHead = @"";
        _userPhone = @"";
        _userType = @"";
        _createDate=@"";
    }
    return self;
}

@end
