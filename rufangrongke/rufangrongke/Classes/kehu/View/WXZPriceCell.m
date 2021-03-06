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
    // 替换原有光标，并向右侧移动一点
    UIView *paddingfView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 3, 30)];
    self.pricefTextField.leftView = paddingfView;
    self.pricefTextField.leftViewMode = UITextFieldViewModeAlways;
    UIView *paddingeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 3, 30)];
    self.priceeTextField.leftView = paddingeView;
    self.priceeTextField.leftViewMode = UITextFieldViewModeAlways;
    
    // 注册键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

// 加载nib文件
+ (instancetype)initPriceCell
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

// 初始化价格信息
- (void)updateInfo:(WXZKeHuDetailModel *)model isModify:(BOOL)ismodify
{
    [self.noLimitBtn setBackgroundImage:[UIImage imageNamed:@"kh_quyuunselect"] forState:UIControlStateNormal];
    [self.noLimitBtn setTitleColor:WXZRGBColor(27, 28, 27) forState:UIControlStateNormal];
    if (ismodify)
    {
        NSString *sStr = [NSString stringWithFormat:@"%@",model.JiaGeS];
        NSString *eStr = [NSString stringWithFormat:@"%@",model.JiaGeE];
        // 判断是否有输入购房价格，有则显示价格，没有则显示“不限”
        if ([WXZChectObject checkWhetherStringIsEmpty:sStr] && [WXZChectObject checkWhetherStringIsEmpty:eStr])
        {
            [self.noLimitBtn setBackgroundImage:[UIImage imageNamed:@"kh_quyuselected"] forState:UIControlStateNormal];
            [self.noLimitBtn setTitleColor:WXZRGBColor(27, 28, 27) forState:UIControlStateNormal];
        }
        else
        {
            if (![WXZChectObject checkWhetherStringIsEmpty:sStr])
            {
                self.pricefTextField.text = sStr;
            }
            if (![WXZChectObject checkWhetherStringIsEmpty:eStr])
            {
                self.priceeTextField.text = eStr;
            }
        }
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    // 价格不限为未选中
    [self.noLimitBtn setBackgroundImage:[UIImage imageNamed:@"kh_quyuunselect"] forState:UIControlStateNormal];
    [self.noLimitBtn setTitleColor:WXZRGBColor(27, 28, 27) forState:UIControlStateNormal];
    // 键盘出来改变父view的frame
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
