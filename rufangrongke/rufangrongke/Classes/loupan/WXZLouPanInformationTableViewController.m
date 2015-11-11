//
//  WXZLouPanInformationTableViewController.m
//  rufangrongke
//
//  Created by 儒房融科 on 15/11/9.
//  Copyright © 2015年 王晓植. All rights reserved.
//

#import "WXZLouPanInformationTableViewController.h"
#import "WXZLouPanInformationControllerModel.h"
#import "WXZLouPanInformationControllerCell_0_0.h"
#import "WXZLouPanInformationControllerCell_0_1.h"
#import "WXZLouPanInformationControllerCell_1_0.h"
#import "WXZLouPanInformationControllerCell_1_1.h"
#import "WXZLouPanInformationControllerCell_1_2.h"
#import "WXZLouPanInformationControllerCell_1_3.h"
#import "WXZLouPanInfoVC_footTableView_footView.h"
#import "WXZLouPanInfoVC_footTableView_Cell.h"
#import "WXZLouPanInfoVC_footTableView_Cell_2_0.h"

@interface WXZLouPanInformationTableViewController ()
/* 模型数组 */
@property (nonatomic , strong) WXZLouPanInformationControllerModel *louPanInformationControllerModel;

/* 其他户型数组 */
@property (nonatomic , strong) NSArray *othersArray;

/* footTableView */
@property (nonatomic , strong) UITableView *footTableView;
@end

@implementation WXZLouPanInformationTableViewController
static NSString *WXZLouPanInfoVC_footTableView_Cell_ID = @"WXZLouPanInfoVC_footTableView_Cell";
- (void)viewDidLoad {
    [super viewDidLoad];
    // 楼盘详情初始化
    [self setUp];
    
    // 1.创建请求对象
    NSString *urlString = [OutNetBaseURL stringByAppendingString:huxingxiangqing];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"hxid"] = self.huXingBianHao;
    // afn
    [[AFHTTPSessionManager manager] POST:urlString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dic = (NSDictionary *)responseObject;
        NSDictionary *hxview = dic[@"hxview"];
//        WXZLog(@"%@", hxview);
        [WXZLouPanInformationControllerModel setupObjectClassInArray:^NSDictionary *{
            return @{
                     @"others" : @"OthersModel",
                     // @"others" : [OthersModel class],
                     };
        }];
        
        self.louPanInformationControllerModel = [WXZLouPanInformationControllerModel objectWithKeyValues:hxview];
        
        // 刷新表格
        [self.tableView reloadData];
//        WXZLog(@"%@", self.louPanInformationControllerModel.others);
        // 4.回到主线程
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            // 加载headView
            [self setUpHeadImageView:self.louPanInformationControllerModel.pic];
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
/**
 * 初始化
 */
- (void)setUp{
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 注册cell
//    [self.tableView registerClass:[WXZLouPanInfoVC_footTableView_Cell class] forCellReuseIdentifier:@"WXZLouPanInfoVC_footTableView_Cell"];
}
/**
 * 加载headView
 */
- (void)setUpHeadImageView:(NSString *)picUrlString
{
    //    // 尺寸
    //    // 主屏幕尺寸mainScreen_height;mainScreen_width;
    //    CGFloat mainScreenHeight = mainScreen_height;
    //    CGFloat mainScreenWeight = mainScreen_width;
    //    // 轮播图片 宽 / 高
    //    CGFloat carouselPic_x = 0;
    //    CGFloat carouselPic_y = 0;
    //    CGFloat carouselPic_width = 375;
    //    CGFloat carouselPic_height = 273;
    //    CGFloat carouselPic_widthToHeigth = carouselPic_width / carouselPic_height;
    //    carouselPic_height = mainScreenWeight / carouselPic_widthToHeigth;
    
    //HeadImageView
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loupan-banner"]];
    [image sd_setImageWithURL:[NSURL URLWithString:[picBaseULR stringByAppendingString:picUrlString]] placeholderImage:[UIImage imageNamed:@"loupan-banner"]];
    
    self.tableView.tableHeaderView = image;
    
}
/**
 *  添加footTableView
 */
- (void)setUpfootTableView:(WXZLouPanInformationControllerModel *)model{
    UITableView *footTableView = [[UITableView alloc] init];
    footTableView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 200);
    footTableView.delegate = self;
//    footTableView.backgroundColor = [UIColor redColor];
    // headView
    UIView *view = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([WXZLouPanInfoVC_footTableView_footView class]) owner:nil options:nil].lastObject;
    view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 30);
    footTableView.tableHeaderView = view;
    self.tableView.tableFooterView = footTableView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 2;
    }else if (section == 1){
        return 4;
    }else if (section == 2){
        return 1;
    }else{
        return self.louPanInformationControllerModel.others.count;
    }
}

