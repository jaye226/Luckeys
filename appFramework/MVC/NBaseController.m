
#import "NBaseController.h"
#import "UIBaseViewPage.h"
#import "NBaseModel.h"

@interface NBaseController()

@end


@implementation NBaseController

- (void)dealloc
{
    //防止,controller 被释放时,BaseModel.delegate为野指针而调用造成crash
    for(NBaseModel *model in _modelList)
    {
        if (model.delegate == self)
        {
            model.delegate = nil;
        }
    }
    _page = nil;
    _modelList = nil;
}

- (id)init
{
    self = [super init];
    if (self) 
    {
        _page = nil;
        _modelList = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (id)initWithPage:(UIBaseViewPage*)m_page
{
    self = [self init];
    if(self){
        self.page = m_page;
        [self initController];
    }
    return self;
}

-(void)initController
{
    //由子类实现,初始化控制类,
}

- (void)registerModel:(NBaseModel*)model
{
    if (model)
    {
        model.delegate = self.page;
        [_modelList addObject:model];
    }
}

- (void)unregisterModel:(NBaseModel*)model;
{
    if (model) 
    {
        if (model.delegate == self) {
            model.delegate = nil;
        }
        
        [_modelList removeObject:model];
    }
}

- (id)getModelFromListByName:(NSString*)name
{
    if (name ==nil || [name isEqualToString:@""]) {
        nil;
    }
    for (id mode in _modelList)
    {
        NSString* className = NSStringFromClass([mode class]);
        
        if ([className isEqualToString:name]) {
            return mode;
        };
    }
    return nil;
}

-(void)sendMessageID:(int)msgID messageInfo:(id)msgInfo
{
   //子类覆盖实现
}

@end

