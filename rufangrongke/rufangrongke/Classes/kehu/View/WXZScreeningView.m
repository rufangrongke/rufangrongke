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

static NSInteger recordRow;

@implementation WXZScreeningView

- (void)awakeFromNib
{
    self.myTable.dataSource = self;
    self.myTable.delegate = self;
    self.myTable.backgroundColor = [UIColor clearColor];
    self.myTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    recordRow = 0;
    
//    _selectImgView.hidden = YES;
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
    // 移除原有的内容和下划线
    for (UIView *subsView in cell.contentView.subviews)
    {
        [subsView removeFromSuperview];
    }
    
    // 内容
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, WXZ_ScreenWidth-20, 40)];
    _titleLabel.textColor = WXZRGBColor(27, 28, 27);
    _titleLabel.font = WXZ_SystemFont(15);
    _titleLabel.backgroundColor = [UIColor clearColor];
    [cell.contentView addSubview:_titleLabel];
    // 选择图片
    _selectImgView = [[UIImageView alloc] initWithFrame:CGRectMake(WXZ_ScreenWidth-22-20, (40-22)/2, 22, 22)];
    _selectImgView.tag = indexPath.row;
    _selectImgView.image = [UIImage imageNamed:@"loupan-qy-complete"];
    [cell.contentView addSubview:_selectImgView];
    _selectImgView.hidden = YES;
    // 下划线
    UIImageView *lineImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, cell.contentView.height-1, WXZ_ScreenWidth, 1)];
    lineImgView.image = [UIImage imageNamed:@"wo_personal_divider"];
    [cell.contentView addSubview:lineImgView];
    
    _titleLabel.text = self.dataArr[indexPath.row]; // 赋值
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.row == _selectImgView.tag)
    {
        _selectImgView.hidden = NO;
    }
    [self.backScreeningTypeDelegate backScreeningType:self.dataArr[indexPath.row]]; // 代理方法
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectImgView.hidden = YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
