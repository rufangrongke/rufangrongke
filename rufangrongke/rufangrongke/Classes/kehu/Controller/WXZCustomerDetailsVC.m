//
//  WXZCustomerDetailsVC.m
//  rufangrongke
//
//  Created by 儒房融科 on 15/11/4.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

#import "WXZCustomerDetailsVC.h"
#import "AFNetworking.h"
#import <SVProgressHUD.h>
#import <MessageUI/MessageUI.h> //
#import "WXZKhdUserInfoCell.h"
#import "WXZGouFangYiXiangCell.h"
#import "WXZHousingDetailsCell.h"
#import "WXZAddCustomerVC.h"
#import "WXZKeHuDetailModel.h"


@interface WXZCustomerDetailsVC () <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,MFMessageComposeViewControllerDelegate,UpdateKeHuDetailInfoDelegate>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@property (nonatomic,strong) UILabel *headerTitleLabel;

@property (nonatomic,strong) UITextField *nameTextField;
@property (nonatomic,strong) UITextField *phoneNumTextField;

@property (nonatomic,strong) NSDictionary *cdDic; // 客户详情信息

@property (nonatomic,strong) WXZKeHuDetailModel *keHuDetailModel;

@end

static BOOL isRefreshDetail;

@implementation WXZCustomerDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // 视图整体背景色
    self.view.backgroundColor = WXZRGBColor(246, 246, 246);
    self.navigationItem.title = @"客户详情";
    
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    
    isRefreshDetail = NO;
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    [self customerDetailRequest:self.customerId];
}

- (void)viewWillAppear:(BOOL)animated
{
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setImage:[UIImage imageNamed:@"jt"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"jt"] forState:UIControlStateHighlighted];
    leftButton.size = CGSizeMake(70, 30);
    // 让按钮内部的所有内容左对齐
    leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    // 让按钮的内容往左边偏移10
    leftButton.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    [leftButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    // 修改导航栏左边的item
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"kh_detailedit" highImage:@"" target:self action:@selector(editAction:)];
}

#pragma mark - KeHu Detail Request
- (void)customerDetailRequest:(NSString *)cId
{
    // 详情页信息请求
    NSString *url = [OutNetBaseURL stringByAppendingString:kehuxiangqing];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:cId forKey:@"id"];
    
    [[AFHTTPSessionManager manager] POST:url parameters:param success:^(NSURLSessionDataTask *task, id responseObject)
    {
        if ([responseObject[@"ok"] integerValue] == 1)
        {
            self.cdDic = responseObject[@"kehu"];
            self.keHuDetailModel = [WXZKeHuDetailModel objectWithKeyValues:self.cdDic];
            [self.myTableView reloadData];
            [SVProgressHUD dismiss];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:responseObject[@"msg"] maskType:SVProgressHUDMaskTypeBlack];
            if ([responseObject[@"msg"] isEqualToString:@"登陆超时"])
            {
                [self goBackLoginPage]; // 回到登录页面
            }
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"请求失败" maskType:SVProgressHUDMaskTypeBlack];
    }];
}

// 代理方法
- (void)updateKeHuDetailInfo:(NSString *)customerId
{
    isRefreshDetail = YES;
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    [self customerDetailRequest:customerId];
}

// 编辑事件
- (void)editAction:(UIButton *)sender
{
    // 跳转到修改客户信息页面
    WXZAddCustomerVC *addVC = [[WXZAddCustomerVC alloc] init];
    addVC.isModifyCustomerInfo = YES;
    addVC.titleStr = @"修改客户信息";
    addVC.detailModel = self.keHuDetailModel;
    addVC.isKeHuDetail = YES;
    addVC.updateDelegate = self; // 遵循协议
    [self.navigationController pushViewController:addVC animated:YES];
}

