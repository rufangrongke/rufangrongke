//
//  WXZLouPanInfoVC_footTableView_Cell.m
//  rufangrongke
//
//  Created by 儒房融科 on 15/11/9.
//  Copyright © 2015年 王晓植. All rights reserved.
//

#import "WXZLouPanInfoVC_footTableView_Cell.h"

@interface WXZLouPanInfoVC_footTableView_Cell ()
@property (weak, nonatomic) IBOutlet UIImageView *picImageView;
@property (weak, nonatomic) IBOutlet UILabel *huxingLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *youshiLabel;


@end
@implementation WXZLouPanInfoVC_footTableView_Cell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setFootTableView_Cell_Model:(OthersModel *)footTableView_Cell_Model
{
    _footTableView_Cell_Model = footTableView_Cell_Model;
    
    NSString *picUrlString = [picBaseULR stringByAppendingString:footTableView_Cell_Model.pic];
    [self.picImageView sd_setImageWithURL:[NSURL URLWithString:picUrlString] placeholderImage:[UIImage imageNamed:@"loupan-huxing-zw"]];
    self.huxingLabel.text = [NSString stringWithFormat:@"%@ %@ (%@平米)", footTableView_Cell_Model.abc, footTableView_Cell_Model.hx,footTableView_Cell_Model.Area];
    self.priceLabel.text = [NSString stringWithFormat:@"%@万起", footTableView_Cell_Model.JiaGe];
    self.youshiLabel.text = [NSString stringWithFormat:@"%@",footTableView_Cell_Model.biaoQian];
}

@end
