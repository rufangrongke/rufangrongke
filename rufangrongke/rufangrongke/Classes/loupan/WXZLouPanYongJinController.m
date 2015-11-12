//
//  WXZLouPanYongJinController.m
//  rufangrongke
//
//  Created by 儒房融科 on 15/11/9.
//  Copyright © 2015年 王晓植. All rights reserved.
//

#import "WXZLouPanYongJinController.h"
#import "WXZLouPanYongJinModel.h"
#import "WXZLouPanYongJinCell_0.h"
#import "WXZLouPanYongJinCell_1.h"
#import "WXZLouPanYongJinSectionHeadView_0.h"
#import "WXZLouPanYongJinSectionHeadView_1.h"

@interface WXZLouPanYongJinController ()
/* 模型数组 */
@property (nonatomic , strong) WXZLouPanYongJinModel *louPanYongJinModel;
@end

@implementation WXZLouPanYongJinController

/**
 * 初始化
 */
- (void)setUp{
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.navigationItem.title = @"楼盘佣金";
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // 楼盘详情初始化
    [self setUp];
    
    // 1.创建请求对象
    NSString *urlString = [OutNetBaseURL stringByAppendingString:yongjinliebiao];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"fy"] = self.fyhao;
    WXZLog(@"%@", self.fyhao);
    // afn
    [[AFHTTPSessionManager manager] POST:urlString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        WXZLog(@"%@", responseObject);
        [WXZLouPanYongJinModel setupObjectClassInArray:^NSDictionary *{
            return @{
                     @"list" : @"ListYongJin",
                     @"KFSgz" : @"KfsgzYongjin",
                     };
        }];
        
        self.louPanYongJinModel = [WXZLouPanYongJinModel objectWithKeyValues:responseObject];
        WXZLog(@"%@", self.louPanYongJinModel);
        // 刷新表格
        [self.tableView reloadData];
        //        WXZLog(@"%@", self.louPanInformationControllerModel.others);
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        if (self.louPanYongJinModel.list.count == 0) {
            return 1;
        }else{
            return self.louPanYongJinModel.list.count;
        }
    }else{
        return 1;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        WXZLouPanYongJinCell_0 *cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([WXZLouPanYongJinCell_0 class]) owner:nil options:nil].lastObject;
        if (self.louPanYongJinModel.list.count != 0) {
            cell.listYongJin = self.louPanYongJinModel.list[indexPath.row];
        }
        
        return cell;
    }else{
        WXZLouPanYongJinCell_1 *cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([WXZLouPanYongJinCell_1 class]) owner:nil options:nil].lastObject;
        
        cell.kfsgzYongjin = self.louPanYongJinModel.KFSgz;
        
        return cell;
    }

}
/**
 *  行高
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 144;
    
}
/**
 *  行高
 */
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        UIView *view = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([WXZLouPanYongJinSectionHeadView_0 class]) owner:nil options:nil].lastObject;
        return view;
    }else{
        UIView *view = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([WXZLouPanYongJinSectionHeadView_1 class]) owner:nil options:nil].lastObject;
        return view;
    }
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
