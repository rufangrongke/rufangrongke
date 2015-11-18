//
//  WXZPersonalCityCell.m
//  rufangrongke
//
//  Created by 儒房融科 on 15/10/29.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

#import "WXZPersonalCityCell.h"

@implementation WXZPersonalCityCell

- (void)awakeFromNib {
    // Initialization code
}

+ (instancetype)initCityCell
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

- (void)showContentCell:(NSString *)content
{
    self.cityNameLabel.text = content;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
