//
//  WXZKeHuListCell.m
//  rufangrongke
//
//  Created by 儒房融科 on 15/10/22.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

#import "WXZKeHuListCell.h"

@implementation WXZKeHuListCell

- (void)awakeFromNib {
    // Initialization code
}

// 加载nib文件
+ (instancetype)initListCell
{
    NSLog(@"%@",[[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject]);
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

// 添加 button 单击事件
- (void)buttonWithTarget:(id)target action:(SEL)action
{
    // 添加单击事件
    [self.reportedBtn setImage:[UIImage imageNamed:@"kh_reported_select"] forState:UIControlStateHighlighted];
    [self.reportedBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    [self.reportedOrCallBtn setImage:[UIImage imageNamed:@"kh_dianhua"] forState:UIControlStateHighlighted];
    [self.reportedOrCallBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
