//
//  WXZReportPreparationVC.m
//  rufangrongke
//
//  Created by 儒房融科 on 15/11/4.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

#import "WXZReportPreparationVC.h"
#import "AFNetworking.h"
#import "WXZPersonalCityVC.h"
#import "WXZRealEstateListCell.h"

@interface WXZReportPreparationVC () <UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *allLouPanLabel; // 所有楼盘

@property (weak, nonatomic) IBOutlet UITableView *myTableView; // 列表

@end

@implementation WXZReportPreparationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // 视图整体背景色
    self.view.backgroundColor = WXZRGBColor(246, 246, 246);
    self.navigationItem.title = @"报备楼盘";
    // tableView代理方法
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    
//    [self reportPreparationRequest];
}

- (void)viewWillAppear:(BOOL)animated
{
    // 导航栏右侧按钮
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"kh_loupanbaobeicity" highImage:@"" target:self action:@selector(cityAction:)];
}

// 进入城市页面事件
- (void)cityAction:(id)sender
{
    WXZPersonalCityVC *cityVC = [[WXZPersonalCityVC alloc] init];
    [self.navigationController pushViewController:cityVC animated:YES];
}

#pragma mark - Request
- (void)reportPreparationRequest
{
    [[AFHTTPSessionManager manager] POST:nil parameters:nil success:^(NSURLSessionDataTask *task, id responseObject)
    {
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WXZRealEstateListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RealEstateListCell"];
    if (!cell)
    {
        cell = [WXZRealEstateListCell initRealEstateListCell];
    }
    
    NSDictionary *dic = [NSDictionary dictionary];
    [cell modifyReportInfo:dic];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

// tap轻击手势，跳转到选择城市页面
- (IBAction)tapPushToCityPage:(id)sender
{
    WXZPersonalCityVC *cityVC = [[WXZPersonalCityVC alloc] init];
    cityVC.currentCity = @"";
    [self.navigationController pushViewController:cityVC animated:YES];
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
