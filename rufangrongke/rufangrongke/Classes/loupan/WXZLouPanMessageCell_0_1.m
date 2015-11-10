//
//  WXZLouPanMessageCell_0_1.m
//  rufangrongke
//
//  Created by 儒房融科 on 15/10/28.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

#import "WXZLouPanMessageCell_0_1.h"

@implementation WXZLouPanMessageCell_0_1

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
    self.yixiangkehuNum.text = [NSString stringWithFormat:@"%zd", model.YiXiangKeHuNum];
    self.hezuojingjirenNum.text = [NSString stringWithFormat:@"%zd", model.HeZuoJJrNum];
    self.zuijinchengjiaoNum.text = [NSString stringWithFormat:@"%zd", model.ChengJiaoNum];

}
@end
