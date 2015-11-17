//
//  WXZScreeningCell.m
//  rufangrongke
//
//  Created by 儒房融科 on 15/11/17.
//  Copyright © 2015年 王晓植. All rights reserved.
//

#import "WXZScreeningCell.h"

@implementation WXZScreeningCell

- (void)awakeFromNib {
    // Initialization code
    self.selectImgView.hidden = YES; // 
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
