//
//  PBTools.h
//  Luckeys
//
//  Created by BearLi on 15/9/26.
//  Copyright © 2015年 Luckeys. All rights reserved.
//

#ifndef PBTools_h
#define PBTools_h

#define kAppWindow   [[UIApplication sharedApplication].delegate window] //获得window

#define SetPngImage(name,type) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:name ofType:type]]

#define SetJpgImage(name) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:name ofType:@"jpg"]]

//判断是否是字典
#define IsDictionaryClass(_send)  ([_send isKindOfClass:[NSDictionary class]] || [_send isKindOfClass:[NSMutableDictionary class]])

//判断是否是数组
#define IsArrayClass(_send)  ([_send isKindOfClass:[NSArray class]] || [_send isKindOfClass:[NSMutableArray class]])

//字符串是否为空
#define IsStrEmpty(_ref)    (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) ||([(_ref) isEqualToString:@""]) || ((_ref).length)==0)

//数组是否为空
#define IsArrEmpty(_ref)    (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) ||([(_ref) count] == 0))

//字符串bool为YES
#define IsStrBoolValue(_string)  ((_string.integerValue > 0) || [_string.lowercaseString isEqualToString:@"y"] || [_string.lowercaseString isEqualToString:@"true"])

#endif /* PBTools_h */
