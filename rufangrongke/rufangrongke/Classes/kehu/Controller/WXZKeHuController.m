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
#import <MJExtension.h>

@interface WXZKeHuController () <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UISearchBarDelegate,BackFilterTypeDelegate>
{
    NSString *eachPage; // 每页显示条数
    BOOL isRefresh; // 是否刷新
}

@property (nonatomic,strong) UISearchBar *searchBar;
@property (nonatomic,strong) UITextField *searchTextField;

@property (nonatomic,strong) WXZScreeningView *screeningView;

@property (nonatomic,strong) UIView *mengCengView;

@property (nonatomic,strong) NSMutableArray *dataArr;

@property (nonatomic,strong) NSArray *shaixuanArr;

@property (nonatomic,strong) WXZKeHuInfoModel *kehuInfoModel;

@end

static NSInteger isHiden; // 弹框是否隐藏
static NSInteger currentPage; // 当前页数
static BOOL isMore; // 是否有更多数据
static NSString *shaixuanStr; // 记录筛选类型
static NSString *searchStr; // 记录搜索条件

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
    
    isRefresh = YES;
    isMore = YES;
    currentPage = 1;
    eachPage = @"8";
    shaixuanStr = @"";
    searchStr = @"";
    // 显示菊花
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    // 请求列表
    [self keHuListRequest:currentPage numberEachPage:eachPage handsomeChooseCategory:shaixuanStr handsomeChooseConditions:searchStr];
    [self setupRefresh];
    
    // 初始化信息
    [self setUp];
    isHiden = NO;
    
    // 注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateKeHuInfo:) name:@"UpdateKeHuInfoNotification" object:nil];
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
    _searchBar.backgroundColor = [UIColor clearColor];
    _searchBar.backgroundImage = [UIImage imageNamed:@""];
    _searchBar.placeholder = @"请输入客户姓名";
    _searchBar.delegate = self;
    self.navigationItem.titleView = _searchBar;
}

#pragma mark - Data Request Methods
- (void)keHuListRequest:(NSInteger)page numberEachPage:(NSString *)eachPage1 handsomeChooseCategory:(NSString *)chooseCategory handsomeChooseConditions:(NSString *)chooseConditions
{
    NSString *urlStr = [OutNetBaseURL stringByAppendingString:kehuliebiao];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[NSString stringWithFormat:@"%ld",(long)page] forKey:@"inp"];
    [param setObject:eachPage1 forKey:@"ps"];
    [param setObject:chooseCategory forKey:@"zt"];
    [param setObject:chooseConditions forKey:@"key"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager POST:urlStr parameters:param success:^(NSURLSessionDataTask *task, id responseObject)
    {
        if ([responseObject[@"ok"] integerValue] == 1)
        {
            NSArray *arr = responseObject[@"list"];
            if (isRefresh)
            {
                if (arr.count > 0)
                {
                    // 直接把数组里边的字典的值转换为模型
                    self.dataArr = [NSMutableArray arrayWithArray:[WXZKeHuInfoModel objectArrayWithKeyValuesArray:arr]];
                }
                else
                {
                    [self.dataArr removeAllObjects];
                    [self.tableView.footer endRefreshingWithNoMoreData];
                    isMore = NO;
                }
            }
            else
            {
                if (arr.count > 0)
                {
                    [self.dataArr addObjectsFromArray:[WXZKeHuInfoModel objectArrayWithKeyValuesArray:arr]];
                }
                else
                {
                    [self.tableView.footer endRefreshingWithNoMoreData];
                    isMore = NO;
                }
            }
            [SVProgressHUD dismiss]; // 取消菊花
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:responseObject[@"msg"]];
        }
        [self.tableView reloadData];
        // 结束刷新
        [self.tableView.header endRefreshing];
        if (isMore)
        {
            // 结束刷新
            [self.tableView.footer endRefreshing];
        }
        searchStr = @"";
        _searchBar.text = @"";
        
    } failure:^(NSURLSessionDataTask *task, NSError *error)
    {
        [SVProgressHUD showErrorWithStatus:@"请求失败"];
        searchStr = @"";
        _searchBar.text = @"";
    }];
}

