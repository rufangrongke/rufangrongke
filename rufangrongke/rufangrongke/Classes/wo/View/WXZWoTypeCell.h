//
//  WXZWoTypeCell.h
//  rufangrongke
//
//  Created by 儒房融科 on 15/10/22.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WXZWoTypeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *commissionBtn;
@property (weak, nonatomic) IBOutlet UIButton *chengjiaojiangBtn;
@property (weak, nonatomic) IBOutlet UIButton *integralBtn;
@property (weak, nonatomic) IBOutlet UIButton *creditValueBtn;

+ (instancetype)initHeadCell;

@end
