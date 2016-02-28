//
//  LKShareCmmentViewPage.m
//  Luckeys
//
//  Created by lishaowei on 15/10/17.
//  Copyright © 2015年 Luckeys. All rights reserved.
//

#import "LKShareCmmentViewPage.h"
#import "DoImagePickerController.h"
#import "AssetHelper.h"

#define kImageViewWith (UI_IOS_WINDOW_WIDTH-BoundsOfScale(15)*2-BoundsOfScale(10)*3)/4


@interface LKShareCmmentViewPage () <UITextViewDelegate, DoImagePickerControllerDelegate>
{
    UIView *_bjView;
    UITextView *_textView;
    UIImageView *_defImageView;
    
    UIButton *_addImageBtn;
    
    NSMutableArray *_selectdArray;
    
    NSString *_activityUuid;
}

@end

@implementation LKShareCmmentViewPage

- (void)dealloc
{
    
}

-(id)init
{
    if (self = [super init]){
        //[self registController:@"LKShareCmmentController"];//注册控制器
    }
    return self;
}

- (void)initWithParam:(NSDictionary *)paramInfo
{
    if (paramInfo.allKeys.count) {
        _activityUuid = paramInfo[@"activityUuid"];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationView addRightButtonTitleWith:@"分享" titleColorWith:UIColorRGB(0xff4f4f) selectdColorWith:UIColorRGB(0xff4f4f) fontWith:[UIFont systemFontOfSize:15]];
    
    [self.view setBackgroundColor:UIColorRGB(0xf1f1f1)];

    _selectdArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    [self addView];
}

- (void)changeNavRightBtnInside
{
    NSMutableArray *selectArray = [[NSMutableArray alloc] initWithCapacity:0];
    for (id object in _selectdArray) {
        UIImage *image = [ASSETHELPER getImageFromAsset:object type:ASSET_PHOTO_THUMBNAIL];
        NSData *data = [UIImage UIImageExchangeToNSData:image];
        [selectArray addObject:data];
    }
    
    NSDictionary *dic = @{@"activityUuid":_activityUuid,@"userUuid":[[LKShareUserInfo share] userInfo].userUuid,@"comment":_textView.text,@"imageArray":selectArray};
    
    NSString *url=[NSString stringWithFormat:@"%@%@/%@",HeadHost,SeverHost,kURL_ShareActivity];
    [[MLHttpRequestManager sharedMLHttpRequestManager] uploadRequestWithTag:100 URLString:url requestType:Request_Upload uploadData:dic Finished:^(Result_TYPE success, int requestTag, id callbackData) {
        if (success == Result_Success) {
            NSDictionary *dict = [PADataObject jsonDataToObject:callbackData];
            if (dict && [[dict objectForKey:@"code"] intValue] == 1) {
                [ShowTipsView showHUDWithMessage:@"分享成功" andView:kUIWindow];
                [self popViewPageAnimated:YES];
            }else{
                [ShowTipsView showHUDWithMessage:@"网络异常分享失败" andView:self.view];
                
            }
        }
        else if (success == Result_TimeOut || success == Result_Fail)
        {
            [ShowTipsView showHUDWithMessage:@"网络异常分享失败" andView:self.view];
        }
    }];
}

- (void)backViewPage
{
    [self popViewPageAnimated:YES];
}

- (void)addView
{
    _bjView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UI_IOS_WINDOW_WIDTH, BoundsOfScale(190))];
    _bjView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bjView];
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(BoundsOfScale(18), 64, UI_IOS_WINDOW_WIDTH-BoundsOfScale(18)*2, BoundsOfScale(95))];
    _textView.delegate = self;       //设置代理方法的实现类
    _textView.font=[UIFont systemFontOfSize:FontOfScale(14)]; //设置字体名字和字体大小;
    _textView.tag = 0;
    _textView.text = @"这一刻的想法...";
    _textView.textColor = [UIColor grayColor];
    _textView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [self.view addSubview:_textView];
    
    _addImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _addImageBtn.frame = CGRectMake(BoundsOfScale(15), _textView.maxY+BoundsOfScale(10), kImageViewWith, kImageViewWith);
    [_addImageBtn setBackgroundImage:[UIImage imageNamed:@"ic_share_add_image"] forState:UIControlStateNormal];
    [self.view addSubview:_addImageBtn];
    [_addImageBtn addTarget:self action:@selector(addImageTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
    
    _bjView.height = _addImageBtn.maxY+BoundsOfScale(10);
}

- (void)addImageTouchUpInside
{
    
    DoImagePickerController *cont = [[DoImagePickerController alloc] initWithNibName:@"DoImagePickerController" bundle:nil];
    cont.delegate = self;
    cont.nMaxCount = 3;
    cont.nResultType = DO_PICKER_RESULT_ASSET;  // if you want to get lots photos, you'd better use this mode for memory!!!
    cont.nColumnCount = 4;
    
    [self presentViewController:cont animated:NO completion:nil];
}

- (void)showSelectdImage
{
    NSInteger count = _selectdArray.count;
    if (count <= 0)
    {
        return;
    }
    
    for (NSInteger i = 0; i < count; i++)
    {
        UIImageView *view = (UIImageView *)[self.view viewWithTag:100001+i];
        if (view) {
            view.image = [ASSETHELPER getImageFromAsset:_selectdArray[i] type:ASSET_PHOTO_THUMBNAIL];
            _addImageBtn.x = view.maxX + BoundsOfScale(10);
        }else{
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(BoundsOfScale(15)+BoundsOfScale(10)*i + kImageViewWith*i, _addImageBtn.y, kImageViewWith, kImageViewWith)];
            imageView.tag = 100001+i;
            imageView.image = [ASSETHELPER getImageFromAsset:_selectdArray[i] type:ASSET_PHOTO_THUMBNAIL];
            [self.view addSubview:imageView];
            _addImageBtn.x = imageView.maxX + BoundsOfScale(10);
        }
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UITextFieldDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if(textView.tag == 0) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
        textView.tag = 1;
    }
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView
{
    if([textView.text length] == 0)
    {
        textView.text = @"这一刻的想法...";
        textView.textColor = [UIColor grayColor];
        textView.tag = 0;
    }else{
        textView.textColor = [UIColor blackColor];
    }
}
#pragma mark - DoImagePickerControllerDelegate
- (void)didCancelDoImagePickerController
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)didSelectPhotosFromDoImagePickerController:(DoImagePickerController *)picker result:(NSArray *)aSelected
{
    [self dismissViewControllerAnimated:NO completion:nil];
    
    if (aSelected.count > 0) {
        [_selectdArray removeAllObjects];
    }
    [_selectdArray addObjectsFromArray:aSelected];
    [self showSelectdImage];
}

@end
