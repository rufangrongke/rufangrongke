//
//  WXZWoHeadCell.m
//  rufangrongke
//
//  Created by 儒房融科 on 15/10/23.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

#import "WXZWoHeadCell.h"
#import <UIImageView+WebCache.h>

@implementation WXZWoHeadCell

- (void)awakeFromNib {
    // Initialization code
}

// 加载nib文件
+ (instancetype)initHeadCell
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

// 设置头像边框
- (void)headBorder
{
    // 头像外边框
    self.headBorderImgView.layer.cornerRadius = 60;
    self.headBorderImgView.layer.masksToBounds = YES;
    self.headBorderImgView.layer.borderWidth = 6;
    self.headBorderImgView.layer.borderColor = WXZRGBColor(27, 28, 27).CGColor;
    self.headBorderImgView.alpha = 0.44f;
    // 头像内边框
    self.headImgView.layer.cornerRadius = 60;
    self.headImgView.layer.masksToBounds = YES;
    self.headImgView.layer.borderWidth = 8;
    self.headImgView.layer.borderColor =  WXZRGBColor(104, 111, 111).CGColor;
}

- (void)setWoInfoModel:(WXZWoInfoModel *)woInfoModel
{
    WXZLog(@"%@",woInfoModel.cityName);
    // 拼接头像url
    NSString *picurl = [picBaseULR stringByAppendingFormat:@"%@", woInfoModel.TouXiang];
    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:picurl] placeholderImage:[UIImage imageNamed:@"wo_head"]];
    
    self.userNameLabel.text = woInfoModel.TrueName; // 用户名
    if ([woInfoModel.TrueName isEqualToString:@""] || woInfoModel.TrueName == nil)
    {
        self.userNameLabel.text = @"添加用户名";
    }
    // 未认证或已认证
    self.certificationImgView.image = [UIImage imageNamed:@"wo_certification"];
    if ([woInfoModel.IsShiMing isEqualToString:@"True"])
    {
        self.certificationImgView.image = [UIImage imageNamed:@"wo_certified"];
    }
    // 门店
    self.storeYardsLabel.text = woInfoModel.LtName;
    if ([woInfoModel.LtName isEqualToString:@""] || woInfoModel.LtName == nil)
    {
        self.storeYardsLabel.text = @"尚未绑定门店码";
    }
    // 服务宣言
    self.declarationLabel.text = woInfoModel.XuanYan;
    if ([woInfoModel.XuanYan isEqualToString:@""] || woInfoModel.XuanYan == nil)
    {
        self.declarationLabel.text = @"一句话喊出你的精气神儿！~编辑你的服务宣言";
    }
}

//- (void)updateWoInfo:(NSDictionary *)headInfoDic
//{
//    // 拼接头像url
//    if (headInfoDic[@"TouXiang"] != nil)
//    {
//        NSURL *headUrl = [NSURL URLWithString:[picBaseULR stringByAppendingString:headInfoDic[@"TouXiang"]]];
//        [self.headImgView sd_setImageWithURL:headUrl placeholderImage:[UIImage imageNamed:@"wo_head"]];
//    }
//    else
//    {
//        NSURL *headUrl = [NSURL URLWithString:[picBaseULR stringByAppendingString:@""]];
//        [self.headImgView sd_setImageWithURL:headUrl placeholderImage:[UIImage imageNamed:@"wo_head"]];
//    }
//    
//    self.userNameLabel.text = headInfoDic[@"TrueName"]; // 用户名
//    if ([headInfoDic[@"TrueName"] isEqualToString:@""] || headInfoDic[@"TrueName"] == nil)
//    {
//        self.userNameLabel.text = @"添加用户名";
//    }
//    // 未认证或已认证
//    self.certificationImgView.image = [UIImage imageNamed:@"wo_certification"];
//    if ([headInfoDic[@"IsShiMing"] isEqualToString:@"True"])
//    {
//        self.certificationImgView.image = [UIImage imageNamed:@"wo_certified"];
//    }
//    // 门店
//    self.storeYardsLabel.text = headInfoDic[@"LtName"];
//    if ([headInfoDic[@"LtName"] isEqualToString:@""] || headInfoDic[@"LtName"] == nil)
//    {
//        self.storeYardsLabel.text = @"尚未绑定门店码";
//    }
//    // 服务宣言
//    self.declarationLabel.text = headInfoDic[@"XuanYan"];
//    if ([headInfoDic[@"XuanYan"] isEqualToString:@""] || headInfoDic[@"XuanYan"] == nil)
//    {
//        self.declarationLabel.text = @"一句话喊出你的精气神儿！~编辑你的服务宣言";
//    }
//}

// 设置button单击事件
- (void)buttonWithTarget:(id)target withAction:(SEL)action
{
    // 添加button 响应事件
    [self.bindingBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
