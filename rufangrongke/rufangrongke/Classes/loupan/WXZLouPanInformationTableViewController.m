//
//  WXZLouPanInformationTableViewController.m
//  rufangrongke
//
//  Created by 儒房融科 on 15/11/9.
//  Copyright © 2015年 王晓植. All rights reserved.
//

#import "WXZLouPanInformationTableViewController.h"
#import "WXZLouPanInformationControllerModel.h"

@interface WXZLouPanInformationTableViewController ()
/* 模型数组 */
@property (nonatomic , strong) WXZLouPanInformationControllerModel *louPanInformationControllerModel;

@end

@implementation WXZLouPanInformationTableViewController

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
        WXZLog(@"%@", hxview);
        [WXZLouPanInformationControllerModel setupObjectClassInArray:^NSDictionary *{
            return @{
                     @"others" : @"OthersModel",
                     // @"others" : [OthersModel class],
                     };
        }];
        
        self.louPanInformationControllerModel = [WXZLouPanInformationControllerModel objectWithKeyValues:hxview];
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
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"WXZLouPanInformationControllerCell"];
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
    //    self.view.tableHeaderView = image;
    
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
        return 2;
    }else{
        return 4;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WXZLouPanInformationControllerCell" forIndexPath:indexPath];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%zd -- %zd", indexPath.section, indexPath.row];
    
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
