//
//  WXZLouPanHuXingController.m
//  rufangrongke
//
//  Created by 儒房融科 on 15/11/6.
//  Copyright © 2015年 王晓植. All rights reserved.
//

#import "WXZLouPanHuXingController.h"
#import "WXZLouPanHuXingModel.h"
#import "WXZLouPanHuXingCollectionCell.h"
#import <SVProgressHUD.h>
#import <MJRefresh.h>
#import <MJExtension.h>
#import <UIImageView+WebCache.h>
#import "AFNetworking.h"
#import "WXZLouPanInformationTableViewController.h"

@interface WXZLouPanHuXingController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
/* 户型数组 */
@property (nonatomic , copy) NSArray *louPanHuXingModelArray;
@end

@implementation WXZLouPanHuXingController

static NSString *louPanHuXingCollectionCellID = @"WXZLouPanHuXingCollectionCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // 修改父控件高度
//    CGRect frame = self.view.superview.frame;
//    frame.size.height = self.view.frame.size.height;
//    self.view.superview.frame = frame;
    
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([WXZLouPanHuXingCollectionCell class]) bundle:nil] forCellWithReuseIdentifier:louPanHuXingCollectionCellID];
    
    // 请求数据
    // 1.创建请求对象
    NSString *urlString = [OutNetBaseURL stringByAppendingString:loupanxiangqing];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"fy"] = self.fyhao;
    // afn
    [[AFHTTPSessionManager manager] POST:urlString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dic = (NSDictionary *)responseObject;
//        WXZLog(@"%@", dic);
        NSDictionary *dicView = dic[@"view"];
        self.louPanHuXingModelArray = [WXZLouPanHuXingModel objectArrayWithKeyValuesArray:dicView[@"hxs"]];
//        WXZLog(@"%@", self.louPanHuXingModelArray);
        [self.collectionView reloadData];
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

#pragma UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.louPanHuXingModelArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WXZLouPanHuXingCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:louPanHuXingCollectionCellID forIndexPath:indexPath];
    cell.louPanHuXingModel = self.louPanHuXingModelArray[indexPath.row];
//    cell.backgroundColor = [UIColor colorWithRed:arc4random_uniform(100)/100.0 green:arc4random_uniform(100)/100.0  blue:arc4random_uniform(100)/100.0  alpha:1.0];
    return cell;
}

#pragma UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    WXZLog(@"didSelectItemAtIndexPath--%zd", indexPath.row);
    WXZLouPanInformationTableViewController *InfoVC = [[WXZLouPanInformationTableViewController alloc] init];
    InfoVC.navigationItem.title = @"户型详情";
    InfoVC.huXingBianHao = [self.louPanHuXingModelArray[indexPath.row] ID];
//    WXZLog(@"%@", [self.louPanHuXingModelArray[indexPath.row] pic]);
//    NSLog(@"%@", [self.louPanHuXingModelArray[indexPath.row] id]);
//    [self.navigationController pushViewController:InfoVC animated:YES];
    [self.delegate louPanHuXingControllerDelegate:InfoVC];

}
@end
