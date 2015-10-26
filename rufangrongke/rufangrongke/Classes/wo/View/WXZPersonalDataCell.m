//
//  WXZPersonalDataCell.m
//  rufangrongke
//
//  Created by 儒房融科 on 15/10/24.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

#import "WXZPersonalDataCell.h"

@implementation WXZPersonalDataCell

- (void)awakeFromNib {
    // Initialization code
}

// 加载nib文件
+ (instancetype)initPersonalDataCell
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

// 设置头像边框
- (void)headBorder
{
    self.headImgView.layer.cornerRadius = 30;
    self.headImgView.layer.masksToBounds = YES;
    self.headImgView.layer.borderWidth = 2;
    self.headImgView.layer.borderColor = WXZRGBColor(184, 184, 184).CGColor;
    
    // 添加分割线
    UIImageView *lineImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 74, WXZ_ScreenWidth-20, 1)];
    lineImgView.image = [UIImage imageNamed:@"wo_personaldata_divider"];
    [self.contentView addSubview:lineImgView];
}

- (void)updateHead
{
    // 判断是否有缓存
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"pHead"])
    {
        self.headImgView.image = [UIImage imageWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"pHead"]]; // 贴头像
    }
    else
    {
        // 默认头像
        self.headImgView.image = [UIImage imageNamed:@"wo_personaldata_head"];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end