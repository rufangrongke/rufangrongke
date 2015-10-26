//
//  WXZPersonalPhoneVC.m
//  rufangrongke
//
//  Created by 儒房融科 on 15/10/26.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

#import "WXZPersonalPhoneVC.h"
#import "WXZPersonalPhoneCell.h"

@interface WXZPersonalPhoneVC () <UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumLabel;
@property (strong, nonatomic) IBOutlet UIView *tipsHeaderView;

@end

@implementation WXZPersonalPhoneVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // 视图整体背景色
    self.view.backgroundColor = WXZRGBColor(246, 246, 246);
    // 添加标题，设置标题的颜色和字号
    self.navigationItem.title = @"修改绑定手机";
    
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    
    self.phoneNumLabel.text = @"17701261104";
    
}

#pragma mark - 
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }
    else
    {
        return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WXZPersonalPhoneCell *phoneCell = [tableView dequeueReusableCellWithIdentifier:@"ModifyPhoneCell"];
    if (!phoneCell)
    {
        phoneCell = [WXZPersonalPhoneCell initPersonalPhoneCell];
    }
    
    [phoneCell phoneInfo:indexPath];
    
    return phoneCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 62;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        self.phoneNumLabel.text = @"17701261104";
        return self.tipsHeaderView;
    }
    return self.tipsHeaderView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
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
