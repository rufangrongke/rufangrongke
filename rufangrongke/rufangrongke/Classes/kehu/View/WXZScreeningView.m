//
//  WXZScreeningView.m
//  rufangrongke
//
//  Created by 儒房融科 on 15/11/10.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

#import "WXZScreeningView.h"

@interface WXZScreeningView () <UITableViewDataSource,UITableViewDelegate>

@end

@implementation WXZScreeningView

- (void)awakeFromNib
{
    self.myTable.dataSource = self;
    self.myTable.delegate = self;
    self.myTable.backgroundColor = [UIColor clearColor];
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"ScreeningCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.backgroundColor = [UIColor clearColor];
    }
    
    cell.textLabel.text = self.dataArr[indexPath.row];
    cell.textLabel.font = WXZ_SystemFont(14);
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.backScreeningTypeDelegate backScreeningType:self.dataArr[indexPath.row]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
