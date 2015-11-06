//
//  WXZKhdUserInfoCell.m
//  rufangrongke
//
//  Created by 儒房融科 on 15/11/5.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

#import "WXZKhdUserInfoCell.h"

@implementation WXZKhdUserInfoCell

- (void)awakeFromNib {
    // Initialization code
}

+ (instancetype)initKhdUserInfoCell
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

- (void)showInfo:(NSString *)str phone:(NSString *)str2
{
    self.nameTextField.text = str;
    self.phoneNumTextField.text = str2;
}

- (IBAction)callAction:(id)sender
{
    NSLog(@"拨打电话");
}

- (IBAction)smsAction:(id)sender
{
    NSLog(@"发短信");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
