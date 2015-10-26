//
//  WXZPersonalPhoneCell.m
//  rufangrongke
//
//  Created by 儒房融科 on 15/10/26.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

#import "WXZPersonalPhoneCell.h"

@implementation WXZPersonalPhoneCell

- (void)awakeFromNib {
    // Initialization code
}

// 加载nib文件
+ (instancetype)initPersonalPhoneCell
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

- (void)phoneInfo:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        self.phoneInfoLabel.text = @"验   证   码";
        self.phoneTextField.placeholder = @"请输入4位数字";
        self.codeBtn.hidden = NO;
    }
    else
    {
        self.codeBtn.hidden = YES;
        CGRect rect = self.phoneTextField.frame;
        rect.size.width = WXZ_ScreenWidth-96-20;
        self.phoneTextField.frame = rect;
        if (indexPath.row == 0)
        {
            self.phoneInfoLabel.text = @"新 手 机 号";
            self.phoneTextField.placeholder = @"请输入11位手机号";
            
        }
        else
        {
            self.phoneInfoLabel.text = @"确认手机号";
            self.phoneTextField.placeholder = @"请再次输入11位手机号";
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
