//
//  WXZGouFangYiXiangCell.h
//  rufangrongke
//
//  Created by 儒房融科 on 15/11/5.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WXZGouFangYiXiangCell : UITableViewCell

@property (nonatomic,strong) UIViewController *controller;

+ (instancetype)initGouFangYiXiangCell;

- (void)updateInfo;

@end
