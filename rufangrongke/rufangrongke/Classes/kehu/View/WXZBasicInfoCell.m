//
//  WXZBasicInfoCell.m
//  rufangrongke
//
//  Created by 儒房融科 on 15/11/4.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

#import "WXZBasicInfoCell.h"

@interface WXZBasicInfoCell ()

@end

@implementation WXZBasicInfoCell

- (void)awakeFromNib {
    // Initialization code
}

+ (instancetype)initBasicInfoCell
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
