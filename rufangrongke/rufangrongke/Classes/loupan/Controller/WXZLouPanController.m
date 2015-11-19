//
//  WXZLouPanController.m
//  rufangrongke
//
//  Created by dymost on 15/10/18.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

#import "WXZLouPanController.h"
#import "WXZSeachView.h"
#import <SVProgressHUD.h>
#import "AFNetworking.h"
#import "WXZLouPan.h"
#import "WXZTableViewCell.h"
#import <MJExtension.h>
#import "WXZLouPanMessageController.h"
#import "WXZquYuListViewController.h"
#import "WXZLouPanHomeHeadView.h"
#import "WXZLeftBtnView.h"
#import "SDCycleScrollView.h"

@interface WXZLouPanController ()<UITableViewDataSource, UITableViewDelegate, WXZquYuListViewControllerDelegate, UISearchBarDelegate>
/** 楼盘模型字典 */
@property (nonatomic, strong) WXZLouPan *loupanModel;

@property (nonatomic, strong) UISearchBar *search;

/* 缓存list数据 */
/* fys */
@property (nonatomic , strong) NSMutableArray *fysList;
/* WXZquYuListViewController */
@property (nonatomic , strong) WXZquYuListViewController *quYuListViewVC;
/* leftBtn */
@property (nonatomic , weak) WXZLeftBtnView *leftBtn;
/* WXZLouPanHomeHeadView */
@property (nonatomic , weak) UIView *louPanHomeHeadView;
@end

@implementation WXZLouPanController

static NSString * const WXZLoupanCellID = @"loupanleibiaoCell";
//static NSInteger listCount = 1;
static NSString *xiaoqu = @"";
static NSString *quyu = @"";
static NSInteger inp = 1;
/**
 * 抽取的网络请求方法
 */
- (void)networkRequestsWithInp:(NSInteger)inp xiaoqu:(NSString *)xiaoqu quyu:(NSString *)quyu{
    [SVProgressHUD show];
    // 发送请求
    NSString *url = [OutNetBaseURL stringByAppendingString:loupanliebiao];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"inp"] = @(inp);
    params[@"xiaoqu"] = xiaoqu;
    params[@"qu"] = quyu;
    [[AFHTTPSessionManager manager] POST:url parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
//        WXZLog(@"%@", responseObject);
        // 隐藏指示器
        [SVProgressHUD dismiss];
        // 转模型,存储模型
        self.loupanModel = [WXZLouPan objectWithKeyValues:responseObject];
        self.fysList = [NSMutableArray arrayWithArray:self.loupanModel.fys];
        // 刷新表格
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        // 显示失败信息
        [SVProgressHUD showErrorWithStatus:@"加载推荐信息失败!"];
    }];
}
/* fysList懒加载 */
- (NSMutableArray *)fysList
{
    if (_fysList == nil) {
        _fysList = [NSMutableArray array];
    }
    return _fysList;
}

#pragma mark - 通知
- (void)notification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshList:) name:@"RefreshCity" object:nil];
}
- (void)refreshList:(NSNotification *)notification
{
    self.leftBtn.leftBtnLabel.text = @"区域";
    inp = 1;
    xiaoqu = @"";
    quyu = @"";
    self.fysList = nil;
    [self.tableView.footer resetNoMoreData];
    [self networkRequestsWithInp:inp xiaoqu:xiaoqu quyu:quyu];
}
#pragma mark - <初始化项目>
- (void)setUp{
    // 注册通知
    [self notification];
    
    // 去除分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 设置导航栏左边按钮
    WXZLeftBtnView *leftBtn = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([WXZLeftBtnView class]) owner:nil options:nil].lastObject;
    [leftBtn addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(quYu_click)]];
    self.leftBtn = leftBtn;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    // 设置导航栏右边按钮
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"lp_qd" highImage:@"lp_qd" target:self action:@selector(queDing_click)];
    // 添加一个系统的搜索框
    UISearchBar *search = [[UISearchBar alloc]init];
    search.bounds = CGRectMake(0, 0, 100, 40);
    search.placeholder = @"楼盘搜索";
    self.navigationItem.titleView = search;
    search.delegate = self;
    self.search = search;
    // 消除pop的时候searchbar背景闪一下
    for (UIView *view in self.search.subviews) {
//        // for before iOS7.0
//        if ([view isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
//            [view removeFromSuperview];
//            break;
//        }
        // for later iOS7.0(include)
        if ([view isKindOfClass:NSClassFromString(@"UIView")] && view.subviews.count > 0) {
            [[view.subviews objectAtIndex:0] removeFromSuperview];
            break;
        }
    }


    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WXZTableViewCell class]) bundle:nil] forCellReuseIdentifier:WXZLoupanCellID];
    // cell高度
    self.tableView.rowHeight = 100;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化信息
    [self setUp];
    // 添加刷新控件
    [self setupRefresh];
    
    // 显示指示器
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    
    // 网络请求
    [self networkRequestsWithInp:inp xiaoqu:xiaoqu quyu:quyu];

}

