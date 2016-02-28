//
//  PADBManager.h
//  MLPlayer
//
//  Copyright (c) 2014 w. All rights reserved.
//

/**
 *  此类 依赖以下类
    1:SQLitePersistentObject 第三方类 （数据库模型存储基类）；
    2:要做缓存的继承于SQLitePesrsistentObject的知鸟model类；
 
    Alert:如果获取缓存方法有block回调的,将第一次请求方法放进回调里.
 */

#import <Foundation/Foundation.h>
@class SQLitePersistentObject;
@class LKSearchData;;
typedef void (^ handleArray) (NSArray * array);

@interface LKDBManager : NSObject

+ (LKDBManager*)shareManager;

+ (void)initDBWithUM:(NSString *)umid;

#pragma mark - 增
/**
 *  保存数据 （必须是SQLitePersistentObject类型,或其集合）
 *  尽量传入数组做一次性操作
 *  该方法为异步,同步请直接调用父类的 save。
 *
 *  @param obj 数据源，必须是SQLitePersistentObject类型
 */
+ (void)saveModels:(id)obj;

#pragma mark - 删
/**
 *  删除数据 ，（必须是SQLitePersistentObject类型,或其集合）
 *
 *  @param obj 数据源
 */
+ (void)deleteModels:(id)obj;

#pragma mark - 改
/**
 *  更新数据库数据,目前只支持单个数据 (参数需为SQLitePersistentObject类型)
 *
 *  @param sourceModel 要替换的数据
 */
+ (void)updateModel:(id)sourceModel;


#pragma mark - 搜索历史
/**
 *  查询历史搜索记录
 *
 *  @param type  搜索类型
 *  @param block 查询结果
 */
+ (void)getAllSearchHistoryWithType:(NSInteger)type handle:(void (^)(NSArray* array))block;

/**
 *  更新某条历史搜索记录
 *
 *  @param PASearchData   搜索data
 *  @param block     更新是否成功回调
 */
+ (void)updateSearchHistory:(LKSearchData*)searchData handle:(void(^)(BOOL))block;

/**
 *  删除某条历史搜索记录
 *
 *  @param PASearchData   搜索data
 *  @param block     删除是否成功回调 当searchData为nil时删除所有历史搜索记录
 */
+ (void)deleteSearchHistory:(LKSearchData*)searchData handle:(void(^)(BOOL))block;

/**
 *  查询某条数据
 *
 *  @param searchKey 查询字段
 *  @param block     查询成功与否回调
 *
 *  @return 查询结果
 */
//+(PASearchData*)findRecordBySearchKey:(NSString*)searchKey;

+(void)deleteRecordWithSearchKey:(NSString*)searchKey;

@end
