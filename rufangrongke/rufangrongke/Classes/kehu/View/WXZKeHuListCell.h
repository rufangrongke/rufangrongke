//
//  WXZKeHuListCell.h
//  rufangrongke
//
//  Created by 儒房融科 on 15/10/22.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXZKeHuInfoModel.h"

@interface WXZKeHuListCell : UITableViewCell

/**
 *  UILabel: 信息显示
 *
 *  customerNameLabel   用户名
 *  customerPhoneLabel     用户手机号
 *  houseInfoLabel     房源信息
 *  yixiangLabel 最新互动信息展示
 *  footerViews 最新互动信息底层view
 */
@property (weak, nonatomic) IBOutlet UILabel *customerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *customerPhoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *houseInfoLabel;

@property (weak, nonatomic) IBOutlet UILabel *yixiangLabel;
@property (weak, nonatomic) IBOutlet UIView *footerViews;

/**
 *  UIButton: 按钮
 *
 *  reportedBtn    报备
 *  reportedOrCallBtn   打电话
 */
@property (weak, nonatomic) IBOutlet UIButton *reportedBtn;
@property (weak, nonatomic) IBOutlet UIButton *callBtn;

// 传controller权限
@property (nonatomic,strong) UIViewController *controller;

// 客户列表数据模型
@property (nonatomic,strong) WXZKeHuInfoModel *keHuInfoModel;

// 加载nib文件
+ (instancetype)initListCell;

// 添加 button 单击事件
- (void)buttonWithTarget:(id)target action:(SEL)action;

@end
