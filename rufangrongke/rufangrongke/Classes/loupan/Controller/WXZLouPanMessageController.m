//
//  WXZLouPanMessageController.m
//  rufangrongke
//
//  Created by 儒房融科 on 15/10/27.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

#import "WXZLouPanMessageController.h"
#import "XMGPageView.h"
#import "AFNetworking.h"
#import <UIImageView+WebCache.h>
#import "WXZLouPanMessageCell_0_0.h"
#import "WXZLouPanMessageCell_0_1.h"
#import "WXZLouPanMessageCell_1_0.h"
#import "WXZLiandong.h"
#import "WXZXiangQingController.h"
#import "WXZMaiDianController.h"
#import "WXZLouPanBottomBar.h"
#import "WXZLouPanHuXingController.h"


@interface WXZLouPanMessageController ()<UITableViewDataSource, UITableViewDelegate, LouPanHuXingControllerDelegate>
/*轮播图片URL*/
@property(nonatomic, strong) NSArray *PicUrls;
/* 楼盘详情 */
@property (nonatomic , copy) NSDictionary *loupanxiangqingDIC;
@end

@implementation WXZLouPanMessageController


// 添加底部栏
- (void)setUpBottomBar{
    // 尺寸
    CGFloat bottomBarH = 52;
    CGFloat bottomBarW = 375;
    CGFloat bottomBarX = 0;
    CGFloat bottomBarY = 0;
    CGFloat mainViewW = self.tableView.frame.size.width;
    CGFloat mainViewH = self.tableView.frame.size.height;
    CGFloat mainScreenW = [UIScreen mainScreen].bounds.size.width;
    CGFloat mainScreenH = [UIScreen mainScreen].bounds.size.height;
    
    bottomBarH = 52 ;
    bottomBarW = 375;
    bottomBarX = 0;
    bottomBarY = mainViewH - bottomBarH;
    
    WXZLouPanBottomBar *bottomBar = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([WXZLouPanBottomBar class]) owner:nil options:nil].firstObject;
    bottomBar.frame = CGRectMake(bottomBarX, bottomBarY, bottomBarW, bottomBarH);
//    bottomBar.backgroundColor = [UIColor redColor];
    [self.tableView addSubview:bottomBar];
}
// 轮播图片 宽 / 高
static CGFloat carouselPic_width = 375;
static CGFloat carouselPic_height = 226;
/**
 *  楼盘详情初始化
 */
- (void)setUp{
    // 右边按钮
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"loupan-callout" highImage:@"kh_dianhua" target:self action:@selector(phone_click)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    CGFloat mainScreenHeight = mainScreen_height;
    CGFloat mainScreenWeight = mainScreen_width;
    // 轮播图片 宽 / 高
    CGFloat carouselPic_x = 0;
    CGFloat carouselPic_y = 0;
    CGFloat carouselPic_width = 375;
    CGFloat carouselPic_height = 226;
    CGFloat carouselPic_widthToHeigth = carouselPic_width / carouselPic_height;
    carouselPic_height = mainScreenWeight / carouselPic_widthToHeigth;
    
    // XMGPageView
    XMGPageView *pageView = [XMGPageView pageView];
    pageView.frame = CGRectMake(carouselPic_x, carouselPic_y, carouselPic_width, carouselPic_height);
    pageView.imageNames = @[@"loupan-banner", @"loupan-banner", @"loupan-banner"];
    pageView.otherColor = [UIColor grayColor];
    pageView.currentColor = [UIColor orangeColor];
    self.tableView.tableHeaderView = pageView;

    // 网络请求
    NSString *url = [OutNetBaseURL stringByAppendingString:loupanxiangqing];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"fy"] = self.fyhao;
    [[AFHTTPSessionManager manager] POST:url parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dic = (NSDictionary *)responseObject;
        
        // 刷新数据源
        [self.tableView reloadData];
//        WXZLog(@"%@", dic);
        // 将服务器返回数据存储
        self.loupanxiangqingDIC = dic;
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
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
    // 添加footView
    WXZLouPanHuXingController *vc01 = [[WXZLouPanHuXingController alloc] init];
//    vc01.view.backgroundColor = [UIColor greenColor];
    vc01.title = @"户型";
    vc01.fyhao = self.fyhao;
    // 设置户型代理
    vc01.delegate = self;
    
    WXZMaiDianController *vc02 = [[WXZMaiDianController alloc] init];
//    vc02.view.backgroundColor = [UIColor yellowColor];
    vc02.title = @"卖点";
    vc01.fyhao = self.fyhao;
    
    WXZXiangQingController *vc03 = [[WXZXiangQingController alloc] init];
//    vc03.view.backgroundColor = [UIColor purpleColor];
    vc03.title = @"详情";
    vc01.fyhao = self.fyhao;
    
    WXZLiandong *liandong = [WXZLiandong makeLiandongView:[NSMutableArray arrayWithObjects:vc01, vc02, vc03, nil]];
    liandong.backgroundColor = [UIColor clearColor];
    liandong.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 350);
    self.tableView.tableFooterView = liandong;
    
    // 添加底部栏
