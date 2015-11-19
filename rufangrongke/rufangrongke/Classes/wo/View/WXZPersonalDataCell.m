//
//  WXZPersonalDataCell.m
//  rufangrongke
//
//  Created by 儒房融科 on 15/10/24.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

#import "WXZPersonalDataCell.h"
#import <UIImageView+WebCache.h>

@implementation WXZPersonalDataCell

- (void)awakeFromNib {
    // Initialization code
}

// 加载nib文件
+ (instancetype)initPersonalDataCell
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

// 初始化头像信息
- (void)setWoInfoModel:(WXZWoInfoModel *)woInfoModel
{
    // 设置头像边框
    self.headImgView.layer.cornerRadius = 30;
    self.headImgView.layer.masksToBounds = YES;
    self.headImgView.layer.borderWidth = 2;
    self.headImgView.layer.borderColor = WXZRGBColor(184, 184, 184).CGColor;
    
    // 添加分割线
    UIImageView *lineImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 74, WXZ_ScreenWidth-20, 1)];
    lineImgView.image = [UIImage imageNamed:@"wo_personaldata_divider"];
    [self.contentView addSubview:lineImgView];
    
    NSURL *personalHeadUrl = [NSURL URLWithString:[picBaseULR stringByAppendingFormat:@"%@",woInfoModel.TouXiang]];
    [self.headImgView sd_setImageWithURL:personalHeadUrl placeholderImage:[UIImage imageNamed:@"wo_personaldata_head"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
