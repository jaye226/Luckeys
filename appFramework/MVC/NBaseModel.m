 
#import "NBaseModel.h"

@implementation NBaseModel

@synthesize delegate = _delegate;

-(void)handleSucessData:(id)dataSource messageID:(int)msgID
{
    //由子类实现
}

-(void)handleError:(NSString*)errorMsg errCode:(int)code messageID:(int)msgID
{
    [self update:errorMsg msgID:msgID errCode:code];
}


- (void)update:(id)data msgID:(int)msgid errCode:(int)code
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(update:msgID:faildCode:)])
    {
        [self.delegate update:data msgID:msgid faildCode:code];
    }
    else
    {
        NSLog(@"-->error message:%@, error Code:%d",data,code);
    }
}

@end
