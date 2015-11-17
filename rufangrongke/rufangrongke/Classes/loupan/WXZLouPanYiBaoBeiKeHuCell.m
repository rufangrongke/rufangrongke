//
//  WXZLouPanYiBaoBeiKeHuCell.m
//  rufangrongke
//
//  Created by 儒房融科 on 15/11/16.
//  Copyright © 2015年 王晓植. All rights reserved.
//

#import "WXZLouPanYiBaoBeiKeHuCell.h"

@interface WXZLouPanYiBaoBeiKeHuCell ()
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *phoneNum;

@end
@implementation WXZLouPanYiBaoBeiKeHuCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setLs:(Ls *)ls{
    _ls = ls;
    self.name.text = [NSString stringWithFormat:@"%@", ls.XingMing];
    self.phoneNum.text = [NSString stringWithFormat:@"%@", ls.Mobile];
}

@end
