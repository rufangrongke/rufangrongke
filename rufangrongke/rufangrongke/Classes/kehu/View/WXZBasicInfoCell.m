//
//  WXZBasicInfoCell.m
//  rufangrongke
//
//  Created by 儒房融科 on 15/11/4.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

#import "WXZBasicInfoCell.h"

@interface WXZBasicInfoCell () <UITextFieldDelegate>

@end

@implementation WXZBasicInfoCell

- (void)awakeFromNib {
    // Initialization code
    self.nameTextField.delegate = self;
    self.phoneNumTextField.delegate = self;
}

// 加载nib文件
+ (instancetype)initBasicInfoCell
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

// 初始化客户基本信息
- (void)modifyInfo:(WXZKeHuDetailModel *)model isModify:(BOOL)ismodify
{
    if (ismodify)
    {
        self.nameTextField.text = model.XingMing;
        self.phoneNumTextField.text = model.Mobile;
        // 首次进来默认选中的性别
        if ([model.Sex isEqualToString:@"先生"])
        {
            [self.menBtn setImage:[UIImage imageNamed:@"kh_nvbzhu"] forState:UIControlStateNormal];
        }
        else
        {
            [self.womenBtn setImage:[UIImage imageNamed:@"kh_nvbzhu"] forState:UIControlStateNormal];
        }
    }
    else
    {
       [self.menBtn setImage:[UIImage imageNamed:@"kh_nvbzhu"] forState:UIControlStateNormal]; 
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.tag == 100022 && range.location >= 11)
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
