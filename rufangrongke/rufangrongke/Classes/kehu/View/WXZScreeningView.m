//
//  WXZScreeningView.m
//  rufangrongke
//
//  Created by 儒房融科 on 15/11/10.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

#import "WXZScreeningView.h"
#import "WXZScreeningCell.h"

@interface WXZScreeningView () <UITableViewDataSource,UITableViewDelegate>

@end

@implementation WXZScreeningView

- (void)awakeFromNib
{
    // 初始化tableView的相关属性方法
    self.myTable.dataSource = self;
    self.myTable.delegate = self;
    self.myTable.backgroundColor = [UIColor clearColor];
    self.myTable.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count; // 返回行数
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WXZScreeningCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ScreeningCell"];
    if (!cell)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([WXZScreeningCell class]) owner:nil options:nil] lastObject]; // 加载nib文件
        cell.backgroundColor = [UIColor clearColor];
    }
    
    cell.titleLabel.text = self.dataArr[indexPath.row]; // 赋值（展示筛选类型）
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 获取点击的筛选类型cell，并显示选中图片
    WXZScreeningCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selectImgView.hidden = NO; // 选中的cell不隐藏
    
    // 选中的筛选类型内容
    NSString *currentTitle = self.dataArr[indexPath.row];
    // 判断当前选中的筛选类型是否等于“所有”，等于则传回“筛选”
    if ([currentTitle isEqualToString:@"所有"])
    {
        currentTitle = @"筛选";
    }
    
    [self.backScreeningTypeDelegate backScreeningType:currentTitle]; // 代理方法，传回筛选类型
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 获取cell，并隐藏未选中cell上的选中图片
    WXZScreeningCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selectImgView.hidden = YES; // 其他cell的隐藏
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
