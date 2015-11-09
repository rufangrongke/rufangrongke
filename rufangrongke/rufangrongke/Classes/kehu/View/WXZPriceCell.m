//
//  WXZPriceCell.m
//  rufangrongke
//
//  Created by 儒房融科 on 15/11/5.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

#import "WXZPriceCell.h"

@interface WXZPriceCell () <UITextFieldDelegate>

@end

@implementation WXZPriceCell

- (void)awakeFromNib {
    // Initialization code
    self.pricefTextField.delegate = self;
    self.priceeTextField.delegate = self;
}

+ (instancetype)initPriceCell
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

- (void)updateInfo
{
    self.noLimitBtn.backgroundColor = [UIColor lightGrayColor];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    // 发送通知更新意向价格
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BackPriceInfoAndUpdate" object:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // 发送通知更新意向价格
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BackPriceInfoAndUpdate" object:nil];
    [textField resignFirstResponder];
    return YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
