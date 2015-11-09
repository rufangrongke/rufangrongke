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
#import "WXZLoupanCell.h"
#import "WXZLouPanMessageController.h"

@interface WXZLouPanController ()<UITableViewDataSource, UITableViewDelegate>
/** 楼盘模型字典 */
@property (nonatomic, strong) NSArray *loupanLeibiaoS;

@property (nonatomic, strong) UISearchBar *search;
@end

@implementation WXZLouPanController

static NSString * const WXZLoupanCellID = @"loupanleibiaoCell";

#pragma 初始化项目
- (void)setUp{
    // 去除分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"lp_quyutu" highImage:@"lp_quyutu" target:self action:@selector(quYu_click)];
    // 右边按钮
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"lp_qd" highImage:@"lp_qd" target:self action:@selector(queDing_click)];
    // 添加一个系统的搜索框
    UISearchBar *search = [[UISearchBar alloc]init];
    search.placeholder = @"楼盘搜索";
    self.navigationItem.titleView = search;
    self.search = search;

}

/**
 *  右上方按钮监听点击
 */
- (void)queDing_click{
//    WXZLogFunc;
    WXZLog(@"%@", [self localUserInfo]);
    // 取消键盘
    [self.search resignFirstResponder];
}

/**
 *  左上方按钮监听点击
 */
- (void)quYu_click{
//    WXZLogFunc;
    WXZLog(@"%@", [self localUserInfo]);
    // 取消键盘
    [self.search resignFirstResponder];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化信息
    [self setUp];
    
    self.tableView.rowHeight = 100;
    
    // 注册
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WXZTableViewCell class]) bundle:nil] forCellReuseIdentifier:WXZLoupanCellID];
    
    // 显示指示器
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    
    // 发送请求
    NSString *url = [OutNetBaseURL stringByAppendingString:loupanliebiao];
//    WXZLog(@"%@", url); // 测试
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"inp"] = @1;
    [[AFHTTPSessionManager manager] POST:url parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        // 隐藏指示器
        [SVProgressHUD dismiss];
        
//        WXZLog(@"%@", responseObject);
        // 服务器返回的JSON数据
        self.loupanLeibiaoS = [WXZLouPan objectArrayWithKeyValuesArray:responseObject[@"fys"]];
//        NSLog(@"%@", self.loupanLeibiaoS);
//        WXZLouPan *loupan =self.loupanLeibiaoS[0];
//        WXZLog(@"%@", loupan.YiXiangKeHuNum);
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
    return self.loupanLeibiaoS.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WXZTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:WXZLoupanCellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    NSLog(@"%@", self.loupanLeibiaoS[indexPath.row]);
    cell.loupan = self.loupanLeibiaoS[indexPath.row];
    
    return cell;
}


/**
 *  点击cell
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WXZLouPanMessageController *louPanMessage = [[WXZLouPanMessageController alloc] init];
    // 标题
    louPanMessage.navigationItem.title = [self.loupanLeibiaoS[indexPath.row] xiaoqu];
    // 楼盘编号,楼盘号
    louPanMessage.fyhao = [self.loupanLeibiaoS[indexPath.row] fyhao];
    WXZLog(@"%@", louPanMessage.fyhao);
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
@end
