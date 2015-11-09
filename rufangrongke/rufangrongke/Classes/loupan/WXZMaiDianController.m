//
//  WXZMaiDianController.m
//  rufangrongke
//
//  Created by 儒房融科 on 15/11/4.
//  Copyright © 2015年 王晓植. All rights reserved.
//

#import "WXZMaiDianController.h"
#import <SVProgressHUD.h>
#import <MJRefresh.h>
#import <MJExtension.h>
#import <UIImageView+WebCache.h>
#import "AFNetworking.h"
#import "WXZLouPanMaiDianCell.h"
#import "WXZLouPanMaiDianCell.h"
#import "WXZLouPanMaiDianCell_1.h"
#import "WXZLouPanMaiDianCell_2.h"
#import "WXZLouPanMaiDianModel.h"

@interface WXZMaiDianController ()<UITableViewDataSource, UITableViewDelegate>
/* WXZLouPanMaiDianModel */
@property (nonatomic , strong) WXZLouPanMaiDianModel *louPanMaiDianModel;

@end

@implementation WXZMaiDianController

static NSString *maindianCellID = @"maindianCellID";
- (void)viewDidLoad {
    [super viewDidLoad];
    // 1.创建请求对象
    NSString *urlString = [OutNetBaseURL stringByAppendingString:loupanxiangqing];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"fy"] = self.fyhao;
    // afn
    [[AFHTTPSessionManager manager] POST:urlString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dic = (NSDictionary *)responseObject;
//        NSLog(@"%@", dic);
        self.louPanMaiDianModel = [WXZLouPanMaiDianModel objectWithKeyValues:dic[@"view"]];
        [self.tableView reloadData];
        // 4.回到主线程
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//            if ([loginContentDic[@"ok"] isEqualToNumber:@1]) { // 正确登陆
//                // 隐藏HUD
//                [SVProgressHUD dismiss];
//                
//            }else{ //登陆失败
//                [SVProgressHUD showErrorWithStatus:@"用户名或者密码错误" maskType:SVProgressHUDMaskTypeBlack];
//            }
            
        }];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//            [SVProgressHUD showErrorWithStatus:@"登陆超时,请重新登陆." maskType:SVProgressHUDMaskTypeBlack];
        }];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        WXZLouPanMaiDianCell *cell_0 = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([WXZLouPanMaiDianCell class]) owner:nil options:nil] lastObject];
        cell_0.louPanMaiDianLabel.text = [NSString stringWithFormat:@"  %@", self.louPanMaiDianModel.MaiDian];
        return cell_0;
    }else if (indexPath.row == 1){
        WXZLouPanMaiDianCell_1 *cell_1 = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([WXZLouPanMaiDianCell_1 class]) owner:nil options:nil] lastObject];
        cell_1.muBiaoKeHuLabel.text = [NSString stringWithFormat:@"  %@", self.louPanMaiDianModel.MuBiaoKeHu];
        return cell_1;
    }else{
        WXZLouPanMaiDianCell_2 *cell_2 = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([WXZLouPanMaiDianCell_2 class]) owner:nil options:nil] lastObject];
        cell_2.kuoKeJiQiaoLabel.text = [NSString stringWithFormat:@"  %@", self.louPanMaiDianModel.TuoKeJiQiao];
        return cell_2;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88;
}
@end
