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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

+ (instancetype)initPriceCell
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

- (void)updateInfo:(WXZKeHuDetailModel *)model isModify:(BOOL)ismodify
{
    self.noLimitBtn.backgroundColor = [UIColor lightGrayColor];
    if (ismodify)
    {
        NSString *sStr = [NSString stringWithFormat:@"%@",model.JiaGeS];
        NSString *eStr = [NSString stringWithFormat:@"%@",model.JiaGeE];
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

#pragma mark - 键盘显示和隐藏事件
- (void)keyBoardWillShow:(NSNotification *)notification
{
    if (self.pricefTextField.tag != 100021 || self.priceeTextField.tag != 100022)
    {
        self.controller.view.frame = CGRectMake(0, -40, WXZ_ScreenWidth, WXZ_ScreenHeight);
    }
}

- (void)keyBoardWillHide:(NSNotification *)notification
{
    self.controller.view.frame = CGRectMake(0, 64, WXZ_ScreenWidth, WXZ_ScreenHeight);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
