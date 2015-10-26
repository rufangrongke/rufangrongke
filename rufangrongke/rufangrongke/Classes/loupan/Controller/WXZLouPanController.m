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

@interface WXZLouPanController ()
/** 所有团购数据 */
@property (nonatomic, strong) NSArray *loupanLeibiaoS;

@end

@implementation WXZLouPanController

static NSString * const WXZLoupanCellID = @"loupanleibiaoCell";

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
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"lp_quyutu" highImage:@"lp_quyutu" target:self action:@selector(quDu_click)];
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
    // 初始化信息
    [self setUp];
    
    self.tableView.height = 120;
    
    // 注册
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WXZTableViewCell class]) bundle:nil] forCellReuseIdentifier:WXZLoupanCellID];
    
    // 显示指示器
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    
    // 发送请求
    NSString *url = [OutNetBaseURL stringByAppendingString:loupanliebiao];
//    WXZLog(@"%@", url);
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"inp"] = @1;
    [[AFHTTPSessionManager manager] POST:url parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        // 隐藏指示器
        [SVProgressHUD dismiss];
        
//        WXZLog(@"%@", responseObject);
        // 服务器返回的JSON数据
        self.loupanLeibiaoS = [WXZLouPan objectArrayWithKeyValuesArray:responseObject[@"fys"]];

        WXZLouPan *loupan =self.loupanLeibiaoS[0];
        WXZLog(@"%@", loupan.PicUrl);
        // 刷新表格
        [self.tableView reloadData];
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        // 显示失败信息
        [SVProgressHUD showErrorWithStatus:@"加载推荐信息失败!"];
    }];
}

#pragma mark - <UITableViewDataSource>
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return self.loupanLeibiaoS.count;
//}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    WXZTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:WXZLoupanCellID];
//    
////    cell.loupan = self.loupanLeibiaoS[indexPath.row];
////    NSLog(@"%@", self.loupanLeibiaoS[indexPath.row]);
//    
//    return cell;
//}



@end
