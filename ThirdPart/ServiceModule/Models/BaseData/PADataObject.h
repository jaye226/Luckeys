//
//  BaseModel.h
//  TestEamp
//
//  Created by kmgao on 14/12/23.
//  Copyright (c) 2014年 kmgao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SQLitePersistentObject.h"

/**
 *  这个类依赖 SqlitePersistentObjects 框架
 */
@interface PADataObject : SQLitePersistentObject //NSObject

/*!
 @brief  把json串转成数据结构
 
 @param jsonString 把json字符串转化成类结构对象
 
 @return 返回对应的数据模型
 */

+(id)makeDataModelByJson:(NSString*)jsonString;


/*!
 @brief  子类可以覆盖定义自己的实现,基类只实现自己本身的属性值
 
 @param properties 转成对象数据模型的字典
 
 @return 返回对应的数据模型
 */

+(id)makeDataModel:(id)properties;

/*!
 @brief  获取这个类里所有非只读的属性列表,字典里key为属性名,值value为数据类型
 
 @return 返回这个类里所有的属性列表,包括基类
 */

+(NSDictionary*)getClassProperties;

/*!
 @brief  使用指定的字典给对象属性付值
 
 @param properties 字段属性字典
 
 @return 返回对应的数据模型
 */
-(id)initWithDictionary:(NSDictionary*)properties;

/*!
 @brief  如果类里自定义的类对象数组,则通过这个方法把字典里的字段付给的自定义类对象字段
 
 @param properties 类对象里的自定义类数组
 @param className  自定义类的名字
 @return 返回自定义的数据模型数据
 */

-(NSArray*)makeClassWithProperties:(NSArray*)properties customClassName:(NSString*)className;

+(NSArray*)makeClassWithProperties:(NSArray*)properties customClassName:(NSString*)className;

/*!
 @brief  通过字典给对象字段付值
 
 @param dic 付值的字典内容
 */
-(void)setValuesForKeysWithDictionary:(NSDictionary *)dic;

/*!
 @brief  把这个类里的字段转化成字典,key为属性名,value为属性值
 
 @return 类对象字段转化后的字典
 */
-(NSMutableDictionary*)toDictionary;

/*!
 @brief  输出转化成json字符口串
 
 @return 返回json字符串
 */
-(NSString*)toJsonString;

/*!
 @brief  通过给定包含PADataObject或Dictionary或NSArray 的数组,转化成json 字符串
 
 @param modelArray 通过给定包含BaseDataModel或Dictionary或NSArray的数组
 
 @return 返回json字符串
 */
+(NSString*)toJsonString:(NSArray*)modelArray;

/*!
 @brief  获取这个结构存取到数据库时的表名，具体子类通过覆盖提供,基类返回nil
 
 @return 返回这个结构存取到数据库时的表名
 */

//-(NSString*)getDBTableName;

/**
 *  @note 公共接口，各子类如果需要进行base64编码，则需要重载该接口
 *  由于每个子类需要base64解码的字段不同，需要各子类重载实现
 */
- (void)encodeWithBase64;

/**
 *  @note 公共接口，各子类如果需要进行base64解码，则需要重载该接口
 *  由于每个子类需要base64解码的字段不同，需要各子类重载实现
 */
- (void)decodeWithBase64;

/*!
 @brief  获取对象的UUID,由子类实现,基类返回nil
 
 @return 返回对象UUID
 */
-(NSString*)getUUID;


+(id)parseJsonData:(NSString*)json;

/**
 *  json数据转换为需要的对象
 *
 *  @param dataSource 数据源
 *
 *  @return 返回Dict 或 array ,一般为dict
 */
+ (id) jsonDataToObject:(id)dataSource;
@end

