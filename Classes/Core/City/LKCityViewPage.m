//
//  LKCityViewPage.m
//  Luckeys
//
//  Created by lishaowei on 15/11/25.
//  Copyright © 2015年 Luckeys. All rights reserved.
//

#import "LKCityViewPage.h"
#import "LKCityModel.h"
#import "LKCityData.h"

@interface LKCityViewPage () <UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_cityTableView;
    
    LKCityModel *_cityModel;
    
}

@property (nonatomic, assign) NSInteger   selectedRow;

@end

@implementation LKCityViewPage

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self registController:@"LKCityController"];
    }
    return self;
}

//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
//    }
//    
//    self.navigationController.navigationBar.hidden = YES;
//}
//
//- (void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//        //self.navigationController.interactivePopGestureRecognizer.enabled = YES;
//    }
//    self.navigationController.navigationBar.hidden = NO;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"城市";
    
    [self initData];
    [self initView];
    
    [ShowTipsView showLoadHUDWithMSG:nil andView:self.view];
    [self refreshData];
}

- (void)initView
{
    _cityTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, UI_IOS_WINDOW_HEIGHT-64) style:UITableViewStylePlain];
    _cityTableView.separatorColor = [UIColor clearColor];
    _cityTableView.dataSource = self;
    _cityTableView.delegate = self;
    [self.view addSubview:_cityTableView];
    
    [self addRefreshViewToTableView:_cityTableView];
}

- (void)initData
{
    _cityModel = [self.controller getModelFromListByName:@"LKCityModel"];
}

//刷新
- (void)refreshDatasource
{
    [super refreshDatasource];
    
    [self refreshData];
}

- (void)refreshData
{
    [self.controller sendMessageID:kRequstCityListTag messageInfo:@{kRequestUrl:kURL_QueryIosCityPage}];
}

//失败显示
- (void)showPlaceholderView:(NSString *)showText boolWith:(BOOL)isBool
{
    if (isBool)
    {
        self.placeholderInfoView.hidden = NO;
        
        [self showPlaceholderViewState:showText];
        [_cityTableView addSubview:self.placeholderInfoView];
        [self adjustPlaceHolderFrame:NO];
    }
    else
    {
        self.placeholderInfoView.hidden = YES;
    }
}

#pragma mark - UITableViewDelegate、UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _cityModel.infoArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        UIView *lineView=[[UIView alloc] initWithFrame:CGRectMake(BoundsOfScale(15), 55-SINGLE_LINE_ADJUST_OFFSET, UI_IOS_WINDOW_WIDTH-BoundsOfScale(15), SINGLE_LINE_BOUNDS)];
        lineView.backgroundColor = UIColorRGB(0xe9e9e9);
        [cell.contentView addSubview:lineView];
    }
    LKCityData *data = [_cityModel.infoArray objectAtIndex:indexPath.row];
    cell.textLabel.text = data.cityName;
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSString *cityString = [userDef objectForKey:kChangeCityKey];
    
    if (cityString.length <= 0)
    {
        if ([data.cityName isEqualToString:@"深圳"])
        {
            [userDef setValue:data.cityUuid forKey:kChangeCityKey];
            [userDef synchronize];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            self.selectedRow = indexPath.row;
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    else
    {
        if ([data.cityUuid isEqualToString:cityString]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            self.selectedRow = indexPath.row;
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.selectedRow inSection:0]];
    selectedCell.accessoryType = UITableViewCellAccessoryNone;
    
    UITableViewCell *newSelectedCell = [tableView cellForRowAtIndexPath:indexPath];
    self.selectedRow = indexPath.row;
    newSelectedCell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    LKCityData *data = [_cityModel.infoArray objectAtIndex:indexPath.row];

    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSString *cityString = [userDef objectForKey:kChangeCityKey];
    
    if (cityString.length <= 0)
    {
        if ([data.cityName isEqualToString:@"深圳"])
        {
            [userDef setValue:data.cityUuid forKey:kChangeCityKey];
            [userDef synchronize];
            [self popViewPageAnimated:YES];
        }
        
    }
    
    if ([cityString isEqualToString:data.cityUuid])
    {
        [self popViewPageAnimated:YES];
    }
    else
    {
        [userDef setValue:data.cityUuid forKey:kChangeCityKey];
        [userDef synchronize];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotiLKChangeCityNotification object:nil];
    }
    
}

#pragma mark - 数据
- (void)update:(id)data msgID:(int)msgid faildCode:(EDataStatusCode)errCode
{
    [ShowTipsView hideHUDWithView:self.view];
    
    [self stopRefreshData];
    
    if (errCode == eDataCodeSuccess)
    {
        if (_cityModel.infoArray.count <= 0)
        {
            [self showPlaceholderView:@"还没有城市信息哦~" boolWith:YES];
        }
        else
        {
            [self showPlaceholderView:@"" boolWith:NO];
            [_cityTableView reloadData];
        }

    }
    else
    {
        [self showPlaceholderView:@"网络异常获取数据失败" boolWith:YES];
    }
    
}

@end
