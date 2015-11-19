//
//  WXZBasicInfoCell.h
//  rufangrongke
//
//  Created by 儒房融科 on 15/11/4.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

/**
 * 添加客户基本信息cell
 **/

#import <UIKit/UIKit.h>
#import "WXZKeHuDetailModel.h"

@interface WXZBasicInfoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *nameTextField; // 客户姓名
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTextField; // 客户手机号

@property (weak, nonatomic) IBOutlet UIButton *menBtn; // 性别男btn
@property (weak, nonatomic) IBOutlet UIButton *womenBtn; // 性别女btn

@property (nonatomic,strong) WXZKeHuDetailModel *detailModel; // 客户详情数据模型

+ (instancetype)initBasicInfoCell; // 加载nib文件

- (void)modifyInfo:(WXZKeHuDetailModel *)model isModify:(BOOL)ismodify; // 初始化客户基本信息

@end
