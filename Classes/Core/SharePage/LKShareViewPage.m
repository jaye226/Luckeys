//
//  LKShareViewPage.m
//  Luckeys
//
//  Created by BearLi on 15/9/26.
//  Copyright © 2015年 Luckeys. All rights reserved.
//

#import "LKShareViewPage.h"
#import "LKTypeListTableViewCell.h"
#import "LKShareHeadView.h"
#import "LKShareOthersCell.h"
#import "LKShareCellDelegate.h"
#import "LKNavigationController.h"
#import "LKShareMsgModel.h"
#import "KKCommentView.h"

@interface LKShareViewPage () <UITableViewDataSource, UITableViewDelegate, LKTypeListTableViewCellDelegate, LKShareCellDelegate,LKShareHeadViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,KKCommentViewDelegate>
{
    UIScrollView *_bottomScrollView;
    UITableView *_shareTableView;
    UITableView *_collectionTableView;
    NSInteger _type;
    LKShareMsgModel * _msgModel;
    
    LKShareHeadView *_shareHeadView;
    LKLoadMoreCell *_shareMoreCell;
    LKLoadMoreCell *_collectionMoreCell;
    UIView *_commentBJView;
    KKCommentView *_commentView;
    
    LKFriendsData *_selectData;
    NSString *_commentStr;
}

@end

@implementation LKShareViewPage

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //[self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //[self.navigationController setNavigationBarHidden:NO animated:NO];
    
    _commentBJView.hidden = YES;
    [_commentView hiddenKeyboard];

}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self registController:@"LKShareMsgController"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self hiddenNavgationView];
    
    [self initData];
    [self addView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateNotiChangeHeadImage) name:kNotiChangeHeadImage object:nil];
}

- (void)initData
{
    _msgModel = [self.controller getModelFromListByName:@"LKShareMsgModel"];
}

- (void)addView
{
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UI_IOS_WINDOW_WIDTH, 20)];
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    
    for (int i = 0; i < 2; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake((UI_IOS_WINDOW_WIDTH/2)*i, 20, UI_IOS_WINDOW_WIDTH/2, BoundsOfScale(40));
        [button setBackgroundImage:[UIColor createImageWithColor:UIColorRGB(0xe9e9e9)] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIColor createImageWithColor:UIColorMakeRGB(247.0, 83.0, 71.0)] forState:UIControlStateSelected];
        [button setBackgroundImage:[UIColor createImageWithColor:UIColorMakeRGB(247.0, 83.0, 71.0)] forState:UIControlStateHighlighted];
        [button setTitleColor:UIColorMakeRGB(102.0, 102.0, 102.0) forState:UIControlStateNormal];
        [button setTitleColor:UIColorMakeRGB(255.0, 255.0, 255.0) forState:UIControlStateSelected];
        button.titleLabel.font = [UIFont systemFontOfSize:FontOfScale(14)];
        if (i == 0) {
            [button setTitle:@"分享" forState:UIControlStateNormal];
            button.selected = YES;
            button.userInteractionEnabled = NO;
            _type = 0;
        }else{
            [button setTitle:@"收藏" forState:UIControlStateNormal];
        }
        button.tag = i+1000;
        [self.view addSubview:button];
        [button addTarget:self action:@selector(selectTypeInside:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    _bottomScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 20+BoundsOfScale(40), UI_IOS_WINDOW_WIDTH, UI_IOS_WINDOW_HEIGHT-20-BoundsOfScale(40)-kTabBarHeight)];
    _bottomScrollView.bounces = NO;
    _bottomScrollView.contentSize = CGSizeMake(UI_IOS_WINDOW_WIDTH*2, _bottomScrollView.height);
    _bottomScrollView.scrollEnabled = NO;
    [self.view addSubview:_bottomScrollView];
    
    _shareTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, _bottomScrollView.width, _bottomScrollView.height) style:UITableViewStylePlain];
    _shareTableView.backgroundColor = [UIColor clearColor];
    _shareTableView.delegate = self;
    _shareTableView.dataSource = self;
    _shareTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_bottomScrollView addSubview:_shareTableView];
    
    [self addRefreshViewToTableView:_shareTableView];
    
    _collectionTableView = [[UITableView alloc] initWithFrame:CGRectMake(_bottomScrollView.width, 0, _bottomScrollView.width, _bottomScrollView.height) style:UITableViewStylePlain];
    _collectionTableView.backgroundColor = [UIColor clearColor];
    _collectionTableView.delegate = self;
    _collectionTableView.dataSource = self;
    _collectionTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_bottomScrollView addSubview:_collectionTableView];
    
    
    _commentBJView = [[UIView alloc] initWithFrame:self.view.bounds];
    _commentBJView.backgroundColor = [UIColor clearColor];
    _commentBJView.hidden = YES;
    [self.view addSubview:_commentBJView];
    _commentBJView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentBJTapGestureHeadInside)];
    [_commentBJView addGestureRecognizer:tapGesture];
    
    _commentView = [[KKCommentView alloc] initWithFrame:CGRectMake(0, UI_IOS_WINDOW_HEIGHT, UI_IOS_WINDOW_WIDTH, BoundsOfScale(40))];
    _commentView.viewHeight = BoundsOfScale(40);
    _commentView.delegate = self;
    [_commentBJView addSubview:_commentView];
    
    [ShowTipsView showLoadHUDWithMSG:nil andView:self.view];
    [self refreshRequestQuerySharePage];
}

