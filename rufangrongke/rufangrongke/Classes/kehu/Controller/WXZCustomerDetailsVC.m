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
#import "WXZKhdUserInfoCell.h"
#import "WXZGouFangYiXiangCell.h"
#import "WXZHousingDetailsCell.h"

@interface WXZCustomerDetailsVC () <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@property (nonatomic,strong) UILabel *headerTitleLabel;

@property (nonatomic,strong) UITextField *nameTextField;
@property (nonatomic,strong) UITextField *phoneNumTextField;

@end

@implementation WXZCustomerDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // 视图整体背景色
    self.view.backgroundColor = WXZRGBColor(246, 246, 246);
    self.navigationItem.title = @"客户详情";
    
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"kh_detailedit" highImage:@"" target:self action:@selector(editAction:)];
    
}

// 编辑事件
- (void)editAction:(id)sender
{
    self.nameTextField.enabled = YES;
    self.phoneNumTextField.enabled = YES;
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
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
        [userInfoCell showInfo:self.nameStr phone:self.phoneStr];
        
        return userInfoCell;
    }
    else if (indexPath.section == 1)
    {
        WXZGouFangYiXiangCell *gfyxCell = [tableView dequeueReusableCellWithIdentifier:@"GouFangYiXiangCell"];
        if (!gfyxCell)
        {
            gfyxCell = [WXZGouFangYiXiangCell initGouFangYiXiangCell];
        }
        
        return gfyxCell;
    }
    else
    {
        WXZHousingDetailsCell *hdCell = [tableView dequeueReusableCellWithIdentifier:@"HousingDetailsCell"];
        if (!hdCell)
        {
            hdCell = [WXZHousingDetailsCell initHousingDetailsCell];
        }
        
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
