//
//  WXZquYuListViewController.m
//  rufangrongke
//
//  Created by 儒房融科 on 15/11/11.
//  Copyright © 2015年 王晓植. All rights reserved.
//

#import "WXZquYuListViewController.h"
#import "WXZquYuListViewCellModel.h"
#import "WXZquYuListViewCell.h"

@interface WXZquYuListViewController ()<UITableViewDataSource, UITableViewDelegate>
/* WXZquYuListViewCellModel */
@property (nonatomic , strong) WXZquYuListViewCellModel *quYuListViewCellModel;
@end

@implementation WXZquYuListViewController
static NSString *quYuListViewCellID = @"quyuCell";
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.tableView.backgroundColor = [UIColor clearColor];
//    [self.tableView registerClass:[WXZquYuListViewCell class] forCellReuseIdentifier:quYuListViewCellID];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WXZquYuListViewCell class]) bundle:nil] forCellReuseIdentifier:quYuListViewCellID];
//
//    // 获取沙河路径
//    NSString *cityListInfoPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingString:cityListInfoFile];
//    // 从沙河中获取城市列表
//    NSDictionary *sandBoxCityList = [NSDictionary dictionaryWithContentsOfFile:cityListInfoPath];
//    if (sandBoxCityList != nil) {
//        // 字典转模型
//        self.quYuListViewCellModel = [WXZquYuListViewCellModel objectWithKeyValues:[NSDictionary dictionaryWithContentsOfFile:cityListInfoPath]];
//        // 刷新表格
//        [self.tableView reloadData];
//    }else{// 发送请求
        NSString *url = [OutNetBaseURL stringByAppendingString:quyuliebiao];
        [[AFHTTPSessionManager manager] POST:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            WXZLog(@"%@", responseObject);
            NSDictionary *cityListDic = (NSDictionary *)responseObject;
            // 获取沙河路径
            NSString *cityListInfoPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingString:cityListInfoFile];
            // 将用户信息写入字典
            [cityListDic writeToFile:cityListInfoPath atomically:YES];
            
            // 字典转模型
            self.quYuListViewCellModel = [WXZquYuListViewCellModel objectWithKeyValues:responseObject];
            // 转模型,存储模型
//            WXZLog(@"%@", self.quYuListViewCellModel.qus);
            // 刷新表格
            [self.tableView reloadData];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            WXZLog(@"%@", error);
            // 显示失败信息
            [SVProgressHUD showErrorWithStatus:@"加载信息失败!"];
        }];

//    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

#pragma UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.quYuListViewCellModel.qus.count + 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        WXZquYuListViewCell *cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([WXZquYuListViewCell class]) owner:nil options:nil].lastObject;
        cell.cityLabel.text = @"全部区域";
        return cell;
    }else{
        WXZquYuListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"quyuCell"];
        cell.qus = self.quYuListViewCellModel.qus[indexPath.row - 1];
        return cell;
    }
}
#pragma UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    inp = 1;
    WXZquYuListViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.chooseImage.hidden = NO;
    if (indexPath.row == 0) {
        [self.delegate quYuListViewControllerDelegate:@""];
    }else{
        [self.delegate quYuListViewControllerDelegate:[self.quYuListViewCellModel.qus[indexPath.row - 1] q]];
    }
    
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WXZquYuListViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.chooseImage.hidden = YES;
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
