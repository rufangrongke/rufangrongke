//
//  WXZKeHuController.m
//  rufangrongke
//
//  Created by dymost on 15/10/18.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

#import "WXZKeHuController.h"
#import "AFNetworking.h"
#import "WXZChectObject.h"
#import "WXZStringObject.h"
#import "WXZDateObject.h"
#import <SVProgressHUD.h>
#import "WXZKeHuListCell.h"
#import "WXZKHListHeaderView.h"
#import "WXZKHListFooterView.h"
#import "WXZAddCustomerVC.h"
#import "WXZCustomerDetailsVC.h"
#import "WXZReportPreparationVC.h"

@interface WXZKeHuController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSArray *dataArr;

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
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // 初始化
    self.dataArr = [NSArray array];
    
    // 显示菊花
    [SVProgressHUD showWithStatus:@"请稍后..." maskType:SVProgressHUDMaskTypeBlack];
    // 请求列表
    [self keHuListRequest:@"1" numberEachPage:@"" handsomeChooseCategory:@"" handsomeChooseConditions:@""];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    
}

#pragma mark - Data Request Methods
- (void)keHuListRequest:(NSString *)page numberEachPage:(NSString *)eachPage handsomeChooseCategory:(NSString *)chooseCategory handsomeChooseConditions:(NSString *)chooseConditions
{
    NSString *urlStr = [OutNetBaseURL stringByAppendingString:kehuliebiao];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:page forKey:@"inp"];
    [param setObject:eachPage forKey:@"ps"];
    [param setObject:chooseCategory forKey:@"zt"];
    [param setObject:chooseConditions forKey:@"key"];
    
    [[AFHTTPSessionManager manager] POST:urlStr parameters:param success:^(NSURLSessionDataTask *task, id responseObject)
    {
        if ([responseObject[@"ok"] integerValue] == 1)
        {
            WXZLog(@"%@",responseObject);
            self.dataArr = responseObject[@"list"];
            [self.tableView reloadData];
        }
        else
        {
            
        }
        [SVProgressHUD dismiss];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error)
    {
        
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WXZKeHuListCell *keHuInfoCell = [tableView dequeueReusableCellWithIdentifier:@"KeHuInfoCell"];
    
    if (!keHuInfoCell)
    {
        keHuInfoCell = [WXZKeHuListCell initListCell];
        keHuInfoCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    keHuInfoCell.controller = self; // 权限
    
    // 赋值
    [keHuInfoCell showKeHuListInfo:self.dataArr[indexPath.section]];
    
    return keHuInfoCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 客户详情页
    WXZCustomerDetailsVC *customerDetailsVC = [[WXZCustomerDetailsVC alloc] init];
    customerDetailsVC.customerId = self.dataArr[indexPath.section][@"id"];
    [self.navigationController pushViewController:customerDetailsVC animated:YES];
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
    // 首先判断有没有值
    if (![WXZChectObject checkWhetherStringIsEmpty:self.dataArr[section][@"hdTime"]] || ![WXZChectObject checkWhetherStringIsEmpty:self.dataArr[section][@"typeSmall"]])
    {
        WXZKHListFooterView *footerView = [WXZKHListFooterView initListFooterView]; // footer背景 view
        [footerView footerInfoLabel:self.dataArr[section]]; // footer 信息
        
        return footerView;
    }
    else
    {
        return nil;
    }
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
    return [self calculateHeightOfRow:self.dataArr[indexPath.section]]; // 75
}

// 计算行高
- (NSInteger)calculateHeightOfRow:(NSDictionary *)dic
{
    NSString *yixiangStr = dic[@"YiXiang"];
    NSInteger yixiang = 0;
    if (![WXZChectObject checkWhetherStringIsEmpty:yixiangStr])
    {
        yixiang = 18;
    }
    
    return 20 + 20 + 12 + yixiang; // 返回行高
}

// 添加新客户事件
- (void)addNewKeHuAction:(id)sender
{
    NSLog(@"添加新客户!");
    // 添加新客户页
    WXZAddCustomerVC *addCustomerVC = [[WXZAddCustomerVC alloc] init];
    [self.navigationController pushViewController:addCustomerVC animated:YES];
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