/**
 *  右上方按钮监听点击
 */
- (void)queDing_click
{
    // 隐藏WXZquYuListViewController.view
    self.quYuListViewVC.view.hidden = YES;
    // 取消键盘
    [self.search resignFirstResponder];
    // 根据搜索栏发送请求
    if (self.search.text.length == 0){
        [SVProgressHUD showErrorWithStatus:@"请填写小区名" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    [SVProgressHUD show];
    inp = 1;
    xiaoqu = self.search.text;
    [self networkRequestsWithInp:inp xiaoqu:xiaoqu quyu:quyu];

}

/**
 *  左上方按钮监听点击
 */
- (void)quYu_click{
    // 让点击区域后让tableview瞬间停止滑动
    [self.tableView setContentOffset:CGPointMake(self.tableView.contentOffset.x, self.tableView.contentOffset.y) animated:NO];
    // 取消键盘
    [self.search resignFirstResponder];
    
    WXZLog(@"%f", self.tableView.contentOffset.y);
    if (self.quYuListViewVC == nil) {
        // 楼盘区域列表
        WXZquYuListViewController *quYuListViewVC = [[WXZquYuListViewController alloc] init];
        quYuListViewVC.delegate = self;
        self.quYuListViewVC = quYuListViewVC;
        self.quYuListViewVC.view.frame = CGRectMake(0, self.tableView.contentOffset.y, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64);
        [self.tableView addSubview:self.quYuListViewVC.view];
        self.tableView.scrollEnabled = NO;
        self.louPanHomeHeadView.hidden = YES;
    }else{
        self.quYuListViewVC.view.frame = CGRectMake(0, self.tableView.contentOffset.y, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64);;
        self.quYuListViewVC.view.hidden = !self.quYuListViewVC.view.hidden;
        self.tableView.scrollEnabled = !self.tableView.scrollEnabled;
        self.louPanHomeHeadView.hidden = !self.louPanHomeHeadView.hidden;
    }
}


#pragma mark - WXZquYuListViewControllerDelegate
- (void)quYuListViewControllerDelegate:(NSString *)parameter
{
    // 上拉刷新控件置空
    [self.tableView.footer resetNoMoreData];
    self.tableView.contentOffset = CGPointMake(0, 0);
    self.quYuListViewVC.view.hidden = YES;
    self.tableView.scrollEnabled = YES;
    inp = 1;
    quyu = parameter;
    self.search.text = @"";
    xiaoqu = self.search.text;
    [self networkRequestsWithInp:inp xiaoqu:xiaoqu quyu:quyu];
    
    // 修改左上方按钮
    if (![parameter  isEqual: @""]) {
        NSString *name = [parameter substringToIndex:2];
//        WXZLog(@"%@", name);
        self.leftBtn.leftBtnLabel.text = name;
    }else{
        self.leftBtn.leftBtnLabel.text = @"区域";
    }
}
#pragma mark - 刷新控件
/**
 * 添加刷新控件
 */
- (void)setupRefresh
{
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewUsers)];
    
    self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreUsers)];
}
- (void)loadNewUsers
{
    // 下拉刷新复活
    [self.tableView.footer resetNoMoreData];
    inp = 1;
    NSString *url = [OutNetBaseURL stringByAppendingString:loupanliebiao];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"inp"] = @(inp);
    params[@"qu"] = quyu;
    params[@"xiaoqu"] = xiaoqu;
    [[AFHTTPSessionManager manager] POST:url parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        // 转模型,存储模型
        self.loupanModel = [WXZLouPan objectWithKeyValues:responseObject];
        
        self.fysList = [NSMutableArray arrayWithArray:self.loupanModel.fys];
        // 刷新表格
        [self.tableView reloadData];
        // 结束刷新
        [self.tableView.header endRefreshing];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        // 结束刷新
        [self.tableView.header endRefreshing];
        // 显示失败信息
        [SVProgressHUD showErrorWithStatus:@"加载信息失败!"];
    }];
    
}
- (void)loadMoreUsers
{
    if (self.fysList.count < self.loupanModel.rowcount) {
        inp++;
        // 发送请求
        NSString *url = [OutNetBaseURL stringByAppendingString:loupanliebiao];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"inp"] = @(inp);
        params[@"qu"] = quyu;
        params[@"xiaoqu"] = xiaoqu;
        [[AFHTTPSessionManager manager] POST:url parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
            // 转模型,存储模型
            WXZLouPan *loupanModel = [WXZLouPan objectWithKeyValues:responseObject];
            [self.fysList addObjectsFromArray:loupanModel.fys];
            // 刷新表格
            [self.tableView reloadData];
            // 结束刷新
            [self.tableView.footer endRefreshing];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            // 结束刷新
            [self.tableView.footer endRefreshing];
            // 显示失败信息
            [SVProgressHUD showErrorWithStatus:@"加载信息失败!"];
        }];
        
    }else{
        [self.tableView.footer endRefreshingWithNoMoreData];
    }
    
}