/*
 WXZLouPanInfoVC_footTableView_Cell *cell = [tableView dequeueReusableCellWithIdentifier:WXZLouPanInfoVC_footTableView_Cell_ID forIndexPath:indexPath];
 cell.footTableView_Cell_Model = self.louPanInformationControllerModel.others[indexPath.row];
 return cell;
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            WXZLouPanInformationControllerCell_0_0 *cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([WXZLouPanInformationControllerCell_0_0 class]) owner:nil options:nil].lastObject;
            
            cell.model_0_0 = self.louPanInformationControllerModel;
            
            return cell;
        }else{
            WXZLouPanInformationControllerCell_0_1 *cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([WXZLouPanInformationControllerCell_0_1 class]) owner:nil options:nil].lastObject;
            
            cell.model_0_1 = self.louPanInformationControllerModel;
            
            return cell;
        }
        
    }else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            WXZLouPanInformationControllerCell_1_0 *cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([WXZLouPanInformationControllerCell_1_0 class]) owner:nil options:nil].lastObject;
            
            cell.model_1_0 = self.louPanInformationControllerModel;
            
            
            return cell;
        }else if (indexPath.row == 1) {
            WXZLouPanInformationControllerCell_1_1 *cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([WXZLouPanInformationControllerCell_1_1 class]) owner:nil options:nil].lastObject;
            
            cell.model_1_1 = self.louPanInformationControllerModel;
            
            return cell;
        }else if (indexPath.row == 2) {
            WXZLouPanInformationControllerCell_1_2 *cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([WXZLouPanInformationControllerCell_1_2 class]) owner:nil options:nil].lastObject;
            
            cell.model_1_2 = self.louPanInformationControllerModel;
            
            return cell;
        }else{
            WXZLouPanInformationControllerCell_1_3 *cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([WXZLouPanInformationControllerCell_1_3 class]) owner:nil options:nil].lastObject;
            
            cell.model_1_3 = self.louPanInformationControllerModel;
            
            return cell;
        }
    }else if (indexPath.section == 2){
        WXZLouPanInfoVC_footTableView_Cell_2_0 *cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([WXZLouPanInfoVC_footTableView_Cell_2_0 class]) owner:nil options:nil].lastObject;
        return cell;
    }else{
        WXZLouPanInfoVC_footTableView_Cell *cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([WXZLouPanInfoVC_footTableView_Cell class]) owner:nil options:nil].lastObject;;
        cell.footTableView_Cell_Model = self.louPanInformationControllerModel.others[indexPath.row];
        return cell;
    }
    
}

/**
 *  行高
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 3)
    {
        return 75;
    }
    else if (indexPath.section == 2)
    {
        return 30;
    }else if (indexPath.section == 1 && indexPath.row == 3)
    {
        return 55;
    }else{
        return 45;
    }
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    // 返回每组的footer高
    // 返回每组的header高
    if (section == 2)
    {
        return 0;
    }
    else
    {
        return 10;
    }
}
/**
 修改sectionHeadView, sectionFootView的背景颜色
 */
static int colorNum = 235;
- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section{
    view.tintColor = [UIColor colorWithRed:colorNum/255.0 green:colorNum/255.0 blue:colorNum/255.0 alpha:1.0];
}

/**
 *  点击cell
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 3) {
//        WXZLouPanInformationTableViewController *infoVc = [[WXZLouPanInformationTableViewController alloc] init];
//        // 标题
//        infoVc.title = @"户型详情";
//        infoVc.huXingBianHao = [self.louPanInformationControllerModel.others[indexPath.row] ID];
        [self openNewLouPanInfoVC:[self.louPanInformationControllerModel.others[indexPath.row] ID]];
//        [self.navigationController pushViewController:infoVc animated:YES];
    }
    
    
}

- (void)openNewLouPanInfoVC:(NSString *)fyhao
{
    // 楼盘详情初始化
    [self setUp];
    
    // 1.创建请求对象
    NSString *urlString = [OutNetBaseURL stringByAppendingString:huxingxiangqing];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"hxid"] = fyhao;
    [SVProgressHUD show];
    // afn
    [[AFHTTPSessionManager manager] POST:urlString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dic = (NSDictionary *)responseObject;
        NSDictionary *hxview = dic[@"hxview"];
        //        WXZLog(@"%@", hxview);
        [WXZLouPanInformationControllerModel setupObjectClassInArray:^NSDictionary *{
            return @{
                     @"others" : @"OthersModel",
                     // @"others" : [OthersModel class],
                     };
        }];
        
        self.louPanInformationControllerModel = [WXZLouPanInformationControllerModel objectWithKeyValues:hxview];
        
        // 刷新表格
        [self.tableView reloadData];
        //        WXZLog(@"%@", self.louPanInformationControllerModel.others);
        // 4.回到主线程
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            // 加载headView
            [self setUpHeadImageView:self.louPanInformationControllerModel.pic];
            //            if ([loginContentDic[@"ok"] isEqualToNumber:@1]) { // 正确登陆
            //                // 隐藏HUD
                            [SVProgressHUD dismiss];
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
