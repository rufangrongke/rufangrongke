//
//  WXZLouPanBaoBeiKeHuCell.m
//  rufangrongke
//
//  Created by 儒房融科 on 15/11/16.
//  Copyright © 2015年 王晓植. All rights reserved.
//

#import "WXZLouPanBaoBeiKeHuCell.h"

@interface WXZLouPanBaoBeiKeHuCell ()
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *phone;


@end
@implementation WXZLouPanBaoBeiKeHuCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setList:(List *)list
{
    _list = list;
    self.name.text = [NSString stringWithFormat:@"%@", list.XingMing];
    self.phone.text = [NSString stringWithFormat:@"%@", list.Mobile];
}
@end
