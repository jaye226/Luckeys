//
//  LKWalletViewPage.m
//  Luckeys
//
//  Created by BearLi on 15/11/21.
//  Copyright © 2015年 Luckeys. All rights reserved.
//

#import "LKWalletViewPage.h"
#import "LKWalletTableViewCell.h"

@interface LKWalletViewPage ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray * _imageArray;
    NSArray * _titelArray;
}
@property (nonatomic, strong) UITableView * tableView;
@end

@implementation LKWalletViewPage

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"钱包";
    [self initView];
}

- (void)initView {
    self.view.backgroundColor = kGrayBackColor;
    
    _imageArray = @[@"wallet_chongzhi",@"wallet_tixian",@"wallet_card",@"wallet_quan",@"wallet_payManager"];
    _titelArray = @[@"充值",@"提现",@"我的银行卡",@"我的乐其券",@"支付管理"];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, UI_IOS_WINDOW_WIDTH, UI_IOS_WINDOW_HEIGHT-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:_tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 18;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 18)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        return BoundsOfScale(88.0);
    }
    return BoundsOfScale(44.0);
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        static NSString * cellId = @"tabelViewCellId";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            cell.width = tableView.width;
            cell.height = BoundsOfScale(88.0);
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.contentView.backgroundColor = [UIColor clearColor];
            
            PBUILabel * label = [[PBUILabel alloc] initWithFrame:CGRectMake(kBackOffsetX+16, 0, 100, 20)];
            label.centerY = cell.height/2.0;
            label.systemFont = 16;
            label.textColor = kColor666666;
            label.text = @"账户余额";
            label.width = [label widthWithText];
            [cell.contentView addSubview:label];
            
            PBUILabel * money = [[PBUILabel alloc] initWithFrame:CGRectMake(label.maxX + 16, 0, 100, 20)];
            money.centerY = label.centerY;
            money.systemFont = label.systemFont;
            money.textColor = UIColorRGB(0xf75347);
            money.text = @"￥ 10";
            [cell.contentView addSubview:money];
            
            UIImageView * headImage = [[UIImageView alloc] initWithFrame:CGRectMake(cell.width-kBackOffsetX-16-BoundsOfScale(56), 0, BoundsOfScale(56), BoundsOfScale(56))];
            [headImage setContentMode:UIViewContentModeScaleAspectFill];
            headImage.clipsToBounds = YES;
            headImage.centerY = label.centerY;
            [headImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@%@",SeverHost,[[LKShareUserInfo share] userInfo].userHead]] placeholderImage:kUserPlaceholderImage];
            [cell.contentView addSubview:headImage];
            
            UIImageView * sepImage = [[UIImageView alloc] initWithFrame:CGRectMake(kBackOffsetX+16, cell.height-0.5, cell.width-2*(kBackOffsetX+16), 0.5)];
            sepImage.image = [UIImage imageWithColor:UIColorRGB(0xe1e1e1)];
            [cell.contentView addSubview:sepImage];

        }
        return cell;
    }
    else {
        static NSString * cellId = @"otherCellId";
        LKWalletTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[LKWalletTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.contentView.backgroundColor = [UIColor clearColor];
        }
        NSInteger row = indexPath.row;
        
        if (indexPath.section == 0) {
            cell.tipImage.image = UIImageNamed(_imageArray[row-1]);
            cell.tipTitle.text = _titelArray[row-1];
        }
        else {
            cell.tipImage.image = UIImageNamed(_imageArray[row+2]);
            cell.tipTitle.text = _titelArray[row+2];
        }
        
        
        if (indexPath.row == 2) {
            cell.sepImage.x = kBackOffsetX;
            cell.sepImage.width = cell.width - 2*cell.sepImage.x;
        }
        else {
            cell.sepImage.x = kBackOffsetX +16;
            cell.sepImage.width = cell.width - 2*cell.sepImage.x;
        }
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(tintColor)]) {
        if (tableView == _tableView) {
            CGFloat cornerRadius = 4.f;
            cell.backgroundColor = UIColor.clearColor;
            CAShapeLayer *layer = [[CAShapeLayer alloc] init];
            CGMutablePathRef pathRef = CGPathCreateMutable();
            CGRect bounds = CGRectInset(cell.bounds, 18, 0);
            BOOL addLine = NO;
            if (indexPath.row == 0 && indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
                CGPathAddRoundedRect(pathRef, nil, bounds, cornerRadius, cornerRadius);
            } else if (indexPath.row == 0) {
                CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds)); CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
                CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
                CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
                addLine = YES;
            } else if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) { CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds)); CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
                CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
                CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds));
            } else {
                CGPathAddRect(pathRef, nil, bounds);
                addLine = YES;
            }
            layer.path = pathRef;
            CFRelease(pathRef);
            layer.fillColor = [UIColor colorWithWhite:1.f alpha:0.8f].CGColor;
            /*if (addLine == YES) {
             CALayer *lineLayer = [[CALayer alloc] init];
             CGFloat lineHeight = (1.f / [UIScreen mainScreen].scale);
             lineLayer.frame = CGRectMake(CGRectGetMinX(bounds)+10, bounds.size.height-lineHeight, bounds.size.width-10, lineHeight);
             lineLayer.backgroundColor = tableView.separatorColor.CGColor;
             [layer addSublayer:lineLayer];
             }*/
            UIView *testView = [[UIView alloc] initWithFrame:bounds];
            [testView.layer insertSublayer:layer atIndex:0];
            testView.backgroundColor = UIColor.clearColor;
            cell.backgroundView = testView;
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
