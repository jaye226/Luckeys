//
//  LKPersonLikeData.m
//  Luckeys
//
//  Created by 李锦华 on 15/10/17.
//  Copyright © 2015年 Luckeys. All rights reserved.
//

#import "LKPersonLikeData.h"

@implementation LKPersonLikeData
-(id)init{
    self=[super init];
    if(self){
       _imageUrl=@"";
       _name=@"";
       _time=@"";
    }
    return self;
}
@end
