//
//  WXZPriceCell.h
//  rufangrongke
//
//  Created by 儒房融科 on 15/11/5.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WXZPriceCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *noLimitBtn;
@property (weak, nonatomic) IBOutlet UIButton *determineBtn;

@property (weak, nonatomic) IBOutlet UITextField *pricefTextField;
@property (weak, nonatomic) IBOutlet UITextField *priceeTextField;

+ (instancetype)initPriceCell;
- (void)updateInfo;

@end
