//
//  WXZWoTypeCell.m
//  rufangrongke
//
//  Created by 儒房融科 on 15/10/22.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

#import "WXZWoTypeCell.h"

@implementation WXZWoTypeCell



- (void)awakeFromNib {
    // Initialization code
}

// 加载nib文件
+ (instancetype)initHeadCell
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

// 设置button单击事件
- (void)buttonWithTarget:(id)target withAction:(SEL)action
{
    // 添加button 响应事件
    [self.commissionBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [self.chengjiaojiangBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [self.integralBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [self.creditValueBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
