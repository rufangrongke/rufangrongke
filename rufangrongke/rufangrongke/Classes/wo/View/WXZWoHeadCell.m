//
//  WXZWoHeadCell.m
//  rufangrongke
//
//  Created by 儒房融科 on 15/10/23.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

#import "WXZWoHeadCell.h"

@implementation WXZWoHeadCell

- (void)awakeFromNib {
    // Initialization code
    
    // 14  30
    
}

+ (instancetype)initHeadCell
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
