//
//  PADBManager.m
//  MLPlayer
//
//  Created by 徐仁杰 on 9/5/14.
//  Copyright (c) 2014 w. All rights reserved.
//

#import "LKDBManager.h"
#import "SQLiteInstanceManager.h"
#import "LKSearchData.h"


static NSString *dbPath = nil;
static NSString * PAUmId = nil;
static LKDBManager * DBManager = nil;
static dispatch_queue_t  queue;

@interface LKDBManager()

@end


@implementation LKDBManager

+ (LKDBManager*)shareManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!DBManager) {
            DBManager = [[LKDBManager alloc] init];
        }
    });
    return DBManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        if (queue == nil)
        {
            queue = dispatch_queue_create("com.PADBManager.queue", DISPATCH_QUEUE_SERIAL);
        }
    }
    return self;
}

+(id)allocWithZone:(struct _NSZone *)zone
{
    if(DBManager == nil){
        return [super allocWithZone:zone];
    }
    return DBManager;
}

+ (id)copyWithZone:(struct _NSZone *)zone
{
    return self;
}


#pragma mark - init

/**
 *  创建数据库，将数据库路径指向登录用户DB路径
 *
 *  @param myJID 当前登录JID
 */
+(void)initDBWithUM:(NSString *)umid{
    //创建数据库
    NSArray *paths = nil;
    NSString *documentsDirectory = nil;
    
    if (queue == nil)
    {
        queue = dispatch_queue_create("com.LKDBManager.queue", DISPATCH_QUEUE_SERIAL);
    }
    
    NSString * folerName = umid;
    if (!folerName.length) {
        return;
    }
    
    if (folerName.length) {
        PAUmId = folerName;
        paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        
        documentsDirectory = [[paths objectAtIndex:0] stringByAppendingPathComponent:folerName];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager createDirectoryAtPath:documentsDirectory withIntermediateDirectories:YES attributes:nil error:nil];
        dbPath = [NSString stringWithFormat:@"%@/lk.db",documentsDirectory];
        BOOL isExist = [fileManager fileExistsAtPath:dbPath];
        if (!isExist) {
            [fileManager createFileAtPath:dbPath contents:[NSData data] attributes:nil];
        }
        [[SQLiteInstanceManager sharedManager] closeDB];
        [[SQLiteInstanceManager sharedManager] setDatabaseFilepath:dbPath];
    }
    
}

+ (NSString *)tableName:(NSString*)name
{
    
    NSMutableString *ret = [NSMutableString string];
    for (int i = 0; i < name.length; i++)
    {
        NSRange range = NSMakeRange(i, 1);
        NSString *oneChar = [name substringWithRange:range];
        if ([oneChar isEqualToString:[oneChar uppercaseString]] && i > 0)
            [ret appendFormat:@"_%@", [oneChar lowercaseString]];
        else
            [ret appendString:[oneChar lowercaseString]];
    }
    return ret;
}

/**
 *  删除数据库
 *
 *  @return Success
 */
+(BOOL)deleteDB{
    if (!dbPath) {
        return FALSE;
    }
    NSError *error;
    BOOL success = [[NSFileManager defaultManager] removeItemAtPath:dbPath error:&error];
    return success;
}

//保存数据
+ (void)saveModels:(id)obj
{
    LKDBManager * manager = [LKDBManager shareManager];
    [manager DBManagerSave:obj];
}

- (void)DBManagerSave:(id)obj
{     
    if (!obj) {
        return ;
    }
    __block NSArray * array ;
    __block SQLitePersistentObject * sourceModel;
    if ([obj isKindOfClass:[NSArray class]] || [obj isKindOfClass:[NSMutableArray class]]) {
       array = [obj copy];
    }
    else if ([obj isKindOfClass:[SQLitePersistentObject class]])
    {
        sourceModel = obj;
    }

    dispatch_async(queue, ^{
        if ([obj isKindOfClass:[NSArray class]] || [obj isKindOfClass:[NSMutableArray class]]) {
            if (array.count <= 0) {
                return ;
            }
            for (SQLitePersistentObject * model in array) {
                [model save];
            }

        }
        else if ([obj isKindOfClass:[SQLitePersistentObject class]])
        {
            if (!sourceModel) {
                return;
            }
            [sourceModel save];
        }
    });
}

//删除数据
+ (void)deleteModels:(id)obj
{
    LKDBManager * manager = [LKDBManager shareManager];
    [manager DBManagerDelete:obj];
}

