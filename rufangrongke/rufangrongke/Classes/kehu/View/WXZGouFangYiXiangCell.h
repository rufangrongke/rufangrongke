//
//  WXZGouFangYiXiangCell.h
//  rufangrongke
//
//  Created by 儒房融科 on 15/11/5.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXZKeHuDetailModel.h"

@interface WXZGouFangYiXiangCell : UITableViewCell

@property (nonatomic,strong) UIViewController *controller; // controller权限

@property (nonatomic,strong) WXZKeHuDetailModel *detailModel; // 客户详情数据模型

+ (instancetype)initGouFangYiXiangCell; // 加载nib文件

@end
