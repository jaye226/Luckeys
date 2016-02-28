//
//  PADataObject.m
//  TestEamp
//
//  Created by kmgao on 14/12/23.
//  Copyright (c) 2014年 kmgao. All rights reserved.
//

#import "PADataObject.h"
#import <objc/runtime.h>

@interface NSObject(PropertyTypeValue)

+(NSDictionary*)getClassPropertysAndType;
-(NSMutableArray *)outPutArray;
-(NSMutableDictionary *)outPutDic;

@end


@implementation NSObject(PropertyTypeValue)

static NSDictionary *primitivesNames = nil;
//获取一个类的属性名和类型
+(NSDictionary*)getClassPropertysAndType
{
    if(primitivesNames== nil){
        primitivesNames = @{@"f":@"float", @"i":@"int", @"d":@"double", @"l":@"long", @"c":@"BOOL", @"s":@"short", @"q":@"long",
                            //and some famos aliases of primitive types
                            // BOOL is now "B" on iOS __LP64 builds
                            @"I":@"NSInteger", @"Q":@"NSUInteger", @"B":@"BOOL",
                            
                            @"@?":@"Block"};
    }
    NSMutableDictionary *properts_info = [[NSMutableDictionary alloc] init];
    
    Class curClass = [self class];
    NSScanner *scanner = nil;
    NSString* propertyType = nil;
    
    while (curClass && curClass != [NSObject class]) {
        
        objc_property_t  *propItems;
        unsigned int     ncount = 0;
        propItems = class_copyPropertyList(curClass, &ncount);
        
        for(int i = 0; i < ncount; i++){
            objc_property_t prop_item = propItems[i];
            const char *properName = property_getName(prop_item);
            const char *attribute = property_getAttributes(prop_item);
            
            NSString* propertyAttributes = @(attribute);
            
            NSString  *proper_Name = @(properName);
            
            NSArray* attributeItems = [propertyAttributes componentsSeparatedByString:@","];
            //ignore read-only properties
            if([attributeItems containsObject:@"R"]){
                continue;//to next property
            }
            
            //check for 64b BOOLs
            if ([propertyAttributes hasPrefix:@"Tc,"]) {
                //mask BOOLs as structs so they can have custom convertors
                propertyType = @"BOOL";
            }
            
            scanner = [NSScanner scannerWithString:propertyAttributes];
            [scanner scanUpToString:@"T" intoString: nil];
            [scanner scanString:@"T" intoString:nil];
            
            //check if the property is an instance of a class
            if ([scanner scanString:@"@\"" intoString: &propertyType]) {
                
                [scanner scanUpToCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@"\"<"]
                                        intoString:&propertyType];
                
                //read through the property protocols
                while ([scanner scanString:@"<" intoString:NULL]) {
                    
                    [scanner scanUpToString:@">" intoString:&propertyType];
                    
                    [scanner scanString:@">" intoString:NULL];
                }
            }
            //check if the property is a structure
            else if ([scanner scanString:@"{" intoString: &propertyType]) {
                [scanner scanCharactersFromSet:[NSCharacterSet alphanumericCharacterSet]
                                    intoString:&propertyType];
                
            }
            else if([[attributeItems firstObject] isEqualToString:@"T@"]){
                propertyType = @"id";
            }
            else if([[attributeItems firstObject] isEqualToString:@"T@?"]){
                propertyType = @"Block";
            }
            //the property must be a primitive
            else {
                //the property contains a primitive data type
                [scanner scanUpToCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@","]
                                        intoString:&propertyType];
                //get the full name of the primitive type
                propertyType = primitivesNames[propertyType];
            }
            
            if(propertyType){
                properts_info[proper_Name] = propertyType;
            }
            
        }
        free(propItems);
        
        curClass = [curClass superclass];
    }
    
    NSDictionary *prop_info = [properts_info copy];
    properts_info = nil;
    
    return prop_info;
}

