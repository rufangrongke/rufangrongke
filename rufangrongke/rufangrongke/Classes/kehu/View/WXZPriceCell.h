//
//  WXZPriceCell.h
//  rufangrongke
//
//  Created by 儒房融科 on 15/11/5.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXZKeHuDetailModel.h"

@interface WXZPriceCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *noLimitBtn; // 价格不限按钮
@property (weak, nonatomic) IBOutlet UIButton *determineBtn; // 确定按钮

@property (weak, nonatomic) IBOutlet UITextField *pricefTextField; // 购房价格范围－开始价格输入框
@property (weak, nonatomic) IBOutlet UITextField *priceeTextField; // 购房价格范围－结束价格输入框

@property (nonatomic,strong) UIViewController *controller; // 传controller权限

+ (instancetype)initPriceCell; // 加载nib文件

- (void)updateInfo:(WXZKeHuDetailModel *)model isModify:(BOOL)ismodify; // 初始化价格信息

@end
