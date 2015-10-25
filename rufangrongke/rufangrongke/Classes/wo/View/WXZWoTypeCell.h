//
//  WXZWoTypeCell.h
//  rufangrongke
//
//  Created by 儒房融科 on 15/10/22.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WXZWoTypeCell : UITableViewCell

/**
 *  UIButton:   按钮
 *
 *  commissionBtn   佣金
 *  chengjiaojiangBtn   成交奖
 *  integralBtn    积分
 *  creditValueBtn  信用值
 */
@property (weak, nonatomic) IBOutlet UIButton *commissionBtn;
@property (weak, nonatomic) IBOutlet UIButton *chengjiaojiangBtn;
@property (weak, nonatomic) IBOutlet UIButton *integralBtn;
@property (weak, nonatomic) IBOutlet UIButton *creditValueBtn;

// 加载nib文件
+ (instancetype)initHeadCell;

// 设置button单击事件
- (void)buttonWithTarget:(id)target withAction:(SEL)action;

@end