//    [self setUpBottomBar];
    self.navigationController.hidesBottomBarWhenPushed = NO;
    
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // 返回分组
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // 设置每组的行数
    if (section == 0)
    {
        return 2;
    }
    else
    {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 数据
    NSDictionary *dic = self.loupanxiangqingDIC[@"view"];
    
    // 设置每组的行高
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            WXZLouPanMessageCell_0_0 *Cell_0_0 = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([WXZLouPanMessageCell_0_0 class]) owner:nil options:nil] lastObject];
            // 楼盘均价
            Cell_0_0.loupanJunJia.text = [NSString stringWithFormat:@"%@元/平", dic[@"JunJia"]];;
            [Cell_0_0.loupanJunJia setTextColor:[UIColor redColor]];
            // 楼盘位置
            Cell_0_0.loupanWeiZhi.text = dic[@"WeiZhi"];
            [Cell_0_0.loupanWeiZhi setTextColor:[UIColor darkGrayColor]];
            // 楼盘收藏人数
            Cell_0_0.shouCangNum.text = [NSString stringWithFormat:@"%@", dic[@"ShouCangNum"]];
        
            return Cell_0_0;
        }else{
            WXZLouPanMessageCell_0_1 *Cell_0_1 = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([WXZLouPanMessageCell_0_1 class]) owner:nil options:nil] lastObject];
            // YiXiangKeHuNum HeZuoJJrNum ChengJiaoNum
            Cell_0_1.yixiangkehuNum.text = [NSString stringWithFormat:@"%@", dic[@"YiXiangKeHuNum"]];
            Cell_0_1.hezuojingjirenNum.text = [NSString stringWithFormat:@"%@", dic[@"HeZuoJJrNum"]];
            Cell_0_1.zuijinchengjiaoNum.text = [NSString stringWithFormat:@"%@", dic[@"ChengJiaoNum"]];
            
            return Cell_0_1;
        }
    }
    else{
        WXZLouPanMessageCell_1_0 *Cell_1_0 = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([WXZLouPanMessageCell_1_0 class]) owner:nil options:nil] lastObject];
        // YongJin 21 137 226
        Cell_1_0.yongJin.text = [NSString stringWithFormat:@"%@元/套", dic[@"YongJin"]];
        [Cell_1_0.yongJin setTextColor:[UIColor colorWithRed:21/255.0 green:137/255.0 blue:226/255.0 alpha:1.0]];
        return Cell_1_0;
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
    else
    {
        CGFloat height_1_0 = 49;
        return height_1_0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
//    return 10;
    // 返回每组的header高
    if (section == 0)
    {
        return 0;
    }
    else
    {
        return 10;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    // 返回每组的footer高
    // 返回每组的header高
    if (section == 1)
    {
        return 10;
    }
    else
    {
        return 0;
    }
}


/**
 修改sectionHeadView, sectionFootView的背景颜色
 */
static int colorNum = 215;
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(nonnull UIView *)view forSection:(NSInteger)section
{
    view.tintColor = [UIColor colorWithRed:colorNum/255.0 green:colorNum/255.0 blue:colorNum/255.0 alpha:1.0];
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section{
    view.tintColor = [UIColor colorWithRed:colorNum/255.0 green:colorNum/255.0 blue:colorNum/255.0 alpha:1.0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma LouPanHuXingControllerDelegate
- (void)louPanHuXingControllerDelegate:(UIViewController *)vc
{
    [self.navigationController pushViewController:vc animated:YES];
}



@end
