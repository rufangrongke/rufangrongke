//
//  WXZLouPanInformationControllerCell_1_2.m
//  rufangrongke
//
//  Created by 儒房融科 on 15/11/9.
//  Copyright © 2015年 王晓植. All rights reserved.
//

#import "WXZLouPanInformationControllerCell_1_2.h"

@interface WXZLouPanInformationControllerCell_1_2 ()
@property (weak, nonatomic) IBOutlet UILabel *huxingChaoxiangLabel;

@property (weak, nonatomic) IBOutlet UILabel *zhuanxiuLeixingLabel;
@end
@implementation WXZLouPanInformationControllerCell_1_2

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel_1_2:(WXZLouPanInformationControllerModel *)model_1_2
{
    _model_1_2 = model_1_2;
    self.huxingChaoxiangLabel.text = [NSString stringWithFormat:@"%@", model_1_2.ChaoXiang];
    self.zhuanxiuLeixingLabel.text = [NSString stringWithFormat:@"%@", model_1_2.ZhuangXiu];
}
@end
