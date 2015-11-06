//
//  WXZGouFangYiXiangCell.m
//  rufangrongke
//
//  Created by 儒房融科 on 15/11/5.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

#import "WXZGouFangYiXiangCell.h"

@implementation WXZGouFangYiXiangCell

- (void)awakeFromNib {
    // Initialization code
}

+ (instancetype)initGouFangYiXiangCell
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

- (IBAction)goufangyixiangTapAction:(id)sender
{
    NSLog(@"购房意向");
}

- (IBAction)baobeiloupanTapAction:(id)sender
{
    NSLog(@"报备楼盘");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