- (void)commentBJTapGestureHeadInside
{
    _commentBJView.hidden = YES;
    [_commentView hiddenKeyboard];
}

- (void)showPlaceholderView:(NSString *)showText boolWith:(BOOL)isBool
{
    if (isBool)
    {
        self.placeholderInfoView.hidden = NO;
        [self showPlaceholderViewState:showText];
        [_collectionTableView addSubview:self.placeholderInfoView];
        [self adjustPlaceHolderFrame:NO];
    }
    else
    {
        self.placeholderInfoView.hidden = YES;
    }
}

- (void)refreshDatasource {
    [super refreshDatasource];
    if (_type == 0) {
        _msgModel.shareNextPage = 1;
        [self refreshRequestQuerySharePage];
    }else{
        _msgModel.collectionNextPage = 1;
        [self refreshRequestData];
    }
}

//朋友圈刷新
- (void)refreshRequestQuerySharePage
{
    id body = @{kLKCurPage:@"1",
                @"pageSize":kLKPageSize};
    [self.controller sendMessageID:kQuerySharePageRefshTag messageInfo:@{kRequestUrl:kUrl_QuerySharePage,kRequestBody:body}];
}

- (void)requsetMoreQueryShare{
    id body =  @{kLKCurPage:[NSString stringWithFormat:@"%ld", (long)_msgModel.shareNextPage],
                 @"pageSize":kLKPageSize};
    [self.controller sendMessageID:kQueryShareMoreRefshTag messageInfo:@{kRequestUrl:kUrl_QuerySharePage,kRequestBody:body}];
}

//收藏刷新
- (void)refreshRequestData
{
    id body = @{kLKCurPage:@"1",
                @"pageSize":kLKPageSize};
    [self.controller sendMessageID:kCollectionRefshTag messageInfo:@{kRequestUrl:kURL_CollectionList,kRequestBody:body}];
}

- (void)requsetMoreCollection {
    id body = @{kLKCurPage:[NSString stringWithFormat:@"%ld", (long)_msgModel.collectionNextPage],
                @"pageSize":kLKPageSize};
    [self.controller sendMessageID:kCollectionTag messageInfo:@{kRequestUrl:kURL_CollectionList,kRequestBody:body}];
}

- (void)selectTypeInside:(UIButton *)button
{
    _type = button.tag-1000;
    button.selected = YES;
    button.userInteractionEnabled = NO;
    if (button.tag == 1000) {
        
        [self addRefreshViewToTableView:_shareTableView];
        
        UIButton *btn = (UIButton *)[self.view viewWithTag:1001];
        btn.selected = NO;
        btn.userInteractionEnabled = YES;
        [_bottomScrollView setContentOffset:CGPointMake(0, 0) animated:NO];
        if (_msgModel.shareArray.count == 0) {
            [ShowTipsView showLoadHUDWithMSG:nil andView:self.view];
            [self refreshRequestQuerySharePage];
        }
    }else{
        
        [self addRefreshViewToTableView:_collectionTableView];
        
        UIButton *btn = (UIButton *)[self.view viewWithTag:1000];
        btn.selected = NO;
        btn.userInteractionEnabled = YES;
        [_bottomScrollView setContentOffset:CGPointMake(_bottomScrollView.width, 0) animated:NO];
        if (_msgModel.collectionArray.count == 0) {
            [ShowTipsView showLoadHUDWithMSG:@"" andView:self.view];
            [self refreshRequestData];
        }
    }
}

- (void)updateNotiChangeHeadImage
{
    [_shareHeadView updateShareHeadeView];
}

