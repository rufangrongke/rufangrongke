//
//  WXZKhdUserInfoCell.h
//  rufangrongke
//
//  Created by 儒房融科 on 15/11/5.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXZKeHuDetailModel.h"

@interface WXZKhdUserInfoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *nameTextField; // 姓名输入框
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTextField; // 手机号输入框

@property (weak, nonatomic) IBOutlet UIButton *smsBtn; // 消息按钮
@property (weak, nonatomic) IBOutlet UIButton *callBtn; // 打电话按钮

@property (nonatomic,strong) WXZKeHuDetailModel *detailModel; // 客户详情数据模型

+ (instancetype)initKhdUserInfoCell; // 加载nib文件

@end
