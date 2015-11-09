//
//  WXZLouPanInformationControllerCell_0_0.m
//  rufangrongke
//
//  Created by 儒房融科 on 15/11/9.
//  Copyright © 2015年 王晓植. All rights reserved.
//

#import "WXZLouPanInformationControllerCell_0_0.h"

@interface WXZLouPanInformationControllerCell_0_0()
@property (weak, nonatomic) IBOutlet UILabel *huxingArea;
@property (weak, nonatomic) IBOutlet UILabel *shouJia;

@end
@implementation WXZLouPanInformationControllerCell_0_0

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel_0_0:(WXZLouPanInformationControllerModel *)model_0_0
{
    _model_0_0 = model_0_0;
    self.huxingArea.text = [NSString stringWithFormat:@"%@ %@ (%@平米)", model_0_0.abc, model_0_0.hx,model_0_0.Area];
    self.shouJia.text = [NSString stringWithFormat:@"%@万起", model_0_0.JiaGe];
}
@end
