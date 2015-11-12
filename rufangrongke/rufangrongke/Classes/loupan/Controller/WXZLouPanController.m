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

@interface WXZLouPanController ()<UITableViewDataSource, UITableViewDelegate>
/** 楼盘模型字典 */
@property (nonatomic, strong) WXZLouPan *loupanModel;

@property (nonatomic, strong) UISearchBar *search;

/* 缓存list数据 */
/* fys */
@property (nonatomic , strong) NSMutableArray *fysList;
@end

@implementation WXZLouPanController

static NSString * const WXZLoupanCellID = @"loupanleibiaoCell";
static NSInteger listCount = 1;
/* fysList懒加载 */
- (NSMutableArray *)fysList
{
    if (_fysList == nil) {
        _fysList = [NSMutableArray array];
    }
    return _fysList;
}
#pragma 初始化项目
- (void)setUp{
    // 去除分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 设置导航栏左边按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"lp_quyutu" highImage:@"lp_quyutu" target:self action:@selector(quYu_click)];
    // 设置导航栏右边按钮
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"lp_qd" highImage:@"lp_qd" target:self action:@selector(queDing_click)];
    // 添加一个系统的搜索框
    UISearchBar *search = [[UISearchBar alloc]init];
    search.placeholder = @"楼盘搜索";
    self.navigationItem.titleView = search;
    self.search = search;

    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WXZTableViewCell class]) bundle:nil] forCellReuseIdentifier:WXZLoupanCellID];
    // cell高度
    self.tableView.rowHeight = 100;
    // 给tableview添加点击 为了取消键盘
//    [self.tableView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickTableView:)]];
}
- (void)clickTableView:(UITapGestureRecognizer *)tap{
    WXZLogFunc;
    // 取消键盘
    [self.search resignFirstResponder];
}
/**
 *  右上方按钮监听点击
 */
- (void)queDing_click{
    WXZLogFunc;
    // 取消键盘
    [self.search resignFirstResponder];
    // 根据搜索栏发送请求
    if (self.search.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请填写小区名" maskType:SVProgressHUDMaskTypeBlack];
    }else{
        // 发送请求
        NSString *url = [OutNetBaseURL stringByAppendingString:loupanliebiao];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"xiaoqu"] = self.search.text;
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
}

/**
 *  左上方按钮监听点击
 */
- (void)quYu_click{
    // 取消键盘
    [self.search resignFirstResponder];
    
}

#pragma 刷新控件
/**
 * 添加刷新控件
 */
- (void)setupRefresh
{
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewUsers)];
    
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreUsers)];
//    self.tableView.footer.hidden = YES;
}
- (void)loadNewUsers
{
    // 发送请求
    NSString *url = [OutNetBaseURL stringByAppendingString:loupanliebiao];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"inp"] = @(1);
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
        // 发送请求
        NSString *url = [OutNetBaseURL stringByAppendingString:loupanliebiao];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"inp"] = @(++listCount);
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

- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化信息
    [self setUp];
    // 添加刷新控件
    [self setupRefresh];
    
    // 显示指示器
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    
    // 发送请求
    NSString *url = [OutNetBaseURL stringByAppendingString:loupanliebiao];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"inp"] = @(listCount);
    [[AFHTTPSessionManager manager] POST:url parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
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

#pragma mark - <UITableViewDataSource>
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


/**
 *  点击cell
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WXZLouPanMessageController *louPanMessage = [[WXZLouPanMessageController alloc] init];
    // 标题
    louPanMessage.navigationItem.title = [self.fysList[indexPath.row] xiaoqu];
    // 楼盘编号,楼盘号
    louPanMessage.fyhao = [self.fysList[indexPath.row] fyhao];
//    WXZLog(@"%@", louPanMessage.fyhao);
    [self.navigationController pushViewController:louPanMessage animated:YES];
    
}

#pragma 取消键盘
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

//- sc
@end
