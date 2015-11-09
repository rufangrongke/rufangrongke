//
//  WXZLouPanInformationControllerCell_1_1.m
//  rufangrongke
//
//  Created by 儒房融科 on 15/11/9.
//  Copyright © 2015年 王晓植. All rights reserved.
//

#import "WXZLouPanInformationControllerCell_1_1.h"

@interface WXZLouPanInformationControllerCell_1_1 ()
@property (weak, nonatomic) IBOutlet UILabel *huxinyouhuiLabel;

@end
@implementation WXZLouPanInformationControllerCell_1_1

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel_1_1:(WXZLouPanInformationControllerModel *)model_1_1
{
    _model_1_1 = model_1_1;
    self.huxinyouhuiLabel.text = [NSString stringWithFormat:@"%@",model_1_1.YouHui];
}
@end
