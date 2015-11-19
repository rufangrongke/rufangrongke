//
//  WXZPersonalData2Cell.h
//  rufangrongke
//
//  Created by 儒房融科 on 15/10/24.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

/**
 * 个人资料其他信息cell
 **/

#import <UIKit/UIKit.h>
#import "WXZWoInfoModel.h"

@interface WXZPersonalData2Cell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel; // 个人资料左侧标题
@property (weak, nonatomic) IBOutlet UILabel *tipLabel; // 个人资料每行右侧的提示信息
@property (weak, nonatomic) IBOutlet UILabel *certificationLabel; // 显示已/未认证
@property (weak, nonatomic) IBOutlet UIImageView *certificationImgView; // 显示已/未认证相应图片

// 加载nib文件
+ (instancetype)initPersonalData2Cell;

// 初始化信息
- (void)personalDataInfo:(NSInteger)row;
// 刷新数据
- (void)updatePersonalDataInfo:(NSInteger)row data:(WXZWoInfoModel *)personalInfoModel;
// 添加退出登录按钮点击事件
- (void)buttonWithTarget:(id)target action:(SEL)action;

@end
