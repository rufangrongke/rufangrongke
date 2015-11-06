//
//  WXZKhdUserInfoCell.m
//  rufangrongke
//
//  Created by 儒房融科 on 15/11/5.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

#import "WXZKhdUserInfoCell.h"
#import "WXZChectObject.h"

@interface WXZKhdUserInfoCell () <UITextFieldDelegate> //

@end

@implementation WXZKhdUserInfoCell

- (void)awakeFromNib {
    // Initialization code
    
    self.nameTextField.delegate = self;
    self.phoneNumTextField.delegate = self;
}

+ (instancetype)initKhdUserInfoCell
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

// 展示信息
- (void)showInfo:(NSString *)str phone:(NSString *)str2
{
    if ([WXZChectObject checkWhetherStringIsEmpty:str])
    {
        self.nameTextField.placeholder = @"";
    }
    if ([WXZChectObject checkWhetherStringIsEmpty:str])
    {
        self.phoneNumTextField.placeholder = @"";
    }
    self.nameTextField.text = str;
    self.phoneNumTextField.text = str2;
}

// 拨打电话
- (IBAction)callAction:(id)sender
{
    NSLog(@"拨打电话");
    // 打电话
    NSString *phoneNumStr = [NSString stringWithFormat:@"telprompt://%@",self.phoneNumTextField.text];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumStr]];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.tag == 100020 && range.location >= 11)
    {
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
