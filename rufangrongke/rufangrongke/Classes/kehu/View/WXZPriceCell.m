//
//  WXZPriceCell.m
//  rufangrongke
//
//  Created by 儒房融科 on 15/11/5.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

#import "WXZPriceCell.h"
#import "WXZChectObject.h"

@interface WXZPriceCell () <UITextFieldDelegate>

@end

@implementation WXZPriceCell

- (void)awakeFromNib {
    // Initialization code
    self.pricefTextField.delegate = self;
    self.priceeTextField.delegate = self;
    
    // 注册键盘通知
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

+ (instancetype)initPriceCell
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

- (void)updateInfo:(WXZKeHuDetailModel *)model isModify:(BOOL)ismodify
{
    [self.noLimitBtn setBackgroundImage:[UIImage imageNamed:@"kh_quyuunselect"] forState:UIControlStateNormal];
    [self.noLimitBtn setTitleColor:WXZRGBColor(27, 28, 27) forState:UIControlStateNormal];
    if (ismodify)
    {
        NSString *sStr = [NSString stringWithFormat:@"%@",model.JiaGeS];
        NSString *eStr = [NSString stringWithFormat:@"%@",model.JiaGeE];
        if ([WXZChectObject checkWhetherStringIsEmpty:sStr] && [WXZChectObject checkWhetherStringIsEmpty:eStr])
        {
            [self.noLimitBtn setBackgroundImage:[UIImage imageNamed:@"kh_quyuselected"] forState:UIControlStateNormal];
            [self.noLimitBtn setTitleColor:WXZRGBColor(27, 28, 27) forState:UIControlStateNormal];
        }
        else
        {
            self.pricefTextField.text = sStr;
            self.priceeTextField.text = eStr;
        }
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self.noLimitBtn setBackgroundImage:[UIImage imageNamed:@"kh_quyuunselect"] forState:UIControlStateNormal];
    [self.noLimitBtn setTitleColor:WXZRGBColor(27, 28, 27) forState:UIControlStateNormal];
    
    [UIView animateWithDuration:0.25 animations:^{
        if (textField.tag == 100025 || textField.tag == 100026)
        {
            self.controller.view.frame = CGRectMake(0, -110, WXZ_ScreenWidth, WXZ_ScreenHeight);
        }
    }];
    
    return YES;
}

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

#pragma mark - 键盘显示和隐藏事件
- (void)keyBoardWillHide:(NSNotification *)notification
{
    self.controller.view.frame = CGRectMake(0, 64, WXZ_ScreenWidth, WXZ_ScreenHeight-64);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
