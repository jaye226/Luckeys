/*************************************************
 框架控制器类
 
 1. 用于控制UI页面和数据模型分离,控制页面和数据的流程
 2. 在BasePage初始化过程中,要把UIBaseViewPage类里的成员变量 _controller 初始化出来
    方便在UIBaseViewPage 子类内部，随时可以访问 controller属性来控制页面和数据的流向
    eg: XXBasePage *page = [XXBasePage alloc] init];
        -(id)init
        {
            [self registController:@"XXXController"];
        }
 ************************************************/


#import <UIKit/UIKit.h>

@class UIBaseViewPage;
@class NBaseModel;

//控制器基类
@interface NBaseController : NSObject
{
 
}

@property (nonatomic,weak) UIBaseViewPage*       page;
@property (nonatomic,strong) NSMutableArray*       modelList;

/**
 *  控制器绑定UI View引用对象,把controller和view 关联起来
 *
 *  @param: m_page  UIBaseViewPage基类
 *
 *  @return 返回控制器
 */
- (id)initWithPage:(UIBaseViewPage*)m_page;

//由子类实现,初始化控制类,如注册Model等,父类实现为空
-(void)initController;

/**
 *  注册在控制器的 Data Model
 *
 *  @param model 数据Model模型
 */
- (void)registerModel:(NBaseModel*)model;

/**
 *  从控制器里移除关联的数据Model
 *
 *  @param modelList 要取消和控制器关联的 数据Model
 */
- (void)unregisterModel:(NBaseModel*)model;

/**
 *  通过类名从控制器里获取数据Model
 *
 *  @param name   数据Model名字
 *
 *  @return 返回找到 数据Model
 */
- (id)getModelFromListByName:(NSString*)name;


/**
 * 向控制器发送消息,由具体子类实现自定义消息处理,父类实现为NULL
 *
 *  @param msgID    消息ID
 *  @param msgInfo  要发送的消息内容,可传NULL
 */

-(void)sendMessageID:(int)msgID messageInfo:(id)msgInfo;


@end
