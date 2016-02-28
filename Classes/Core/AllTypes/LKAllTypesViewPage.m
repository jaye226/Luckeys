//
//  LKAllTypesViewPage.m
//  Luckeys
//
//  Created by BearLi on 15/9/26.
//  Copyright © 2015年 Luckeys. All rights reserved.
//

#import "LKAllTypesViewPage.h"
#import "LKAllTypesTableViewCell.h"
#import "LKTypeListViewPage.h"

@interface LKAllTypesViewPage ()<UITableViewDataSource,UITableViewDelegate>
{
    PBTableView * _tableView;
    NSArray * _typesArray;
    NSArray * _defaultArray;
    NSArray *_imageArray;
    NSArray * _defaultImageArray;
}
@end

@implementation LKAllTypesViewPage

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorMakeRGB(233, 233, 233);
    
    [self hiddenNavgationView];
    
    [self initData];
    [self createView];
}

- (void)initData
{
    _typesArray = @[@"电影",@"美食",@"活动",@"书籍",@"其他"];
    _defaultArray = @[@"进度",@"热度",@"最新",@"数额"];
    _imageArray = @[[UIImage imageNamed:@"type_menu_movie"],[UIImage imageNamed:@"type_menu_food"],[UIImage imageNamed:@"type_menu_atvit"],[UIImage imageNamed:@"type_menu_book"],[UIImage imageNamed:@"type_menu_shop"]];
    _defaultImageArray = @[[UIImage imageNamed:@"type_menu_up"],[UIImage imageNamed:@"type_menu_hot"],[UIImage imageNamed:@"type_menu_time"],[UIImage imageNamed:@"type_menu_prize"]];
    
}

- (void)createView
{
    _tableView = [[PBTableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    _tableView.y += 10;
    _tableView.height -= 10;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return _typesArray.count;
    }
    else
    {
        return _defaultArray.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString * headId = @"allTypeHeadId";
    UITableViewHeaderFooterView * view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headId];
    if (!view) {
        view = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:headId];
        view.frame = CGRectMake(0, 0, CGRectGetWidth(tableView.bounds), 50);
        view.contentView.backgroundColor = self.view.backgroundColor;
        
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(kAllTypesStartX, 0, 200, view.height)];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor redColor];
        label.tag = section + 1000;
        [view.contentView addSubview:label];
    }
    UILabel * label = (UILabel*)[view viewWithTag:section+1000];
    if (label) {
        label.text = section == 0 ? @"全部分类":@"默认";
    }
    return view;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellId = @"AllTypeCellId";
    LKAllTypesTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[LKAllTypesTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        [cell createView];
    }
    if (indexPath.section == 0) {
        [cell setImage:_imageArray[indexPath.row] withTitle:_typesArray[indexPath.row]];
    }
    else
    {
        [cell setImage:_defaultImageArray[indexPath.row] withTitle:_defaultArray[indexPath.row]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [kShareSlider hiddenController];
    UIPATabBarController * tab = (UIPATabBarController*)kShareSlider.mainController;
    
    NSInteger index = tab.selectedIndex;
    if (tab.viewControllers.count > index) {
        LKNavigationController * nav = tab.viewControllers[index];
        if (nav) {
            NSInteger  type = indexPath.section == 0 ? indexPath.row+1: indexPath.row+1+_typesArray.count;
            
            LKTypeListViewPage * vc = [[LKTypeListViewPage alloc] init];
            vc.activeUuid = [NSString stringWithFormat:@"%ld",type];
            if (indexPath.section == 0) {
                switch (indexPath.row) {
                    case 0:
                    {
                        vc.typeName = @"电影";
                        break;
                    }
                    case 1:
                    {
                        vc.typeName = @"美食";
                        break;
                    }
                    case 2:
                    {
                        vc.typeName = @"活动";
                        break;
                    }
                    case 3:
                    {
                        vc.typeName = @"书籍";
                        break;
                    }
                    case 4:
                    {
                        vc.typeName = @"其他";
                        break;
                    }
                    default:
                        break;
                }
            }else{
                switch (indexPath.row) {
                    case 0:
                    {
                        vc.typeName = @"进度";
                        break;
                    }
                    case 1:
                    {
                        vc.typeName = @"热度";
                        break;
                    }
                    case 2:
                    {
                        vc.typeName = @"最新";
                        break;
                    }
                    case 3:
                    {
                        vc.typeName = @"数额";
                        break;
                    }
    
                    default:
                        break;
                }
            }
            
            
            vc.hidesBottomBarWhenPushed = YES;
            [nav pushViewController:vc animated:NO];
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

@end