-(NSMutableArray *)outPutArray
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSArray *selfArray = (NSArray *)self;
    for (int itemIndex = 0; itemIndex < selfArray.count; itemIndex++) {
        id value = [selfArray objectAtIndex:itemIndex];
        
        unsigned int outCount;
        objc_property_t *properties = class_copyPropertyList([value class], &outCount);
        
        if(outCount > 0)
        {
            [array addObject:[value outPutDic]];
        }
        else {
            [array addObject:value];
        }
        
        free(properties);
    }
    
    return array;
}

-(NSMutableDictionary *)outPutDic
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    NSDictionary   *propertiesInfo = [[self class] getClassPropertysAndType];
    
    [propertiesInfo enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSString *propertyName = (NSString*)key;
        NSString *propertyType = (NSString*)obj;
        if(propertyName){                
            if([NSClassFromString(propertyType) isSubclassOfClass:NSClassFromString(@"NSString")])
            {
                if([self valueForKey:propertyName] == nil){
                    [dict setObject:@"" forKey:propertyName];
                }
                else{
                    [dict setObject:[self valueForKey:propertyName] forKey:propertyName];
                }
            }
            else if ([NSClassFromString(propertyType) isSubclassOfClass:NSClassFromString(@"NSNumber")])
            {
                if([self valueForKey:propertyName] == nil){
                    [dict setObject:[NSNull null] forKey:propertyName];
                }
                else{
                    [dict setObject:[self valueForKey:propertyName] forKey:propertyName];
                }
            }
            else if ([NSClassFromString(propertyType) isSubclassOfClass:NSClassFromString(@"NSArray")])
            {
                if([self valueForKey:propertyName] == nil){
                    [dict setObject:[NSArray array] forKey:propertyName];
                }
                else{
                    NSArray *value = [self valueForKey:propertyName];
                    NSArray *arrayOfValue = [value outPutArray];
                    [dict setObject:arrayOfValue forKey:propertyName];
                }
            }
            else if ([NSClassFromString(propertyType) isSubclassOfClass:NSClassFromString(@"NSDictionary")])
            {
                if([self valueForKey:propertyName] == nil){
                    [dict setObject:[NSDictionary dictionary] forKey:propertyName];
                }
                else{
                    NSDictionary *value = [self valueForKey:propertyName];
                    NSDictionary *dictOfValue = [value outPutDic];
                    [dict setObject:dictOfValue forKey:propertyName];
                }
            }
            else if ([NSClassFromString(propertyType) isSubclassOfClass:NSClassFromString(@"NSData")])
            {
                if([self valueForKey:propertyName] == nil){
                    [dict setObject:[NSNull null] forKey:propertyName];
                }
                else{
                    NSDictionary *value = [self valueForKey:propertyName];
                    [dict setObject:value forKey:propertyName];
                }
            }
            else if([propertyType isEqualToString:primitivesNames[@"i"]])
            {
                [dict setObject:[NSNumber numberWithInt:[[self valueForKey:propertyName] intValue]] forKey:propertyName];
            }
            else if([propertyType isEqualToString:primitivesNames[@"I"]])
            {
                [dict setObject:[NSNumber numberWithInteger:[[self valueForKey:propertyName] integerValue]] forKey:propertyName];
            }
            else if([propertyType isEqualToString:primitivesNames[@"Q"]])
            {
                [dict setObject:[NSNumber numberWithUnsignedInteger:[[self valueForKey:propertyName] unsignedIntegerValue]] forKey:propertyName];
            }
            else if([propertyType isEqualToString:primitivesNames[@"B"]] || [propertyType isEqualToString:primitivesNames[@"c"]])
            {
                [dict setObject:[NSNumber numberWithInt:[[self valueForKey:propertyName] boolValue]] forKey:propertyName];
            }
            else if([propertyType isEqualToString:primitivesNames[@"d"]]){
                [dict setObject:[NSNumber numberWithDouble:[[self valueForKey:propertyName] doubleValue]] forKey:propertyName];
            }
            else if([propertyType isEqualToString:primitivesNames[@"f"]])
            {
                [dict setObject:[NSNumber numberWithFloat:[[self valueForKey:propertyName] floatValue]] forKey:propertyName];
            }
            else if([propertyType isEqualToString:primitivesNames[@"l"]] || [propertyType isEqualToString:primitivesNames[@"q"]])
            {
                [dict setObject:[NSNumber numberWithLong:[[self valueForKey:propertyName] longValue]] forKey:propertyName];
            }
            else if([propertyType isEqualToString:primitivesNames[@"s"]])
            {
                [dict setObject:[NSNumber numberWithShort:[[self valueForKey:propertyName] shortValue]] forKey:propertyName];
            }
            else if([propertyType isEqualToString:@"id"])
            {
                //can't convert.
                id value = [self valueForKey:propertyName];
                if (value) {
                    NSDictionary *dictOfValue = [value outPutDic];
                    [dict setObject:dictOfValue forKey:propertyName];
                }
                else{
                    [dict setObject:[NSNull null] forKey:propertyName];
                }
            }
            else if([propertyType isEqualToString:@""])
            {
                //can't convert.
            }
            else {
                id value = [self valueForKey:propertyName];
                if (value) {
                    NSDictionary *dictOfValue = [value outPutDic];
                    [dict setObject:dictOfValue forKey:propertyName];
                }
                else{
                    [dict setObject:[NSNull null] forKey:propertyName];
                }
            }
        }
    }];
    
    propertiesInfo = nil;
    
    return dict;
}

