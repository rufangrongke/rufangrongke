//
//  WXZLouPanInformationControllerCell_1_0.m
//  rufangrongke
//
//  Created by 儒房融科 on 15/11/9.
//  Copyright © 2015年 王晓植. All rights reserved.
//

#import "WXZLouPanInformationControllerCell_1_0.h"

@interface WXZLouPanInformationControllerCell_1_0 ()
@property (weak, nonatomic) IBOutlet UILabel *huxinxingxiLabel;

@end
@implementation WXZLouPanInformationControllerCell_1_0

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel_1_0:(WXZLouPanInformationControllerModel *)model_1_0
{
    _model_1_0 = model_1_0;
    self.huxinxingxiLabel.text = [NSString stringWithFormat:@"%@", model_1_0.hx];
}
@end
