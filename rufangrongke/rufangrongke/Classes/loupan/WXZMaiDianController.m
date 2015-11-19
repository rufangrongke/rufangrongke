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

@interface WXZMaiDianController ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation WXZMaiDianController

static NSString *maindianCellID = @"maindianCellID";
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView reloadData];

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
        if (self.model.MaiDian) {
            cell_0.louPanMaiDianLabel.text = [NSString stringWithFormat:@"  %@", self.model.MaiDian];
        }
        return cell_0;
    }else if (indexPath.row == 1){
        WXZLouPanMaiDianCell_1 *cell_1 = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([WXZLouPanMaiDianCell_1 class]) owner:nil options:nil] lastObject];
        if (self.model.MuBiaoKeHu) {
            cell_1.muBiaoKeHuLabel.text = [NSString stringWithFormat:@"  %@", self.model.MuBiaoKeHu];
        }
        return cell_1;
    }else{
        WXZLouPanMaiDianCell_2 *cell_2 = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([WXZLouPanMaiDianCell_2 class]) owner:nil options:nil] lastObject];
        if (self.model.TuoKeJiQiao) {
            cell_2.kuoKeJiQiaoLabel.text = [NSString stringWithFormat:@"  %@", self.model.TuoKeJiQiao];
        }
        return cell_2;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88;
}

- (void)setModel:(View *)model
{
    _model = model;
//    [self.tableView reloadData];
}
@end