#pragma mark - <UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.fysList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WXZTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:WXZLoupanCellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    NSLog(@"%@", self.loupanLeibiaoS[indexPath.row]);
    cell.fys = self.fysList[indexPath.row];
    
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
//    WXZLouPanHomeHeadView *louPanHomeHeadView = [WXZLouPanHomeHeadView louPanHomeHeadView];
//    louPanHomeHeadView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width * 218 / 375);
//    self.louPanHomeHeadView = louPanHomeHeadView;
//    return louPanHomeHeadView;
    UIView *louPanHomeHeadView = [[UIView alloc] init];
    louPanHomeHeadView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width * 218 / 375);
    NSArray *images = @[[UIImage imageNamed:@"lp_babber0"],
                        [UIImage imageNamed:@"lp_babber1"]
                        ];
    CGFloat w = louPanHomeHeadView.bounds.size.width;
    CGFloat view_h = [UIScreen mainScreen].bounds.size.width * 218 / 375;
    CGFloat h = view_h * 0.59633;
    // 本地加载 --- 创建不带标题的图片轮播器
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, w, h) imagesGroup:images];
    
    cycleScrollView.infiniteLoop = YES;
    cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
    [louPanHomeHeadView addSubview:cycleScrollView];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, h, w, view_h - h)];
    imageView.image = [UIImage imageNamed:@"lp_about"];
    [louPanHomeHeadView addSubview:imageView];
    self.louPanHomeHeadView = louPanHomeHeadView;
    return louPanHomeHeadView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return [UIScreen mainScreen].bounds.size.width * 218 / 375;
}
/**
 *  点击cell
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 收回键盘
    [self.search resignFirstResponder];
    WXZLouPanMessageController *louPanMessage = [[WXZLouPanMessageController alloc] init];
    // 标题
    louPanMessage.navigationItem.title = [self.fysList[indexPath.row] xiaoqu];
    // 楼盘编号,楼盘号
    louPanMessage.fyhao = [self.fysList[indexPath.row] fyhao];
//    WXZLog(@"%@", louPanMessage.fyhao);
    [self.navigationController pushViewController:louPanMessage animated:YES];
    
}

#pragma mark - 键盘
// 取消键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
//    UITableView
    [self.search resignFirstResponder];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 取消键盘
    [self.search resignFirstResponder];
}
/**
 *  搜索
 */
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    // 隐藏WXZquYuListViewController.view
    self.quYuListViewVC.view.hidden = YES;
    // 取消键盘
    [self.search resignFirstResponder];
    // 根据搜索栏发送请求
    if (self.search.text.length == 0){
        [SVProgressHUD showErrorWithStatus:@"请填写小区名" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    [SVProgressHUD show];
    inp = 1;
    xiaoqu = self.search.text;
    [self networkRequestsWithInp:inp xiaoqu:xiaoqu quyu:quyu];
}
@end