@end


@implementation PADataObject

+(id)makeDataModelByJson:(NSString*)jsonString
{
    if (jsonString != nil) {
        
        id dicInfo = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
        
        return [self makeDataModel:dicInfo];
    }
    
    return nil;
}

+(id)makeDataModel:(id)properties
{
    if([properties isKindOfClass:[NSDictionary class]]){
        id obj = [[self alloc] init];
        [obj setValuesForKeysWithDictionary:properties];
        return obj;
    }
    else if([properties isKindOfClass:[self class]]){
        return properties;
    }
    return nil;
}

-(id)initWithDictionary:(NSDictionary*)properties
{
    self = [super init];
    if(self){
        [self setValuesForKeysWithDictionary:properties];
    }
    return self;
}

-(void)setValuesForKeysWithDictionary:(NSDictionary *)dic
{
    NSMutableDictionary *dicTmp = [self outPutDic];
    for (id key in [dicTmp allKeys]) {
        id value = [dic objectForKey:key];
        if (value) {
            [self setValue:value forKey:key];
        }
    }
     [dicTmp removeAllObjects];
     dicTmp = nil;
}  

-(NSArray*)makeClassWithProperties:(NSArray*)properties customClassName:(NSString*)className
{
    if(!properties || properties.count <= 0 || className == nil || [className isEqualToString:@""]){
        return properties;
    }
    
    NSMutableArray  *dataArray = [[NSMutableArray alloc] initWithCapacity:10];
    for (int i = 0; i < properties.count ;i++) {
        Class cls = NSClassFromString(className);
        id sub = properties[i];
        
        if([cls isSubclassOfClass:[PADataObject class]]){
            id obj = [cls makeDataModel:sub];
            if(obj){
                [dataArray addObject:obj];
            }
        }
    }
    return dataArray;
}

+(NSArray*)makeClassWithProperties:(NSArray*)properties customClassName:(NSString*)className
{
    PADataObject *parse = [[self alloc] init];
    NSArray* returnArray = [parse makeClassWithProperties:properties customClassName:className];
    parse = nil;
    return returnArray;
}

-(NSMutableDictionary*)toDictionary
{
    return [self outPutDic];
}

-(NSString*)toJsonString
{
    NSMutableDictionary *propInfo = [self toDictionary];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:propInfo options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    return jsonString;
}

+(NSString*)toJsonString:(NSArray*)modelArray
{
    if(modelArray == nil || modelArray.count <= 0) return nil;
    
    NSMutableArray *jsonArray = [NSMutableArray array];
    
    for(id sub in modelArray){
        if([sub isKindOfClass:[PADataObject class]]){
            [jsonArray addObject:[sub toDictionary]];
        }
        else if([sub isKindOfClass:[NSDictionary class]]){
            [jsonArray addObject:sub];
        }
        else if([sub isKindOfClass:[NSArray class]]){
            return [PADataObject toJsonString:(NSArray*)sub];
        }
    }
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonArray options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    [jsonArray removeAllObjects];
    jsonArray = nil;
    return jsonString;
}