- (void)backScreeningType:(NSString *)type
{
    [self hideScreeningView];
    currentPage = 1;
    isRefresh = YES;
    shaixuanStr = type;
    searchStr = @"";
    // 显示菊花
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    // 请求列表
    [self keHuListRequest:currentPage numberEachPage:eachPage handsomeChooseCategory:shaixuanStr handsomeChooseConditions:searchStr];
}

// 通知事件
- (void)updateKeHuInfo:(id)sender
{
    currentPage = 1;
    isRefresh = YES;
    shaixuanStr = @"";
    searchStr = @"";
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack]; // 显示菊花
    [self keHuListRequest:currentPage numberEachPage:eachPage handsomeChooseCategory:shaixuanStr handsomeChooseConditions:searchStr]; // 请求列表
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
    [_searchBar resignFirstResponder];
}

#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [self hideScreeningView];
    return YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [self hideScreeningView];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    searchStr = searchBar.text;
    [self queDing_click]; //
}

#pragma - mark 刷新、加载
/**
 * 添加刷新控件
 */
- (void)setupRefresh
{
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshKeHuInfo)];
    
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreKeHuInfo)];
    //    self.tableView.footer.hidden = YES;
}
- (void)refreshKeHuInfo
{
    // 刷新
    currentPage = 1;
    isRefresh = YES;
    isMore = YES;
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    [self keHuListRequest:currentPage numberEachPage:eachPage handsomeChooseCategory:shaixuanStr handsomeChooseConditions:searchStr];
}
- (void)loadMoreKeHuInfo
{
    isRefresh = NO;
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    [self keHuListRequest:currentPage++ numberEachPage:eachPage handsomeChooseCategory:shaixuanStr handsomeChooseConditions:searchStr];
}

// 添加新客户事件
- (void)addNewKeHuAction:(id)sender
{
    [self hideScreeningView];
    [_searchBar resignFirstResponder];
    // 添加新客户页
    WXZAddCustomerVC *addCustomerVC = [[WXZAddCustomerVC alloc] init];
    addCustomerVC.isModifyCustomerInfo = NO;
    addCustomerVC.titleStr = @"添加客户";
    addCustomerVC.isKeHuDetail = NO;
    [self.navigationController pushViewController:addCustomerVC animated:YES];
}

#pragma mark - Navigation BarButtonItem Click Event
// 右上方按钮监听点击
- (void)queDing_click
{
    WXZLogFunc;
    [self hideScreeningView];
    currentPage = 1;
    isRefresh = YES;
    shaixuanStr = @"";
    searchStr = self.searchBar.text;
    // 显示菊花
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    // 请求列表
    [self keHuListRequest:currentPage numberEachPage:eachPage handsomeChooseCategory:shaixuanStr handsomeChooseConditions:searchStr];
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
        self.mengCengView = [[UIView alloc] initWithFrame:CGRectMake(0, self.tableView.contentOffset.y, WXZ_ScreenWidth, WXZ_ScreenHeight-64)];
        self.mengCengView.backgroundColor = [UIColor colorWithRed:15/255 green:15/255 blue:15/255 alpha:0.5];
        [self.view addSubview:self.mengCengView];
        
        // 动画
        CGContextRef context = UIGraphicsGetCurrentContext();
        [UIView beginAnimations:@"donghua" context:context];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        [UIView setAnimationDelay:0.1];
        // 显示视图
        _screeningView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([WXZScreeningView class]) owner:self options:nil] lastObject];
        _screeningView.frame = CGRectMake(10, 0, 140, 185);
        _screeningView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"kh_screening"]];
        _screeningView.dataArr = self.shaixuanArr;
        _screeningView.backScreeningTypeDelegate = self;
        [self.mengCengView addSubview:_screeningView];
        self.tableView.scrollEnabled = NO;
        isHiden = YES;
        // 提交动画
        [UIView commitAnimations];
    }
}
// 隐藏筛选视图
- (void)hideScreeningView
{
    [self.mengCengView removeFromSuperview];
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
