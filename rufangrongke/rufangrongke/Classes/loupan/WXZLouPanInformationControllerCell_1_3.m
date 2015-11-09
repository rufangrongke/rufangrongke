//
//  WXZLouPanInformationControllerCell_1_3.m
//  rufangrongke
//
//  Created by 儒房融科 on 15/11/9.
//  Copyright © 2015年 王晓植. All rights reserved.
//

#import "WXZLouPanInformationControllerCell_1_3.h"

@interface WXZLouPanInformationControllerCell_1_3 ()
@property (weak, nonatomic) IBOutlet UILabel *label;

@end
@implementation WXZLouPanInformationControllerCell_1_3

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setModel_1_3:(WXZLouPanInformationControllerModel *)model_1_3
{
    _model_1_3 = model_1_3;
    self.label.text = [NSString stringWithFormat:@"%@", model_1_3.TuiJianLiYou];
}
@end
