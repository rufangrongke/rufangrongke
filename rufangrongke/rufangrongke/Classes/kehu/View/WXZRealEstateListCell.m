//
//  WXZRealEstateListCell.m
//  rufangrongke
//
//  Created by 儒房融科 on 15/11/4.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

#import "WXZRealEstateListCell.h"

@interface WXZRealEstateListCell ()

@property (weak, nonatomic) IBOutlet UILabel *louPanNameLabel; // 楼盘名称
@property (weak, nonatomic) IBOutlet UILabel *isBaoBeiLabel; // 是否已报备

@end

@implementation WXZRealEstateListCell

- (void)awakeFromNib {
    // Initialization code
}

+ (instancetype)initRealEstateListCell
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

- (void)modifyReportInfo:(NSDictionary *)dic
{
    self.louPanNameLabel.text = dic[@""];
    self.isBaoBeiLabel.text = dic[@""];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
