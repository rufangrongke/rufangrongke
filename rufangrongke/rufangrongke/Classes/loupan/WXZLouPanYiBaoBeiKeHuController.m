//
//  WXZLouPanYiBaoBeiKeHuController.m
//  rufangrongke
//
//  Created by 儒房融科 on 15/11/16.
//  Copyright © 2015年 王晓植. All rights reserved.
//

#import "WXZLouPanYiBaoBeiKeHuController.h"
#import "WXZLouPanYiBaoBeiKeHuModel.h"
#import "WXZLouPanYiBaoBeiKeHuCell.h"

@interface WXZLouPanYiBaoBeiKeHuController ()
/* LouPanYiBaoBeiKeHuModel */
@property (nonatomic , strong) WXZLouPanYiBaoBeiKeHuModel *louPanYiBaoBeiKeHuModel;
@end

@implementation WXZLouPanYiBaoBeiKeHuController
static NSString *WXZLouPanYiBaoBeiKeHuCellID = @"WXZLouPanYiBaoBeiKeHuCellID";

- (void)setUp{
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WXZLouPanYiBaoBeiKeHuCell class]) bundle:nil] forCellReuseIdentifier:WXZLouPanYiBaoBeiKeHuCellID];
    self.tableView.rowHeight = 50;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [SVProgressHUD show];
    // 初始化
    [self setUp];
    // 网络请求
    NSString *url = [OutNetBaseURL stringByAppendingString:loupanshangbaobeidekehu];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"fyhao"] = self.fyhao;
    [[AFHTTPSessionManager manager] POST:url parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        WXZLog(@"%@", responseObject);
        // 字典转模型
        self.louPanYiBaoBeiKeHuModel = [WXZLouPanYiBaoBeiKeHuModel objectWithKeyValues:responseObject];
        WXZLog(@"%@", self.louPanYiBaoBeiKeHuModel.ls);
        [SVProgressHUD dismiss];
        // 刷新表格
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        WXZLog(@"%@", error);
        [SVProgressHUD showErrorWithStatus:@"请检查您的网络" maskType:SVProgressHUDMaskTypeBlack];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.louPanYiBaoBeiKeHuModel.ls.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WXZLouPanYiBaoBeiKeHuCell *cell = [tableView dequeueReusableCellWithIdentifier:WXZLouPanYiBaoBeiKeHuCellID];
    cell.ls = self.louPanYiBaoBeiKeHuModel.ls[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
