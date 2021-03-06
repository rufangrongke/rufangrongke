//
//  WXZWoController.m
//  rufangrongke
//
//  Created by 儒房融科 on 15/10/22.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

#import "WXZWoController.h"
#import "WXZWoInfoModel.h"
#import "WXZWoHeadCell.h"
#import "WXZWoTypeCell.h"
#import "WXZWoListCell.h"
#import "WXZPersonalController.h"
#import "WXZIRecommendCodeVC.h"

@interface WXZWoController ()<UITableViewDelegate,UITableViewDataSource> // 遵循协议

@property (weak, nonatomic) IBOutlet UITableView *myTableView; // 底层TableView

@property (nonatomic,strong) NSDictionary *woHeadInfoDic; // 关于头像，姓名等的信息字典

@property (nonatomic,strong) WXZWoInfoModel *woInfoModel; // 登录返回的信息数据模型

@end

@implementation WXZWoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // 视图整体背景色
    self.view.backgroundColor = WXZRGBColor(246, 246, 246);
//    [[UIApplication sharedApplication] setStatusBarHidden:YES]; // 隐藏状态栏
    
    // 设置数据源，遵循协议
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    
    // 获取登录缓存数据，转模型，并刷新列表数据
    self.woInfoModel = [WXZWoInfoModel objectWithKeyValues:[self localUserInfo]];
    [self.myTableView reloadData]; // 刷新列表
    
    // 注册通知，用来更新“我”界面的数据，和显示
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateWoData:) name:@"UpdateWoPage" object:nil];
}

// 隐藏状态栏
//- (BOOL)prefersStatusBarHidden
//{
//    return YES;
//}

- (void)viewWillAppear:(BOOL)animated
{
    // 隐藏导航navigation
    self.navigationController.navigationBarHidden = YES;
}

#pragma mark - Refresh Wo Info
// 刷新“我”界面数据（通知方法）
- (void)updateWoData:(NSNotification *)noti
{
    // 获取登录缓存数据，并转模型
    self.woInfoModel = [WXZWoInfoModel objectWithKeyValues:[self localUserInfo]];
    [self.myTableView reloadData]; // 刷新列表
}

#pragma mark - UITableViewDelegate/DataSource Methods
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
        return 4;
    }
    else
    {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 得到组和行数
    NSInteger secction = indexPath.section;
    NSInteger row = indexPath.row;
    
    // 通过组和行数，显示具体信息
    if (secction == 0)
    {
        if (row == 0)
        {
            // 头像cell
            static NSString *identifier = @"HeadCell";
            WXZWoHeadCell *headCell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!headCell)
            {
                headCell = [WXZWoHeadCell initHeadCell];
                headCell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            [headCell headBorder]; // 设置头像边框
            headCell.woInfoModel = self.woInfoModel;
            
            // 添加立即绑定button 响应事件
            [headCell buttonWithTarget:self withAction:@selector(immediatelyBindingAction:)];
            
            return headCell;
        }
        else
        {
            // 分类cell
            WXZWoTypeCell *typeCell = [tableView dequeueReusableCellWithIdentifier:@"WoTypeCell"];
            if (!typeCell)
            {
                typeCell = [WXZWoTypeCell initHeadCell];
                typeCell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            // 添加button 响应事件
            [typeCell buttonWithTarget:self withAction:@selector(typeAction:)];
            
            return typeCell;
        }
    }
    else
    {
        // 列表cell（section为1或2时共用 WXZWoListCell）
        WXZWoListCell *listCell = [tableView dequeueReusableCellWithIdentifier:@"WoListCell"];
        if (!listCell)
        {
            listCell = [WXZWoListCell initHeadCell];
            listCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        // 列表属于哪个组，显示不同信息
        [listCell listInfoWithSection:indexPath.section row:indexPath.row];
        
        return listCell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 设置每组的行高
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            return 269; //
        }
        else
        {
            return 77;
        }
    }
    else
    {
        return 55;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case 0:
        {
            if (indexPath.row == 0)
            {
                // 推出个人资料页面
                WXZPersonalController *personalVC = [[WXZPersonalController alloc] init];
                personalVC.woInfoModel = self.woInfoModel;
                [self.navigationController pushViewController:personalVC animated:YES];
            }
        }
            break;
        case 1:
        {
            if (indexPath.row == 0)
            {
                // 推出我的推荐码页面
                WXZIRecommendCodeVC *recommendCodeVC = [[WXZIRecommendCodeVC alloc] init];
                recommendCodeVC.headUrl = self.woInfoModel.TouXiang;
                recommendCodeVC.userName = self.woInfoModel.TrueName;
                recommendCodeVC.recommendedCodeStr = self.woInfoModel.tjm;
                [self.navigationController pushViewController:recommendCodeVC animated:YES];
            }
            else if (indexPath.row == 1)
            {
                // 推出意见反馈页面
                [SVProgressHUD showErrorWithStatus:@"此功能暂未开通，敬请期待！" maskType:SVProgressHUDMaskTypeBlack];
            }
            else if (indexPath.row == 2)
            {
                // 推出排行榜页面
                [SVProgressHUD showErrorWithStatus:@"此功能暂未开通，敬请期待！" maskType:SVProgressHUDMaskTypeBlack];
            }
            else if (indexPath.row == 3)
            {
                // 推出百问百答页面
                [SVProgressHUD showErrorWithStatus:@"此功能暂未开通，敬请期待！" maskType:SVProgressHUDMaskTypeBlack];
            }
        }
            break;
        case 2:
        {
            // 推出帮助页面
            [SVProgressHUD showErrorWithStatus:@"此功能暂未开通，敬请期待！" maskType:SVProgressHUDMaskTypeBlack];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 立即绑定事件
- (void)immediatelyBindingAction:(id)sender
{
    // 立即绑定
    
}

#pragma mark - Wo_Type Button Event
- (void)typeAction:(UIButton *)sender
{
    if (sender.tag == 100003)
    {
        // 佣金
        [SVProgressHUD showErrorWithStatus:@"此功能暂未开通，敬请期待！" maskType:SVProgressHUDMaskTypeBlack];
    }
    else if (sender.tag == 100004)
    {
        // 成交奖
        [SVProgressHUD showErrorWithStatus:@"此功能暂未开通，敬请期待！" maskType:SVProgressHUDMaskTypeBlack];
    }
    else if (sender.tag == 100005)
    {
        // 积分
        [SVProgressHUD showErrorWithStatus:@"此功能暂未开通，敬请期待！" maskType:SVProgressHUDMaskTypeBlack];
    }
    else if (sender.tag == 100006)
    {
        // 信用值
        [SVProgressHUD showErrorWithStatus:@"此功能暂未开通，敬请期待！" maskType:SVProgressHUDMaskTypeBlack];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
