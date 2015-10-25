//
//  WXZWoHeadCell.m
//  rufangrongke
//
//  Created by 儒房融科 on 15/10/23.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

#import "WXZWoHeadCell.h"

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

- (void)updateWoInfo
{
    // 判断是否有缓存
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"pHead"])
    {
        self.headImgView.image = [UIImage imageWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"pHead"]]; // 贴头像
    }
    else
    {
        self.headImgView.image = [UIImage imageNamed:@"wo_head"];
    }
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"pName"])
    {
        self.userNameLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"pName"]; // 用户名
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"pStore"])
    {
        self.storeYardsLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"pStore"]; // 门店
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"pDeclaration"])
    {
        self.declarationLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"pDeclaration"]; // 服务宣言
    }
}

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
