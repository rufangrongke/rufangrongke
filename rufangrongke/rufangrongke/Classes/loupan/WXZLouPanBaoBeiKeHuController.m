//
//  WXZLouPanBaoBeiKeHuController.m
//  rufangrongke
//
//  Created by 儒房融科 on 15/11/16.
//  Copyright © 2015年 王晓植. All rights reserved.
//

#import "WXZLouPanBaoBeiKeHuController.h"
#import "WXZLouPanBaoBeiKeHuModel.h"
#import "WXZLouPanBaoBeiKeHuCell.h"

@interface WXZLouPanBaoBeiKeHuController ()
/* WXZLouPanBaoBeiKeHuModel */
@property (nonatomic , strong) WXZLouPanBaoBeiKeHuModel *louPanBaoBeiKeHuModel;
/* NSMutableArray */
@property (nonatomic , strong) NSMutableArray *listArray;
/* List */
@property (nonatomic , strong) List *list;
@end

@implementation WXZLouPanBaoBeiKeHuController

static NSString *WXZLouPanBaoBeiKeHuCellID = @"WXZLouPanBaoBeiKeHuCellID";
static NSInteger ind = 1;
/* listArray懒加载 */
- (NSMutableArray *)listArray
{
    if (_listArray == nil) {
        _listArray = [NSMutableArray array];
    }
    return _listArray;
}
- (void)setUp{
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WXZLouPanBaoBeiKeHuCell class]) bundle:nil] forCellReuseIdentifier:WXZLouPanBaoBeiKeHuCellID];
    self.tableView.rowHeight = 50;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUp];
    // 网络请求
    NSString *url = [OutNetBaseURL stringByAppendingString:kehuliebiao];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"inp"] = @(ind);
    [[AFHTTPSessionManager manager] POST:url parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        WXZLog(@"%@", responseObject);
        // 字典转模型
        self.louPanBaoBeiKeHuModel = [WXZLouPanBaoBeiKeHuModel objectWithKeyValues:responseObject];
//        WXZLog(@"%@", self.louPanBaoBeiKeHuModel.list);
        self.listArray = [NSMutableArray arrayWithArray:self.louPanBaoBeiKeHuModel.list];
        // 刷新表格
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        WXZLog(@"%@", error);
    }];
    // 刷新
    [self refresh];
}

/**
 *  上拉刷新,下拉刷新
 */
- (void)refresh{
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewUsers)];
    
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreUsers)];
}
- (void)loadNewUsers{
    ind = 1;
    NSString *url = [OutNetBaseURL stringByAppendingString:kehuliebiao];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"inp"] = @(ind);
    [[AFHTTPSessionManager manager] POST:url parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        WXZLog(@"%@", responseObject);
        // 字典转模型
        self.louPanBaoBeiKeHuModel = [WXZLouPanBaoBeiKeHuModel objectWithKeyValues:responseObject];
        self.listArray = nil;
        self.listArray = [NSMutableArray arrayWithArray:self.louPanBaoBeiKeHuModel.list];
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
- (void)loadMoreUsers{
    if (self.listArray.count < self.louPanBaoBeiKeHuModel.rowcount) {
        NSString *url = [OutNetBaseURL stringByAppendingString:kehuliebiao];
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        parameters[@"inp"] = @(ind++);
        [[AFHTTPSessionManager manager] POST:url parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
            WXZLog(@"%@", responseObject);
            // 字典转模型
            
           WXZLouPanBaoBeiKeHuModel *louPanBaoBeiKeHuModel = [WXZLouPanBaoBeiKeHuModel objectWithKeyValues:responseObject];
            [self.listArray addObjectsFromArray:louPanBaoBeiKeHuModel.list];
            WXZLog(@"listArray%zd", self.listArray.count);
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WXZLouPanBaoBeiKeHuCell *cell = [tableView dequeueReusableCellWithIdentifier:WXZLouPanBaoBeiKeHuCellID];
    cell.list = self.listArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WXZLouPanBaoBeiKeHuCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selectImageView.highlighted = YES;
    self.list = self.listArray[indexPath.row];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WXZLouPanBaoBeiKeHuCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selectImageView.highlighted = NO;
}



@end
