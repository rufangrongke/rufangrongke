//
//  WXZLouPanMessageCell_1_0.m
//  rufangrongke
//
//  Created by 儒房融科 on 15/10/28.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

#import "WXZLouPanMessageCell_1_0.h"

@implementation WXZLouPanMessageCell_1_0

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setModel:(View *)model
{
    _model = model;
    self.yongJin.text = [NSString stringWithFormat:@"%zd元/套", model.YongJin];
    [self.yongJin setTextColor:[UIColor colorWithRed:21/255.0 green:137/255.0 blue:226/255.0 alpha:1.0]];
}
@end
