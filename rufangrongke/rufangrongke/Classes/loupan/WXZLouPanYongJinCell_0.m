//
//  WXZLouPanYongJinCell_0.m
//  rufangrongke
//
//  Created by 儒房融科 on 15/11/9.
//  Copyright © 2015年 王晓植. All rights reserved.
//

#import "WXZLouPanYongJinCell_0.h"

@interface WXZLouPanYongJinCell_0 ()
@property (weak, nonatomic) IBOutlet UILabel *qianYongLabel;
@property (weak, nonatomic) IBOutlet UILabel *houYongLabel;
@property (weak, nonatomic) IBOutlet UILabel *qianYongJieDianLabel;
@property (weak, nonatomic) IBOutlet UILabel *houYongJieDianLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
@implementation WXZLouPanYongJinCell_0

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setListYongJin:(ListYongJin *)listYongJin
{
    _listYongJin = listYongJin;
    self.qianYongLabel.text = [NSString stringWithFormat:@"%@元/套", listYongJin.QianYong];
    self.houYongLabel.text = [NSString stringWithFormat:@"%@元/套", listYongJin.HouYong];
    self.qianYongJieDianLabel.text = [NSString stringWithFormat:@"%@", listYongJin.JieDian_Qy];
    self.houYongJieDianLabel.text = [NSString stringWithFormat:@"%@", listYongJin.JieDian_HY];
    self.titleLabel.text = [NSString stringWithFormat:@"%@", listYongJin.Title];
}
@end
