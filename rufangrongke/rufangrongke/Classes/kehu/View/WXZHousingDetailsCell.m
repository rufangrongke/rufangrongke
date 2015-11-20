//
//  WXZHousingDetailsCell.m
//  rufangrongke
//
//  Created by 儒房融科 on 15/11/5.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

#import "WXZHousingDetailsCell.h"

@implementation WXZHousingDetailsCell

- (void)awakeFromNib {
    // Initialization code
}

+ (instancetype)initHousingDetailsCell
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

- (void)setDetailModel:(WXZKeHuDetailModel *)detailModel
{
    
}

- (void)updateInfo
{
    [self.statusBtn setTitle:@"已接受" forState:UIControlStateNormal];
    [self.statusBtn setTitleColor:WXZRGBColor(140, 139, 139) forState:UIControlStateNormal];
}

- (void)showInfo:(NSDictionary *)dic
{
    self.loupanNameLab.text = dic[@"xiaoqu"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