#pragma mark - KKCommentViewDelegate
//评论发送
- (void)sendChange:(NSString *)sendString
{
    _commentBJView.hidden = YES;
    //    去除两端空格
    NSString *temp = [sendString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    //    去除两端空格和回车
    NSString *result = [temp stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if([result isEqualToString:@""] || result == nil)
    {
        [ShowTipsView showHUDWithMessage:@"评论内容不能为空" andView:self.view];
        return;
    }
    _commentStr = sendString;
    [ShowTipsView showLoadHUDWithMSG:nil andView:self.view];
    
    NSDictionary * body = @{@"activityUuid":_selectData.activityUuid,@"userUuid":[LKShareUserInfo share].userInfo.userUuid,@"description":result};
    [self.controller sendMessageID:kRequstCommentTag messageInfo:@{kRequestUrl:kURL_AddComment, kRequestBody:body}];
}

#pragma mark - LKShareHeadViewDelegate
/**
 *  点击头像
 */
- (void)changeHeadImage
{
    [self pushPageWithName:@"LKMyTabViewPage" withParams:@{@"uuid":STR_IS_NULL([[LKShareUserInfo share] userInfo].userUuid)}];
}

/**
 *  点击背景
 */
- (void)changeBackgroundImage
{
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@"请选择"
                                                        delegate:self
                                               cancelButtonTitle:@"取消"
                                          destructiveButtonTitle:nil
                                               otherButtonTitles:@"相册",@"拍照", nil];
    action.actionSheetStyle = UIActionSheetStyleDefault;
    [action showInView:self.view.superview];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        UIImagePickerController *picker =[[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.allowsEditing = YES;
        [picker.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
        picker.navigationBar.tintColor = [UIColor blackColor];
        [self presentViewController:picker animated:YES completion:nil];
    }
    else if (buttonIndex == 1)
    {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            /*if ([[AVCaptureDevice class] respondsToSelector:@selector(authorizationStatusForMediaType:)]) {
             AVAuthorizationStatus authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
             if (authorizationStatus == AVAuthorizationStatusRestricted
             || authorizationStatus == AVAuthorizationStatusDenied) {
             
             // 没有权限
             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
             message:@"请在iPhone的“设置-隐私-相机”选项中，允许Luckeys访问你的相机。"
             delegate:nil
             cancelButtonTitle:@"确定"
             otherButtonTitles:nil];
             [alertView show];
             return;
             }
             }*/
            
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:picker animated:YES completion:nil];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Error accessing photo library"
                                  message:@"Device does not support a photo library"
                                  delegate:nil
                                  cancelButtonTitle:@"ok!"
                                  otherButtonTitles:nil];
            [alert show];
        }
    }
    else if (buttonIndex == 2)
    {
        [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
    }
}

#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    UIImage* oralImg=[info objectForKey:UIImagePickerControllerEditedImage];
    
    //    double image_w = oralImg.size.width;
    //    double image_h = oralImg.size.height;
    //
    //    if (image_h > 110)
    //    {
    //        image_h = 110;
    //    }
    //
    //    if (image_w > 100)
    //    {
    //        image_w = 110;
    //    }
    //
    //    oralImg = [self scaleFromImage:oralImg toSize:CGSizeMake(image_w, image_h)];
    
    [self commitHeadImage:oralImg];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

- (UIImage *) scaleFromImage: (UIImage *) image toSize: (CGSize) size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

//提交图片
- (void)commitHeadImage:(UIImage*)headImage
{
    NSString *url=[NSString stringWithFormat:@"%@%@%@",HeadHost,SeverHost,kURL_UploadPhoto];
    [[MLHttpRequestManager sharedMLHttpRequestManager] uploadRequestWithTag:100 URLString:url requestType:Request_UpBackImage uploadData:headImage Finished:^(Result_TYPE success, int requestTag, id callbackData) {
        if (success == Result_Success) {
            NSDictionary *dict = [PADataObject jsonDataToObject:callbackData];
            if (dict && [[dict objectForKey:@"code"] intValue] == 1) {
                NSDictionary * body = [dict objectForKey:@"body"];
                if (body.allKeys.count) {
                    NSString *imageUrl = [body objectForKey:@"backImage"];
                    [[LKShareUserInfo share] userInfo].backImage = imageUrl;
                    [_shareHeadView updateShareHeadeView];
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNotiChangeBackImage object:nil];
                }
            }else{
                [ShowTipsView showHUDWithMessage:@"上传背景图片失败" andView:self.view];
                
            }
        }
        else if (success == Result_TimeOut || success == Result_Fail)
        {
            [ShowTipsView showHUDWithMessage:@"上传背景图片失败" andView:self.view];
        }
    }];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _collectionTableView)
    {
        if (_msgModel.collectionNextPage > 0) {
            return _msgModel.collectionArray.count+1;
        }
        return _msgModel.collectionArray.count;
    }else
    {
        if (_msgModel.shareNextPage > 0) {
            return _msgModel.shareArray.count+1;
        }
        return _msgModel.shareArray.count;
    }
   
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _shareTableView) {
        if (_msgModel.shareNextPage > 0 && indexPath.row == _msgModel.shareArray.count)
        {
            static NSString * cellId = @"ShareMoreCellId";
            if (_shareMoreCell == nil)
            {
                _shareMoreCell = [[LKLoadMoreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
                _shareMoreCell.contentView.backgroundColor = [UIColor clearColor];
                _shareMoreCell.backgroundColor = [UIColor clearColor];
            }
            [self requsetMoreQueryShare];
            return _shareMoreCell;
        }
        static NSString * cellId = @"ShareCellId";
        LKShareOthersCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[LKShareOthersCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
        }
        [cell updateCell:[_msgModel.shareArray objectAtIndex:indexPath.row]];
        return cell;
    }else{
        if (_msgModel.collectionNextPage > 0 && indexPath.row == _msgModel.collectionArray.count)
        {
            static NSString * cellId = @"CollectionMoreCellId";
            if (_collectionMoreCell == nil)
            {
                _collectionMoreCell = [[LKLoadMoreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
                _collectionMoreCell.contentView.backgroundColor = [UIColor clearColor];
                _collectionMoreCell.backgroundColor = [UIColor clearColor];
            }
            [self requsetMoreCollection];
            return _collectionMoreCell;
        }
        
        static NSString * cellId = @"TypeListCellId";
        LKTypeListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[LKTypeListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.likeImage.tag = 9999+indexPath.row;
        cell.typeButton.tag = indexPath.row;
        cell.delegate = self;
        cell.typeData = _msgModel.collectionArray[indexPath.row];
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _shareTableView)
    {
        if (_msgModel.shareNextPage > 0 && indexPath.row == _msgModel.shareArray.count)
        {
            return [LKLoadMoreCell getCellHeight];
        }
        return [LKShareOthersCell getCellHeight:[_msgModel.shareArray objectAtIndex:indexPath.row]];
    }else{
        if (_msgModel.collectionNextPage > 0 && indexPath.row == _msgModel.collectionArray.count)
        {
            return [LKLoadMoreCell getCellHeight];
        }
        return kTypeListCellHeight;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _collectionTableView)
    {
        if (_msgModel.collectionNextPage > 0 && indexPath.row == _msgModel.collectionArray.count)
        {
            [_collectionMoreCell startLoadMore];
            [self requsetMoreCollection];
        }else{
            LKTypeData *data = [_msgModel.collectionArray objectAtIndex:indexPath.row];
            [self pushPageWithName:@"LKDetailsViewPage" animation:YES withParams:@{@"activityUuid":STR_IS_NULL(data.activityUuid),@"title":STR_IS_NULL(data.activityName)}];
        }
    }else
    {
        if (_msgModel.shareNextPage > 0 && indexPath.row == _msgModel.shareArray.count)
        {
            [_shareMoreCell startLoadMore];
            [self requsetMoreQueryShare];
        }
    }
}

#pragma mark - LKShareCellDelegate
- (void)changeShareCellWithBtn:(ChangeShareType)type withData:(LKFriendsData *)data
{
    _selectData = data;
    switch (type) {
        case SHARE_LIKEBTN:
        {
            
            NSDictionary * body = @{@"codeUuid":data.codeUuid};//,@"userUuid":[LKShareUserInfo share].userInfo.userUuid
            [self.controller sendMessageID:kWinUserBtn messageInfo:@{kRequestUrl:kURL_PraiseWin, kRequestBody:body}];
            
           break;
        }
        case SHARE_COMMENTBTN:
        {
            _commentBJView.hidden = NO;
            [_commentView.commentTextField becomeFirstResponder];
            break;
        }
        case SHARE_HEADIMAGE:
        {
            [self pushPageWithName:@"LKMyTabViewPage" withParams:@{@"uuid":STR_IS_NULL(data.userUuid)}];
            break;
        }
        case SHARE_DITY:
        {
            [self pushPageWithName:@"LKDetailsViewPage" animation:YES withParams:@{@"activityUuid":STR_IS_NULL(data.activityUuid),@"title":STR_IS_NULL(data.activityName)}];
            break;
        }
        default:
            break;
    }
}
/**
 *  点击图片
 *
 *  @param array
 *  @param index
 */
- (void)changeArrayImageViewWith:(NSArray *)array selectWith:(NSInteger)index
{
    
}

#pragma mark - LKTypeListTableViewCellDelegate
//喜欢按钮点击回调
- (void)likeButtonClick:(UIButton *)button
{
    NSInteger index = button.tag - 9999;
    if (index < 0 || index >= _msgModel.collectionArray.count) {
        return;
    }
    
    LKTypeData * data = _msgModel.collectionArray[index];
    NSString * iLike = @"";
    if ([data.iLike boolValue] == YES) {
        iLike = @"1";
    }
    else
    {
        iLike = @"0";
    }
    id body = @{@"activityUuid":STR_IS_NULL(data.activityUuid),@"iLike":iLike};
    [self.controller sendMessageID:kLikeTag messageInfo:@{kRequestUrl:kURL_CollectionActivity,kRequestBody:body}];
}

//分类按钮点击回调
- (void)typeButtonClick:(UIButton*)button
{
    if (button.tag >= _msgModel.collectionArray.count) {
        [self pushPageWithName:@"LKTypeListViewPage" withParams:nil];
    }
    else {
        LKTypeData * data = _msgModel.collectionArray[button.tag];
        [self pushPageWithName:@"LKTypeListViewPage" withParams:@{@"uuid":STR_IS_NULL(data.activityTypeUuid),@"title":STR_IS_NULL(data.activityTypeName)}];
    }
}

- (void)update:(id)data msgID:(int)msgid faildCode:(EDataStatusCode)errCode {
    
    [ShowTipsView hideHUDWithView:self.view];
    [self stopRefreshData];

    if (errCode == eDataCodeSuccess)
    {
        if (msgid == kQuerySharePageRefshTag)
        {
            if (_msgModel.shareArray.count <= 0) {
                [self showPlaceholderView:@"还没有分享哦，快去分享吧^_^" boolWith:YES];
            }else{
                [self showPlaceholderView:nil boolWith:NO];
                if (_shareHeadView == nil) {
                    _shareHeadView = [[LKShareHeadView alloc] init];
                    _shareHeadView.delegate = self;
                    _shareTableView.tableHeaderView = _shareHeadView;
                }
            }
            [_shareTableView reloadData];
        }
        else if (msgid == kQueryShareMoreRefshTag)
        {
            [_shareTableView reloadData];
        }
        else if (msgid == kCollectionTag)
        {
            [_collectionTableView reloadData];

        }
        else if (msgid == kLikeTag)
        {
            [_collectionTableView reloadData];
        }
        else if (msgid == kCollectionRefshTag)
        {
            if (_msgModel.collectionArray.count <= 0) {
                [self showPlaceholderView:@"你还没有收藏哦，赶快去收藏吧^_^" boolWith:YES];
            }else{
                [self showPlaceholderView:nil boolWith:NO];
            }
            [_collectionTableView reloadData];
        }
        else if (msgid == kRequstCommentTag)//评论
        {
            if ([_msgModel.shareArray containsObject:_selectData])
            {
                NSDictionary *dic = @{@"nickName":[LKShareUserInfo share].userInfo.nickName,@"descri":_commentStr};
                NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:_selectData.listComment];
                [arr addObject:dic];
                _selectData.listComment = [NSArray arrayWithArray:arr];
                [_shareTableView reloadData];
            }
        }else if (msgid == kWinUserBtn)
        {
            if ([_msgModel.shareArray containsObject:_selectData])
            {
                _selectData.isWin = @"1";
                [_shareTableView reloadData];
            }
        }
    }
    else
    {
        if (msgid == kQuerySharePageRefshTag)
        {
            if (_msgModel.shareArray.count <= 0)
            {
                [self showPlaceholderView:@"网络异常获取数据失败" boolWith:YES];
            }
        }
        else if (msgid == kCollectionRefshTag)
        {
            if (_msgModel.collectionArray.count <= 0)
            {
                [self showPlaceholderView:@"网络异常获取数据失败" boolWith:YES];
            }
        }
        else if (msgid == kCollectionTag)
        {
            [_collectionMoreCell stopLoadMore];
        }
        else if (msgid == kQueryShareMoreRefshTag)
        {
            [_shareMoreCell stopLoadMore];
        }else if (msgid == kWinUserBtn)
        {
            [self showPlaceholderView:@"点赞失败" boolWith:YES];
        }
        else
        {
            [ShowTipsView showHUDWithMessage:kRequest_TimeOut andView:self.view];
        }
    }

}

@end
