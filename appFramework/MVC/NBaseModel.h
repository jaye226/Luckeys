
#import <Foundation/Foundation.h>

typedef enum{
    eDataCodeSuccess = 0,
    eDataCodeFaild = -1,
    eDataCodeTimeOut = -2,
}EDataStatusCode;


@protocol NModelDelegate;

//数据模型基类
@interface NBaseModel : NSObject
{
    
}
@property (nonatomic,weak) id<NModelDelegate> delegate;

/**
 *  处理数据接口，数据可能来自网络，也可能来自本地
 *  由子类实现具体数据处理
 *
 *  @param dataSource 数据源
 *  @param msgID    消息ID
 */
-(void)handleSucessData:(id)dataSource messageID:(int)msgID;

/**
 *  处理错误数据
 *
 *  @param code 错误消息值
 *  @param errorMsg 错误消息
 *  @param msgID    消息ID
 */
-(void)handleError:(NSString*)errorMsg errCode:(int)code messageID:(int)msgID;

/**
 *  数据处理完成且有更新时需要显示调用,用来更新视图
 *
 *  @param data  数据对象 1.如果数据读取成功,代表数据对象模型;2.如果数据读取失败,代表错误信息
 *  @param msgid 消息命令ID
 *  @param code 错误码,成功传 0
 */
- (void)update:(id)data msgID:(int)msgid errCode:(int)code;

@end


//数据模型的delegate
@protocol NModelDelegate <NSObject>
@required

/**
 *  数据更新接口
 *
 *  @param data   1.如果数据读取成功,代表数据对象模型;2.如果数据读取失败，代表错误信息
 *  @param msgid  消息命令ID
 *  @param errCode 错误代码值,0代表成功,see the enum EDataStatusCode
 *  @param error  错误信息,如果没有错误，可以返回空
 */
- (void)update:(id)data msgID:(int)msgid faildCode:(EDataStatusCode)errCode;

@end