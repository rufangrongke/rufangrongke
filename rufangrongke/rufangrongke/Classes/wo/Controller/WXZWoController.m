//
//  WXZWoController.m
//  rufangrongke
//
//  Created by 儒房融科 on 15/10/22.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

#import "WXZWoController.h"
#import "WXZHeadCell.h"
#import "WXZWoTypeCell.h"
#import "WXZWoListCell.h"

@interface WXZWoController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end

@implementation WXZWoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = WXZRGBColor(209, 211, 212); // 视图整体背景色
    
    // 隐藏导航navigation
    self.navigationController.navigationBarHidden = YES;
    
    // 设置数据源，遵循协议
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
}

#pragma mark - UITableViewDelegate,UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
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
    NSInteger secction = indexPath.section;
    NSInteger row = indexPath.row;
    if (secction == 0)
    {
        
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if (row == 0)
        {
            // 头像cell
            static NSString *identifier = @"HeadCell";
            WXZHeadCell *headCell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!headCell)
            {
                headCell = [[WXZHeadCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                headCell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            // 初始化基础控件
            
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
            
            
            return typeCell;
        }
    }
    else
    {
        // 列表cell
        WXZWoListCell *listCell = [tableView dequeueReusableCellWithIdentifier:@"WoListCell"];
        if (!listCell)
        {
            listCell = [WXZWoListCell initHeadCell];
            listCell.selectionStyle = UITableViewCellSelectionStyleNone;
            listCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        if (secction == 1)
        {
            if (row < 2)
            {
                UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 54.5, [UIScreen mainScreen].bounds.size.width-12, 0.5)];
                lineLabel.backgroundColor = [UIColor lightGrayColor];
                [listCell addSubview:lineLabel];
            }
            
            NSArray *listImgArr = @[@"",@"wo_paihangbang",@"wo_ask_best _answer"];
            NSArray *listTitleArr = @[@"意见反馈",@"排行榜",@"百问百答"];
            
            listCell.listImgView.image = [UIImage imageNamed:listImgArr[indexPath.row]];
            listCell.listTitleLabel.text = listTitleArr[indexPath.row];
        }
        else
        {
            listCell.listImgView.image = [UIImage imageNamed:@"wo_help"];
            listCell.listTitleLabel.text = @"帮助";
        }
        
        
        return listCell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"section = %ld  ,row = %ld",(long)indexPath.section,(long)indexPath.row);
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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
