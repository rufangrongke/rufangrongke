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
    self.myTable.dataSource = self;
    self.myTable.delegate = self;
    self.myTable.backgroundColor = [UIColor clearColor];
    self.myTable.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WXZScreeningCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ScreeningCell"];
    if (!cell)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([WXZScreeningCell class]) owner:nil options:nil] lastObject];
        cell.backgroundColor = [UIColor clearColor];
    }
    
    cell.titleLabel.text = self.dataArr[indexPath.row]; // 赋值
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WXZScreeningCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selectImgView.hidden = NO; // 选中的cell不隐藏
    
    NSString *currentTitle = self.dataArr[indexPath.row];
    if ([currentTitle isEqualToString:@"所有"])
    {
        currentTitle = @"筛选";
    }
    
    [self.backScreeningTypeDelegate backScreeningType:currentTitle]; // 代理方法
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
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
