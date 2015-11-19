//
//  WXZGouFangYiXiangCell.h
//  rufangrongke
//
//  Created by 儒房融科 on 15/11/5.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WXZGouFangYiXiangCell : UITableViewCell

@property (nonatomic,strong) UIViewController *controller; // controller权限

+ (instancetype)initGouFangYiXiangCell; // 加载nib文件

- (void)updateInfo:(NSDictionary *)dic; // 初始化客户详情信息

@end