- (void)DBManagerDelete:(id)obj
{
    
    if (!obj) {
        return ;
    }
    
    __block NSArray * array ;
    __block SQLitePersistentObject * sourceModel;
    if ([obj isKindOfClass:[NSArray class]] || [obj isKindOfClass:[NSMutableArray class]]) {
        array = [obj copy];
    }
    else if ([obj isKindOfClass:[SQLitePersistentObject class]])
    {
        sourceModel = obj;
    }
    
    dispatch_async(queue, ^{
       
        if ([obj isKindOfClass:[NSArray class]] || [obj isKindOfClass:[NSMutableArray class]]) {
            if (array.count <= 0) {
                return ;
            }
            for (SQLitePersistentObject * model in array) {
                [model deleteObject];
                 NSLog(@"%@ delelte::::::::::::::::::::::%ld",NSStringFromClass(model.class),(long)[array indexOfObject:model]);
               
            }
        }
        else if ([obj isKindOfClass:[SQLitePersistentObject class]])
        {
            if (!sourceModel) {
                return;
            }
            [sourceModel deleteObject];
             NSLog( @"%s %@ delelte::::::::::::::::::::::",__FUNCTION__,NSStringFromClass(sourceModel.class));
        }
    });
    
}

//更新数据
+ (void)updateModel:(id)sourceModel
{
    if (!sourceModel) {
        return;
    }
    
    dispatch_async(queue, ^{
        
        if ([sourceModel isKindOfClass:[SQLitePersistentObject class]]) {
            [sourceModel save];
            NSLog(@"%@ update :::::::::::::",NSStringFromClass([sourceModel class]));
        }
        
    });
    
}



#pragma mark - 搜索历史
/**
 *  查询历史搜索记录
 *
 *  @param type  搜索类型
 *  @param block 查询结果
 */
+ (void)getAllSearchHistoryWithType:(NSInteger)type handle:(void (^)(NSArray* array))block{
    dispatch_async(queue, ^{
         NSArray* array=[LKSearchData findByCriteria:[NSString stringWithFormat:@"where um_id='%@'  order by search_date desc limit 20",PAUmId]];
         dispatch_sync(dispatch_get_main_queue(), ^{
             if (block) {
                 block(array);
             }
        });
    });
}

/**
 *  更新某条历史搜索记录
 *
 *  @param PASearchData   搜索data
 *  @param block     更新是否成功回调
 */
+ (void)updateSearchHistory:(LKSearchData*)searchData handle:(void(^)(BOOL))block{
    dispatch_async(queue, ^{
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (block) {
                block(YES);
            }
        });
    });
}

/**
 *  删除某条历史搜索记录
 *
 *  @param PASearchData   搜索data
 *  @param block     删除是否成功回调
 */
+ (void)deleteSearchHistory:(LKSearchData*)searchData handle:(void(^)(BOOL))block{
    if(!searchData){
        //删除所有历史搜索记录
        [LKDBManager getAllSearchHistoryWithType:0 handle:^(NSArray *array) {
            for (LKSearchData * data in array) {
                [data deleteObject];
            }
            if (block) {
                 block(YES);
            }
        }];
        return;
    }
    dispatch_async(queue, ^{
        LKSearchData * data = (LKSearchData*)[LKSearchData findFirstByCriteria:[NSString stringWithFormat:@"WHERE search_key = '%@' AND um_id = '%@'",searchData.searchKey,PAUmId]];
        if (data) {
            [data deleteObject];
        }
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (block) {
                block(data != nil);
            }
        });
    });
}

/**
 *  查询某条数据
 *
 *  @param searchKey 查询字段
 *  @param block     查询成功与否回调
 *
 *  @return 查询结果
 */
+(LKSearchData*)findRecordBySearchKey:(NSString*)searchKey{
    LKSearchData * data = (LKSearchData*)[LKSearchData findFirstByCriteria:[NSString stringWithFormat:@"WHERE search_key = '%@' AND um_id = '%@'",searchKey,PAUmId]];
    return data;
}

+(void)deleteRecordWithSearchKey:(NSString*)searchKey
{
    if (searchKey == nil) {
        return;
    }
     dispatch_async(queue, ^{
         LKSearchData* historyData = [self findRecordBySearchKey:searchKey];
         if(historyData){
             [historyData deleteObject];
         }
     });
}

@end
