//
//  WXZKeHuController.m
//  rufangrongke
//
//  Created by dymost on 15/10/18.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

#import "WXZKeHuController.h"
#import "WXZKeHuListCell.h"
#import "WXZKHListHeaderView.h"
#import "WXZKHListFooterView.h"

@interface WXZKeHuController ()

@end

@implementation WXZKeHuController

#pragma 初始化项目
- (void)setUp{
    // 设置导航栏左边按钮
    {
        //    // 右边
        //    UIButton *button_right = [UIButton buttonWithType:UIButtonTypeCustom];
        //    [button_right setBackgroundImage:[UIImage imageNamed:@"lp_qd"] forState:UIControlStateNormal];
        //    [button_right setBackgroundImage:[UIImage imageNamed:@"lp_qd"] forState:UIControlStateHighlighted];
        //    button_right.size = button_right.currentBackgroundImage.size;
        //    [button_right addTarget:self action:@selector(queDing_click) forControlEvents:UIControlEventTouchUpInside];
        //    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:button_right];
        //    self.navigationItem.rightBarButtonItem = rightItem;
        //
        //    // 左边
        //    UIButton *button_left = [UIButton buttonWithType:UIButtonTypeCustom];
        //    [button_left setBackgroundImage:[UIImage imageNamed:@"lp_quyutu"] forState:UIControlStateNormal];
        //    [button_left setBackgroundImage:[UIImage imageNamed:@"lp_quyutu"] forState:UIControlStateHighlighted];
        //    button_left.size = button_left.currentBackgroundImage.size;
        //    [button_left addTarget:self action:@selector(quDu_click) forControlEvents:UIControlEventTouchUpInside];
        //    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:button_left];
        //    self.navigationItem.leftBarButtonItem = leftItem;
    }
    // 左边按钮
    //    [UIBarButtonItem];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"kh_shaixuan" highImage:@"kh_shaixuan" target:self action:@selector(quDu_click)];
    // 右边按钮
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"lp_qd" highImage:@"lp_qd" target:self action:@selector(queDing_click)];
    // 添加一个系统的搜索框
    self.navigationItem.titleView = [[UISearchBar alloc]init];
    
}
// 右上方按钮监听点击
- (void)queDing_click{
    WXZLogFunc;
}
// 左上方按钮监听点击
- (void)quDu_click{
    WXZLogFunc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 视图整体背景色
    self.view.backgroundColor = WXZRGBColor(246, 246, 246);
    
    // 初始化信息
    [self setUp];
    
    // 设置搜索框
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    searchBar.placeholder = @"请输入客户姓名";
    self.navigationItem.titleView = searchBar;
    
}

- (void)viewWillAppear:(BOOL)animated
{
//    // 设置导航栏左右两侧的 button
//    UIView *leftBtnView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
//    // 标题
//    UILabel *leftTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 32, leftBtnView.height)];
//    leftTitleLabel.text = @"筛选";
//    leftTitleLabel.textAlignment = NSTextAlignmentLeft;
//    leftTitleLabel.textColor = [UIColor whiteColor];
//    leftTitleLabel.font = WXZ_SystemFont(16);
//    [leftBtnView addSubview:leftTitleLabel];
//    // 箭头图片
//    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(leftTitleLabel.x+leftTitleLabel.width, (leftBtnView.height-6)/2, 12, 6)];
//    imgView.image = [UIImage imageNamed:@"kh_ip_jt"];
//    imgView.userInteractionEnabled = YES;
//    [leftBtnView addSubview:imgView];
//    // 添加轻击手势
//    UITapGestureRecognizer *leftTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(screeningAction:)];
//    [leftBtnView addGestureRecognizer:leftTap];
//    
//    // 右侧按钮
//    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    rightBtn.frame = CGRectMake(0, 0, 40, 44);
//    [rightBtn setTitle:@"确定" forState:UIControlStateNormal];
//    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    rightBtn.titleLabel.font = WXZ_SystemFont(16);
//    [rightBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 8, 0, 0)]; // 标题向左侧偏移
//    [rightBtn addTarget:self action:@selector(determineAction:) forControlEvents:UIControlEventTouchUpInside];
//    
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtnView];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
}

#pragma mark - Data Request Methods
- (void)request
{
       
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    if (section == 0)
    {
        return 2;
    }
    else
    {
        return 3;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WXZKeHuListCell *keHuInfoCell = [tableView dequeueReusableCellWithIdentifier:@"KeHuInfoCell"];
    
    if (!keHuInfoCell)
    {
        keHuInfoCell = [WXZKeHuListCell initListCell];
        keHuInfoCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    // 添加单击事件
    [keHuInfoCell buttonWithTarget:self action:@selector(reportedOrCallAction:)];
    keHuInfoCell.reportedBtn.hidden = YES;
    keHuInfoCell.reportedOrCallBtn.hidden = NO;
    
    // 赋值
    keHuInfoCell.customerNameLabel.text = @"刘丽莎";
    keHuInfoCell.customerPhoneLabel.text = @"13921754683";
    keHuInfoCell.houseInfoLabel.text = @"急售新华区｜裕华区，｜三室｜别墅，440-1000万";
    
    return keHuInfoCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"click %ld row",(long)indexPath.row);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        WXZKHListHeaderView *headerView = [WXZKHListHeaderView initListHeaderView]; // header背景 view
        // 添加轻击手势
        UITapGestureRecognizer *headerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addNewKeHuAction:)];
        [headerView addGestureRecognizer:headerTap];
        
        return headerView;
    }
    else
    {
        return nil;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    WXZKHListFooterView *footerView = [WXZKHListFooterView initListFooterView]; // footer背景 view
    [footerView footerInfoLabel:@"15-10-21 10:10 带看裕华区6号楼 590-1000W,阿萨德和积分卡"]; // footer 信息
    
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    // 返回header的高
    if (section == 0)
    {
        return 48;
    }
    else
    {
        return 0.1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 31;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}

// 添加新客户事件
- (void)addNewKeHuAction:(id)sender
{
    NSLog(@"添加新客户!");
}

// 报备/打电话事件
- (void)reportedOrCallAction:(UIButton *)sender
{
    if (sender.tag == 100001)
    {
        NSLog(@"报备事件");
    }
    else
    {
        NSLog(@"打电话事件");
    }
}

#pragma mark - Navigation BarButtonItem Click Event
- (void)screeningAction:(id)sender
{
    // 筛选
    NSLog(@"筛选");
}

- (void)determineAction:(id)sender
{
    // 确定
    NSLog(@"确定");
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
