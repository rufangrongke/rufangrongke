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
#import "WXZScreeningView.h"
#import "WXZKeHuInfoModel.h"

@interface WXZKeHuController () <UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,BackFilterTypeDelegate>

@property (nonatomic,strong) UISearchBar *searchBar;

@property (nonatomic,strong) WXZScreeningView *screeningView;

@property (nonatomic,strong) NSMutableArray *dataArr;

@property (nonatomic,strong) NSArray *shaixuanArr;

@property (nonatomic,strong) WXZKeHuInfoModel *kehuInfoModel;

@end

static NSInteger isHiden; // 弹框是否隐藏

@implementation WXZKeHuController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 视图整体背景色
    self.view.backgroundColor = WXZRGBColor(246, 246, 246);
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.userInteractionEnabled = YES;
    
    // 初始化
    self.dataArr = [NSMutableArray array];
    self.shaixuanArr = @[@"所有",@"已报备",@"已带看",@"已预约",@"以认购",@"已结佣",@"未报备",@"无效客户"];
    
    // 显示菊花
    [SVProgressHUD showWithStatus:@"请稍后..." maskType:SVProgressHUDMaskTypeBlack];
    // 请求列表
    [self keHuListRequest:@"1" numberEachPage:@"8" handsomeChooseCategory:@"" handsomeChooseConditions:@""];
    
    // 初始化信息
    [self setUp];
    isHiden = NO;
}

#pragma 初始化项目
- (void)setUp
{
    // 左边按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"kh_shaixuan" highImage:@"kh_shaixuan" target:self action:@selector(quDu_click)];
    // 右边按钮
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"lp_qd" highImage:@"lp_qd" target:self action:@selector(queDing_click)];
    // 添加一个系统的搜索框
    _searchBar = [[UISearchBar alloc] init];
    _searchBar.delegate = self;
    self.navigationItem.titleView = _searchBar;
    
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
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager POST:urlStr parameters:param success:^(NSURLSessionDataTask *task, id responseObject)
    {
        if ([responseObject[@"ok"] integerValue] == 1)
        {
//            WXZLog(@"%@",responseObject);
            
            NSArray *arr = responseObject[@"list"];
            // 直接把数组里边的字典的值转换为模型
            self.dataArr = [WXZKeHuInfoModel objectArrayWithKeyValuesArray:arr];
            [self.tableView reloadData];
        }
        else
        {
//            WXZLog(@"%@",responseObject);
            [SVProgressHUD showErrorWithStatus:responseObject[@"msg"]];
        }
        [SVProgressHUD dismiss];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error)
    {
        [SVProgressHUD showErrorWithStatus:@"请求失败"];
        [SVProgressHUD dismiss];
    }];
}

- (void)backScreeningType:(NSString *)type
{
    [self hideScreeningView];
    // 显示菊花
    [SVProgressHUD showWithStatus:@"请稍后..." maskType:SVProgressHUDMaskTypeBlack];
    // 请求列表
    [self keHuListRequest:@"1" numberEachPage:@"8" handsomeChooseCategory:type handsomeChooseConditions:@""];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArr.count+1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        NSString *identifier = @"cell";
        UITableViewCell *headerCell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!headerCell)
        {
            headerCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        return headerCell;
    }
    else
    {
        WXZKeHuListCell *keHuInfoCell = [tableView dequeueReusableCellWithIdentifier:@"KeHuInfoCell"];
        
        if (!keHuInfoCell)
        {
            keHuInfoCell = [WXZKeHuListCell initListCell];
            keHuInfoCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        keHuInfoCell.controller = self; // 权限
        
        // 赋值
//        [keHuInfoCell showKeHuListInfo:self.dataArr[indexPath.section]];
        keHuInfoCell.keHuInfoModel = self.dataArr[indexPath.section-1];
        
        return keHuInfoCell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self hideScreeningView];
    // 客户详情页
    WXZCustomerDetailsVC *customerDetailsVC = [[WXZCustomerDetailsVC alloc] init];
    self.kehuInfoModel = self.dataArr[indexPath.section-1];
    customerDetailsVC.customerId = self.kehuInfoModel.ID;
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
    if (section != 0)
    {
        // 首先判断有没有值
        self.kehuInfoModel = self.dataArr[section-1];
        if (![WXZChectObject checkWhetherStringIsEmpty:self.kehuInfoModel.hdTime] || ![WXZChectObject checkWhetherStringIsEmpty:self.kehuInfoModel.typebig] || ![WXZChectObject checkWhetherStringIsEmpty:self.kehuInfoModel.loupan])
        {
            WXZKHListFooterView *footerView = [WXZKHListFooterView initListFooterView]; // footer背景 view
            footerView.keHuInfoModel = self.dataArr[section-1]; // footer 信息
            
            return footerView;
        }
        else
        {
            return nil;
        }
    }
    return nil;
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
    if (section == 0)
    {
        return 0.001;
    }
    return 31;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return 0.0f;
    }
    return [self calculateHeightOfRow:self.dataArr[indexPath.section-1]]; // 75
}

// 计算行高
- (NSInteger)calculateHeightOfRow:(WXZKeHuInfoModel *)model
{
    NSString *yixiangStr = model.YiXiang;
    NSInteger yixiang = 0;
    if (![WXZChectObject checkWhetherStringIsEmpty:yixiangStr])
    {
        yixiang = 18;
    }
    
    return 20 + 20 + 12 + yixiang; // 返回行高
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self hideScreeningView];
}

#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [self hideScreeningView];
    return YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
//    NSLog(@"%@",searchBar.text);
    [self hideScreeningView];
}

// 添加新客户事件
- (void)addNewKeHuAction:(id)sender
{
//    NSLog(@"添加新客户!");
    [self hideScreeningView];
    // 添加新客户页
    WXZAddCustomerVC *addCustomerVC = [[WXZAddCustomerVC alloc] init];
    addCustomerVC.titleStr = @"添加客户";
    [self.navigationController pushViewController:addCustomerVC animated:YES];
}

#pragma mark - Navigation BarButtonItem Click Event
// 右上方按钮监听点击
- (void)queDing_click
{
    WXZLogFunc;
//    NSLog(@"%@",_searchBar.text);
    [self hideScreeningView];
    // 显示菊花
    [SVProgressHUD showWithStatus:@"请稍后..." maskType:SVProgressHUDMaskTypeBlack];
    // 请求列表
    [self keHuListRequest:@"1" numberEachPage:@"8" handsomeChooseCategory:@"" handsomeChooseConditions:_searchBar.text];
}
// 左上方按钮监听点击
- (void)quDu_click
{
    WXZLogFunc;
    [self.searchBar resignFirstResponder];
    if (isHiden)
    {
        [self hideScreeningView];
    }
    else
    {
        // 动画
        CGContextRef context = UIGraphicsGetCurrentContext();
        [UIView beginAnimations:@"donghua" context:context];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        [UIView setAnimationDelay:0.1];
        // 显示视图
        _screeningView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([WXZScreeningView class]) owner:self options:nil] lastObject];
        _screeningView.frame = CGRectMake(10, 0, 84, 111);
        _screeningView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"kh_screening"]];
        _screeningView.dataArr = self.shaixuanArr;
        _screeningView.backScreeningTypeDelegate = self;
        [self.view addSubview:_screeningView];
        self.tableView.scrollEnabled = YES;
        isHiden = YES;
        // 提交动画
        [UIView commitAnimations];
    }
}
// 隐藏筛选视图
- (void)hideScreeningView
{
    [self.screeningView removeFromSuperview];
    self.tableView.scrollEnabled = YES;
    isHiden = NO;
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
