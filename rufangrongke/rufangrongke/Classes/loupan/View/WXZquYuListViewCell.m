//
//  WXZquYuListViewCell.m
//  rufangrongke
//
//  Created by 儒房融科 on 15/11/12.
//  Copyright © 2015年 王晓植. All rights reserved.
//

#import "WXZquYuListViewCell.h"

@interface WXZquYuListViewCell ()


@end
@implementation WXZquYuListViewCell

- (void)awakeFromNib {
    // Initialization code
    self.chooseImage.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setQus:(Qus *)qus
{
    _qus = qus;
    self.cityLabel.text = [NSString stringWithFormat:@"%@ (%zd)", qus.q,qus.c];
}

@end
