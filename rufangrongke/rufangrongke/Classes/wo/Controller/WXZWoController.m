//
//  WXZWoController.m
//  rufangrongke
//
//  Created by 儒房融科 on 15/10/22.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

#import "WXZWoController.h"
#import "WXZWoHeadCell.h"
#import "WXZWoTypeCell.h"
#import "WXZWoListCell.h"

@interface WXZWoController ()<UITableViewDelegate,UITableViewDataSource> // 遵循协议

@property (weak, nonatomic) IBOutlet UITableView *myTableView; // 

@end

@implementation WXZWoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // 视图整体背景色
    self.view.backgroundColor = WXZRGBColor(209, 211, 212);
    
    // 隐藏导航navigation
    self.navigationController.navigationBarHidden = YES;
    
    // 状态栏
    UIView *statusView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 20)];
    statusView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"wo_status_bar"]];
    [self.view addSubview:statusView];
    
    // 设置数据源，遵循协议
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
}

#pragma mark - UITableViewDelegate,UITableViewDataSource Methods

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
        return 3;
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
        
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
            
            headCell.headBorderImgView.layer.cornerRadius = 60;
            headCell.headBorderImgView.layer.masksToBounds = YES;
            headCell.headBorderImgView.layer.borderWidth = 6;
            headCell.headBorderImgView.layer.borderColor = WXZRGBColor(27, 28, 27).CGColor;
            headCell.headBorderImgView.alpha = 0.44f;//;
            
            headCell.headImgView.layer.cornerRadius = 60;
            headCell.headImgView.layer.masksToBounds = YES;
            headCell.headImgView.layer.borderWidth = 8;
            headCell.headImgView.layer.borderColor =  WXZRGBColor(104, 111, 111).CGColor;
            
//            headCell.headImgView.hidden = YES;
            
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
            
            [typeCell.commissionBtn addTarget:self action:@selector(pushToCommissionPage:) forControlEvents:UIControlEventTouchUpInside];
            [typeCell.chengjiaojiangBtn addTarget:self action:@selector(pushToChengjiaojiangPage:) forControlEvents:UIControlEventTouchUpInside];
            [typeCell.integralBtn addTarget:self action:@selector(pushToIntegralPage:) forControlEvents:UIControlEventTouchUpInside];
            [typeCell.creditValueBtn addTarget:self action:@selector(pushToCreditValuePage:) forControlEvents:UIControlEventTouchUpInside];
            
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
//            listCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        // 判断列表属于哪个组，显示不同信息
        if (secction == 1)
        {
            // section = 1 ,添加分割线
            if (row < 2)
            {
                UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 54.7, [UIScreen mainScreen].bounds.size.width-12, 0.3)];
                lineLabel.backgroundColor = WXZRGBColor(215, 213, 213);
                [listCell addSubview:lineLabel];
            }
            
            // 自定义信息
            NSArray *listImgArr = @[@"wo_ feedback",@"wo_paihangbang",@"wo_ask_best _answer"];
            NSArray *listTitleArr = @[@"意见反馈",@"排行榜",@"百问百答"];
            // 赋值
            listCell.listImgView.image = [UIImage imageNamed:listImgArr[indexPath.row]];
            listCell.listTitleLabel.text = listTitleArr[indexPath.row];
        }
        else
        {
            // section = 2 ,信息显示
            listCell.listImgView.image = [UIImage imageNamed:@"wo_help"];
            listCell.listTitleLabel.text = @"帮助";
        }
        
        
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
            return 249;
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
    NSLog(@"section = %ld  ,row = %ld",(long)indexPath.section,(long)indexPath.row);
}

#pragma mark - Wo_Type Button Event
- (void)pushToCommissionPage:(id)sender
{
    // 佣金
    NSLog(@"佣金");
}

- (void)pushToChengjiaojiangPage:(id)sender
{
    // 成交奖
    NSLog(@"成交奖");
}

- (void)pushToIntegralPage:(id)sender
{
    // 积分
    NSLog(@"积分");
}

- (void)pushToCreditValuePage:(id)sender
{
    // 信用值
    NSLog(@"信用值");
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
