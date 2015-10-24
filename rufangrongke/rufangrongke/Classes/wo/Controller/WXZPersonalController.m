//
//  WXZPersonalController.m
//  rufangrongke
//
//  Created by 儒房融科 on 15/10/24.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

#import "WXZPersonalController.h"
#import "WXZPersonalDataCell.h"
#import "WXZPersonalData2Cell.h"

@interface WXZPersonalController () <UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end

@implementation WXZPersonalController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // 视图整体背景色
    self.view.backgroundColor = WXZRGBColor(246, 246, 246);
    self.navigationItem.title = @"个人资料";
    
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    // 隐藏导航navigation
    self.navigationController.navigationBarHidden = NO;
    
    // 返回按钮
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 40, 44);
    [leftBtn setImage:[UIImage imageNamed:@"kh_rjt"] forState:UIControlStateNormal];
    leftBtn.transform = CGAffineTransformMakeRotation(M_PI); // 图片旋转d
    [leftBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)]; // 标题向左侧偏移
    [leftBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
}

- (void)backAction:(id)sender
{
    NSLog(@"返回");
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Delegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 11;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        WXZPersonalDataCell *personalDataCell = [tableView dequeueReusableCellWithIdentifier:@"PersonalDataCell"];
        if (!personalDataCell)
        {
            personalDataCell = [WXZPersonalDataCell initPersonalDataCell];
            [personalDataCell headBorder];
        }
        
        return personalDataCell;
    }
    else
    {
        WXZPersonalData2Cell *personalData2Cell = [tableView dequeueReusableCellWithIdentifier:@"PersonalDataCell2"];
        if (!personalData2Cell)
        {
            personalData2Cell = [WXZPersonalData2Cell initPersonalData2Cell];
        }
        
        if (indexPath.row < 10)
        {
            [personalData2Cell personalDataInfo:indexPath.row];
        }
        else
        {
            [personalData2Cell buttonWithTarget:self action:@selector(logOutAction:)];
        }
        
        return personalData2Cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld",(long)indexPath.row);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        return 75;
    }
    else
    {
        return 55;
    }
}

- (void)logOutAction:(id)sender
{
    NSLog(@"退出登录");
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
