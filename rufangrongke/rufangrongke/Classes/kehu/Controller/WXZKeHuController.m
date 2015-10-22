//
//  WXZKeHuController.m
//  rufangrongke
//
//  Created by dymost on 15/10/18.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

#import "WXZKeHuController.h"
#import "UIBarButtonItem+XMGExtension.h"
#import "DefineVariableTool.h"
#import <AFNetworking.h>
#import "WXZKeHuListCell.h"

@interface WXZKeHuController ()

@end

@implementation WXZKeHuController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WXZRGBColor(237, 237, 237);
    
    // 设置搜索框
    self.navigationItem.titleView = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    
    // 设置导航栏左右两侧的 button
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"" highImage:@"" target:self action:@selector(navLeftAction:)];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"" highImage:@"" target:self action:@selector(navRightAction:)];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

#pragma mark - Data Request Methods
- (void)request
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *url = nil;
    //        NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    //        NSURLSessionDataTask *task = [[NSURLSessionDataTask alloc] init];
    //        NSObject *obj = [[NSObject alloc] init];
    //        NSError *error = nil;
    //        [manager GET:&url parameters:parameter success:^nullable void(NSURLSessionDataTask * task, id obj) {
    //
    //        } failure:^nullable void(NSURLSessionDataTask * task, NSError * nil) {
    //
    //        }];
    //        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html", nil];
    //        manager.requestSerializer.HTTPShouldHandleCookies = YES;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WXZKeHuListCell *keHuInfoCell = [tableView dequeueReusableCellWithIdentifier:@"KeHuInfoCell"];
    
    if (!keHuInfoCell)
    {
        keHuInfoCell = [[[NSBundle mainBundle] loadNibNamed:@"WXZKeHuListCell" owner:self options:nil] lastObject];
        keHuInfoCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    // 设置底层view
    keHuInfoCell.listCellBackView.layer.cornerRadius = 6.0f;
    keHuInfoCell.listCellBackView.layer.masksToBounds = YES;
    keHuInfoCell.listCellBackView.layer.borderWidth = 1;
    keHuInfoCell.listCellBackView.layer.borderColor = [UIColor blackColor].CGColor;
    
    // 赋值
    //    keHuInfoCell.name.text = @"anan";
    
    return keHuInfoCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"click %ld row",(long)indexPath.row);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    // 添加新客户背景view
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    headerView.backgroundColor = [UIColor clearColor];
    
    // 添加新客户按钮
    UIButton *addKeHuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addKeHuBtn.frame = CGRectMake(0, 0, headerView.width, headerView.height);
    [addKeHuBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [addKeHuBtn setTitle:@"添加新客户" forState:UIControlStateNormal];
    [addKeHuBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
    [addKeHuBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    addKeHuBtn.backgroundColor = [UIColor orangeColor];
    [addKeHuBtn addTarget:self action:@selector(addNewKeHuAction:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:addKeHuBtn];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

// 添加新客户行为
- (void)addNewKeHuAction:(id)sender
{
    NSLog(@"添加新客户!");
}

#pragma mark - Navigation BarButtonItem Click Event
- (void)navLeftAction:(id)sender
{
    
}

- (void)navRightAction:(id)sender
{
    
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
