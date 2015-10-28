//
//  WXZLouPanMessageController.m
//  rufangrongke
//
//  Created by 儒房融科 on 15/10/27.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

#import "WXZLouPanMessageController.h"
#import "XMGInfiniteScrollView.h"
#import "XMGPageView.h"
#import "AFNetworking.h"
#import <UIImageView+WebCache.h>
#import "WXZLouPanMessageCell_0_0.h"
#import "WXZLouPanMessageCell_0_1.h"
#import "WXZLouPanMessageCell_1_0.h"
#import "WXZLouPanMessageCell_2_0.h"

@interface WXZLouPanMessageController ()<UITableViewDataSource, UITableViewDelegate>
/*轮播图片URL*/
@property(nonatomic, strong) NSArray *PicUrls;
@end

@implementation WXZLouPanMessageController
// 轮播图片 宽 / 高
static CGFloat carouselPic_width = 375;
static CGFloat carouselPic_height = 226;
/**
 *  楼盘详情初始化
 */
- (void)setUp{
    // 右边按钮
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"loupan-callout" highImage:@"kh_dianhua" target:self action:@selector(phone_click)];
}
/**
 *  右上角打电话按钮,点击监听
 */
- (void)phone_click
{
    WXZLogFunc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 楼盘详情初始化
    [self setUp];
    // 尺寸
    // 主屏幕尺寸mainScreen_height;mainScreen_width;
//    CGFloat mainScreenHeight = mainScreen_height;
    CGFloat mainScreenWeight = mainScreen_width;
    // 轮播图片 宽 / 高
    CGFloat carouselPic_x = 0;
    CGFloat carouselPic_y = 0;
    CGFloat carouselPic_width = 375;
    CGFloat carouselPic_height = 226;
    
    CGFloat carouselPic_widthToHeigth = carouselPic_width / carouselPic_height;
    carouselPic_height = mainScreenWeight / carouselPic_widthToHeigth;
    
    // XMGInfiniteScrollView
    {
//     XMGInfiniteScrollView *scrollView = [[XMGInfiniteScrollView alloc] init];
//    scrollView.frame = CGRectMake(0, 0, 375, 226);
//    scrollView.images = @[
//                          [UIImage imageNamed:@"loupan-banner"],
//                          [UIImage imageNamed:@"loupan-banner"],
//                          [UIImage imageNamed:@"loupan-banner"],
//                          [UIImage imageNamed:@"loupan-banner"],
//                          [UIImage imageNamed:@"loupan-banner"]
//                          ];
//    scrollView.pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
//    scrollView.pageControl.pageIndicatorTintColor = [UIColor grayColor];
//    self.tableView.tableHeaderView = scrollView;
    }
    
    // XMGPageView
    XMGPageView *pageView = [XMGPageView pageView];
    pageView.frame = CGRectMake(carouselPic_x, carouselPic_y, carouselPic_width, carouselPic_height);
    pageView.imageNames = @[@"loupan-banner", @"loupan-banner", @"loupan-banner"];
    pageView.otherColor = [UIColor grayColor];
    pageView.currentColor = [UIColor orangeColor];
    //    pageView.currentColor = [UIColor blueColor];
    self.tableView.tableHeaderView = pageView;

    // 网络请求
    NSString *url = [OutNetBaseURL stringByAppendingString:loupanxiangqing];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"fy"] = self.fyhao;
    [[AFHTTPSessionManager manager] POST:url parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dic = (NSDictionary *)responseObject;
//        WXZLog(@"%@", dic);
        NSDictionary *view = dic[@"view"];
        NSArray *pics = view[@"pics"];
//        WXZLog(@"%@",pics);
        NSMutableArray *PicUrls = [NSMutableArray array];
        for (NSDictionary *dic in pics) {
            NSString *PicUrl = [picBaseULR stringByAppendingString:dic[@"PicUrl"]];
            [PicUrls addObject:PicUrl];
        }
//        WXZLog(@"%@", PicUrls);
        self.PicUrls = PicUrls;
        // 非轮播图片
        pageView.imageNames = self.PicUrls;
//        // 轮播图片
//        scrollView.images = PicUrls;
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // 返回分组
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // 设置每组的行数
    if (section == 0)
    {
        return 2;
    }
    else if (section == 1)
    {
        return 1;
    }
    else
    {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    WXZLog(@"%ld组,%ld组",indexPath.row, indexPath.section);
    
    UITableViewCell *headCell = [[UITableViewCell alloc] init];
    // 设置每组的行高
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            WXZLouPanMessageCell_0_0 *Cell_0_0 = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([WXZLouPanMessageCell_0_0 class]) owner:nil options:nil] lastObject];
            return Cell_0_0;
        }else{
            WXZLouPanMessageCell_0_1 *Cell_0_1 = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([WXZLouPanMessageCell_0_1 class]) owner:nil options:nil] lastObject];
            return Cell_0_1;
        }
    }
    else if(indexPath.section == 1)
    {
        WXZLouPanMessageCell_1_0 *Cell_1_0 = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([WXZLouPanMessageCell_1_0 class]) owner:nil options:nil] lastObject];
        return Cell_1_0;
    }else{
        WXZLouPanMessageCell_2_0 *Cell_2_0 = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([WXZLouPanMessageCell_2_0 class]) owner:nil options:nil] lastObject];
        return Cell_2_0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 设置每组的行高
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            CGFloat height_0_0 = 55;
            return height_0_0;
        }else{
            CGFloat height_0_1 = 105;
            return height_0_1;
        }
    }
    else if(indexPath.section == 1)
    {
        CGFloat height_1_0 = 49;
        return height_1_0;
    }else{
        return 220;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    // 返回每组的header高
    if (section == 0)
    {
        return 0.1;
    }
    else
    {
        return 8;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    // 返回每组的footer高
    return 0.1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    // Return the number of sections.
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete method implementation.
//    // Return the number of rows in the section.
//    return 0;
//}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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
