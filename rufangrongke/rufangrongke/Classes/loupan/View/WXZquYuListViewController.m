//
//  WXZquYuListViewController.m
//  rufangrongke
//
//  Created by 儒房融科 on 15/11/11.
//  Copyright © 2015年 王晓植. All rights reserved.
//

#import "WXZquYuListViewController.h"
#import "WXZquYuListViewCellModel.h"

@interface WXZquYuListViewController ()<UITableViewDataSource, UITableViewDelegate>
/* WXZquYuListViewCellModel */
@property (nonatomic , strong) WXZquYuListViewCellModel *quYuListViewCellModel;
@end

@implementation WXZquYuListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"quyuCell"];

     // 发送请求
     NSString *url = [OutNetBaseURL stringByAppendingString:quyuliebiao];
     [[AFHTTPSessionManager manager] POST:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
         self.quYuListViewCellModel = [WXZquYuListViewCellModel objectWithKeyValues:responseObject];
     // 转模型,存储模型
     WXZLog(@"%@", self.quYuListViewCellModel.qus);
     // 刷新表格
     [self.tableView reloadData];
     } failure:^(NSURLSessionDataTask *task, NSError *error) {
     WXZLog(@"%@", error);
     // 显示失败信息
     [SVProgressHUD showErrorWithStatus:@"加载信息失败!"];
     }];
    
     
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

#pragma UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.quYuListViewCellModel.qus.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"quyuCell"];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", [self.quYuListViewCellModel.qus[indexPath.row] q]];
    return cell;
}
#pragma UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate quYuListViewControllerDelegate:[self.quYuListViewCellModel.qus[indexPath.row] q]];
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
