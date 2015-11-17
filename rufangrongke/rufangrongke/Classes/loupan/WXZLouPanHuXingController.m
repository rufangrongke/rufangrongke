//
//  WXZLouPanHuXingController.m
//  rufangrongke
//
//  Created by 儒房融科 on 15/11/6.
//  Copyright © 2015年 王晓植. All rights reserved.
//

#import "WXZLouPanHuXingController.h"
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
   
//    [self.collectionView reloadData];
}

#pragma UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.hxs.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WXZLouPanHuXingCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:louPanHuXingCollectionCellID forIndexPath:indexPath];
    cell.hxs = self.hxs[indexPath.row];
//    cell.bounds = CGRectMake(0, 0, 80, 100);
//    cell.backgroundColor = [UIColor colorWithRed:arc4random_uniform(100)/100.0 green:arc4random_uniform(100)/100.0  blue:arc4random_uniform(100)/100.0  alpha:1.0];
    return cell;
}

#pragma UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    WXZLog(@"didSelectItemAtIndexPath--%zd", indexPath.row);
    WXZLouPanInformationTableViewController *InfoVC = [[WXZLouPanInformationTableViewController alloc] init];
    InfoVC.navigationItem.title = @"户型详情";
    InfoVC.huXingBianHao = [self.hxs[indexPath.row] ID];
    [self.delegate louPanHuXingControllerDelegate:InfoVC];

}

- (void)setHxs:(NSArray *)hxs
{
    _hxs = hxs;
    [self.collectionView reloadData];
}
@end
