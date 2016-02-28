//
//  LKPersonInfoData.h
//  Luckeys
//
//  Created by 李锦华 on 15/10/4.
//  Copyright © 2015年 Luckeys. All rights reserved.
//  个人数据信息

#import <Foundation/Foundation.h>

@interface LKPersonInfoData : NSObject
@property(nonatomic,strong)NSString *nickName;
@property(nonatomic,strong)NSString *address;
@property(nonatomic,strong)NSString *registerTime;
@property(nonatomic,strong)NSString *phoneNum;
@property(nonatomic,strong)NSString *passWord;
@property(nonatomic,strong)NSString *sex;
@property(nonatomic,strong)NSString *email;
@property(nonatomic,strong)NSString *birthday;
@property(nonatomic,strong)NSString *imageUrl;
@property(nonatomic,strong)NSArray *prizeArray;
@end