+(NSDictionary*)getClassProperties
{
    return [self getClassPropertysAndType];
}


//-(NSString*)getDBTableName
//{
//    return NSStringFromClass(self.class);
//}

- (void)encodeWithBase64
{
    //由子类需要进行base64编码时重载实现
}


- (void)decodeWithBase64
{
    //由子类需要进行base64解码时重载实现
}

-(NSString*)getUUID
{
  //由子类需要进行base64解码时重载实现
    return nil;
}

+(NSString*)JsonStringQuote:(NSString*)orgJson
{
    unichar ch = 0;
    NSInteger slen = orgJson.length*2;
    unichar *buffer = (unichar*)malloc(slen);
    memset(buffer, 0, slen);
    
    int j = 0;
    for (int i = 0; i < slen/2; i++) {
        ch = [orgJson characterAtIndex:i];
        
        switch (ch) {
            case '\v'://垂直制表(VT)
                
                break;
            case '\f'://换页(FF)，将当前位置移到下页开头
                
                break;
            case '\t'://水平制表(HT) （跳到下一个TAB位置）
                
                break;
            case '\a'://响铃(BEL)
                
                break;
            case '\b'://退格(BS) ，将当前位置移到前一列
                
                break;
                //            case '\r'://代表一个反斜线字符''\'
                //
                //                break;
                //            case '\''://代表一个单引号符'''
                //
                //                break;
            case '\\':
                if (i < (slen/2-1)) {//做下换行字符特殊处理
                    unichar c = [orgJson characterAtIndex:i+1];
                    if (c == 'r' || c == 'n') {
                        buffer[j++] = ch;
                    }
                    else if (c == '\\')
                    {
                        //解决名称中包含类似于"\\n\\l\\a"这种字符串的显示问题
                        buffer[j++] = ch;
                        buffer[j++] = ch;
                        i++;
                    }
                    else{
                        i ++;//忽烈其它非法字符
                    }
                }
                break;
            default:
                buffer[j++] = ch;
                break;
        }
        
    }
    
    NSString *newString = [NSString stringWithCharacters:buffer length:j];
    
    free(buffer);
    
    return newString;
}




+(id)parseJsonData:(NSString*)json
{
    if (json == nil || [json isEqualToString:@""]) {
        return nil;
    }
    
    //过滤掉tab键值,不然json解析会出错
//    NSString *responseString = [json stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    NSString *responseString = [self JsonStringQuote:json];
    
    NSData *jsonData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
    if (jsonData != nil) {//@2015-09-11 kmgao
        //注:这里 NSJSONSerialization JSONObjectWithData 不能传nil,否则会crash
        //crash 异常信息 NSInvalidArgumentException', reason: 'data parameter is nil'
        id jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
        
        if (jsonDic == nil) {//可能遇到json解析器解析不出来的特殊字符异常
            NSLog(@"JSON Parser Error >>>>>>>>>>>>>>>>>>>>>>>>>>> \n JSON String=%@",json);
        }
        return jsonDic;
    }
    else{//打印数据异常转码信息
        NSLog(@"JSON Data String Error >>>: %@",responseString);
    }
    return nil;
}

+ (id) jsonDataToObject:(id)dataSource {
    if (!dataSource) {
        return nil;
    }
    id  obj = nil;
    if ([dataSource isKindOfClass:[NSString class]] && [dataSource length] > 0) {
        obj = [PADataObject parseJsonData:dataSource];
    }
    else if ([dataSource isKindOfClass:[NSDictionary class]]){
        obj = [dataSource copy];
    }
    else if ([dataSource isKindOfClass:[NSArray class]]) {
        obj = [dataSource copy];
    }
    return obj;
}


@end

