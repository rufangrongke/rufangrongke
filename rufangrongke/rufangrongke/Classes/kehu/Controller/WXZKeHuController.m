//
//  WXZKeHuController.m
//  rufangrongke
//
//  Created by dymost on 15/10/18.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

#import "WXZKeHuController.h"
#import "UIBarButtonItem+XMGExtension.h"
#import "WXZKeHuListCell.h"

@interface WXZKeHuController ()

@end

@implementation WXZKeHuController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WXZRGBColor(237, 237, 237);
    
    // 设置搜索框
    self.navigationItem.titleView = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    
    
}

#define fontf [UIFont systemFontOfSize:16];

- (void)viewWillAppear:(BOOL)animated
{
    // 设置导航栏左右两侧的 button
    UIView *leftBtnView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 53, 44)];
    // 标题
    UILabel *leftTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 34, leftBtnView.height)];
    leftTitleLabel.text = @"筛选";
    leftTitleLabel.textAlignment = NSTextAlignmentLeft;
    leftTitleLabel.textColor = [UIColor whiteColor];
    [leftBtnView addSubview:leftTitleLabel];
    // 箭头图片
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(leftTitleLabel.x+leftTitleLabel.width, (leftBtnView.height-11)/2, 19, 11)];
    imgView.image = [UIImage imageNamed:@"kh_zkj"];
    imgView.userInteractionEnabled = YES;
    [leftBtnView addSubview:imgView];
    // 添加轻击手势
    UITapGestureRecognizer *leftTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(screeningAction:)];
    [leftBtnView addGestureRecognizer:leftTap];
    
    // 右侧按钮
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 40, 44);
    [rightBtn setTitle:@"确定" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightBtn.titleLabel.font = fontf;
    [rightBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 8, 0, 0)]; // 标题向左侧偏移7
    [rightBtn addTarget:self action:@selector(determineAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtnView];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
}

#pragma mark - Data Request Methods
- (void)request
{
       
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WXZKeHuListCell *keHuInfoCell = [tableView dequeueReusableCellWithIdentifier:@"KeHuInfoCell"];
    
    if (!keHuInfoCell)
    {
        keHuInfoCell = [[[NSBundle mainBundle] loadNibNamed:@"WXZKeHuListCell" owner:self options:nil] lastObject];
        keHuInfoCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    // 设置底层view
    keHuInfoCell.listCellBackView.layer.cornerRadius = 6.0f;
    keHuInfoCell.listCellBackView.layer.masksToBounds = YES;
    keHuInfoCell.listCellBackView.layer.borderWidth = 1;
    keHuInfoCell.listCellBackView.layer.borderColor = [UIColor blackColor].CGColor;
    
    // 赋值
    //    keHuInfoCell.name.text = @"anan";
    
    return keHuInfoCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"click %ld row",(long)indexPath.row);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    // 添加新客户背景view
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 50)];
    headerView.backgroundColor = [UIColor clearColor];
    
    // 添加新客户按钮
    UIButton *addKeHuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addKeHuBtn.frame = CGRectMake(0, 0, headerView.width, headerView.height);
    [addKeHuBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [addKeHuBtn setTitle:@"添加新客户" forState:UIControlStateNormal];
    [addKeHuBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
    [addKeHuBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    addKeHuBtn.backgroundColor = [UIColor orangeColor];
    [addKeHuBtn addTarget:self action:@selector(addNewKeHuAction:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:addKeHuBtn];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

// 添加新客户行为
- (void)addNewKeHuAction:(id)sender
{
    NSLog(@"添加新客户!");
}

#pragma mark - Navigation BarButtonItem Click Event
- (void)screeningAction:(id)sender
{
    // 筛选
    NSLog(@"筛选");
}

- (void)determineAction:(id)sender
{
    // 确定
    NSLog(@"确定");
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