- (void)backAction:(id)sender
{
    if (isRefreshDetail)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateKeHuInfoNotification" object:nil]; // 发送通知刷新客户首页方法
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0 || section == 1)
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
//
    if (indexPath.section == 0)
    {
        WXZKhdUserInfoCell *userInfoCell = [tableView dequeueReusableCellWithIdentifier:@"KhdUserInfoCell"];
        if (!userInfoCell)
        {
            userInfoCell = [WXZKhdUserInfoCell initKhdUserInfoCell];
            
        }
        self.nameTextField = userInfoCell.nameTextField;
        self.phoneNumTextField = userInfoCell.phoneNumTextField;
        [userInfoCell showInfo:self.cdDic[@"XingMing"] phone:self.cdDic[@"Mobile"]];
        [userInfoCell.smsBtn addTarget:self action:@selector(sendSmsAction:) forControlEvents:UIControlEventTouchUpInside];
        
        return userInfoCell;
    }
    else if (indexPath.section == 1)
    {
        WXZGouFangYiXiangCell *gfyxCell = [tableView dequeueReusableCellWithIdentifier:@"GouFangYiXiangCell"];
        if (!gfyxCell)
        {
            gfyxCell = [WXZGouFangYiXiangCell initGouFangYiXiangCell];
        }
        gfyxCell.controller = self; // 权限
        [gfyxCell updateInfo:self.cdDic];
        
        return gfyxCell;
    }
    else
    {
        WXZHousingDetailsCell *hdCell = [tableView dequeueReusableCellWithIdentifier:@"HousingDetailsCell"];
        if (!hdCell)
        {
            hdCell = [WXZHousingDetailsCell initHousingDetailsCell];
        }
        [hdCell updateInfo];
        [hdCell showInfo:self.cdDic];
        
        return hdCell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView;
    if (section == 1)
    {
        headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WXZ_ScreenWidth, 29)];
        headerView.backgroundColor = [UIColor clearColor];
        
        self.headerTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(11, 0, headerView.width-11*2, headerView.height)];
        self.headerTitleLabel.textColor = WXZRGBColor(140, 139, 139);
        self.headerTitleLabel.text = @"购房意向";
        self.headerTitleLabel.font = WXZ_SystemFont(15);
        [headerView addSubview:self.headerTitleLabel];
    }
    
    
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return 70;
    }
    else if (indexPath.section == 1)
    {
        return 68;
    }
    else
    {
        return 254;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 0.01;
    }
    else if (section == 1)
    {
        return 29;
    }
    else
    {
        return 12;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

#pragma mark - 发送短信功能
- (void)sendSmsAction:(id)sender
{
    //方法一
//        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"sms://13888888888"]];
    
    [self showMessageView:[NSArray arrayWithObjects:self.phoneNumTextField.text, nil] title:@"新信息" body:@""];
}

// 展示消息的view
- (void)showMessageView:(NSArray *)phones title:(NSString *)title body:(NSString *)body
{
    if ([MFMessageComposeViewController canSendText])
    {
        // 初始化消息控制器
        MFMessageComposeViewController *messageVC = [[MFMessageComposeViewController alloc] init];
        messageVC.recipients = phones;
        messageVC.navigationBar.tintColor = [UIColor redColor];
        messageVC.body = body;
        messageVC.messageComposeDelegate = self;
        [self presentViewController:messageVC animated:YES completion:nil];
        [[[[messageVC viewControllers] lastObject] navigationItem] setTitle:title]; // 修改短信界面标题
    }
    else
    {
//        NSLog(@"设备不支持");
        [SVProgressHUD showErrorWithStatus:@"此设备不支持发送短信"];
    }
}

#pragma mark - MFMessageComposeViewController
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissViewControllerAnimated:YES completion:nil];
    switch (result)
    {
        case MessageComposeResultSent:
        {
            NSLog(@"//信息传送成功");
//            [SVProgressHUD showErrorWithStatus:@"发送成功"];
        }
            break;
        case MessageComposeResultFailed:
        {
            NSLog(@"//信息传送失败");
            [SVProgressHUD showErrorWithStatus:@"信息传送失败"];
        }
            break;
        case MessageComposeResultCancelled:
        {
            NSLog(@"//信息被用户取消传送");
            [SVProgressHUD showErrorWithStatus:@"取消发送"];
        }
            break;
            
        default:
            break;
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
