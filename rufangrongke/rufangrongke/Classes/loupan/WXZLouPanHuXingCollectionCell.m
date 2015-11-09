//
//  WXZLouPanHuXingCollectionCell.m
//  rufangrongke
//
//  Created by 儒房融科 on 15/11/6.
//  Copyright © 2015年 王晓植. All rights reserved.
//

#import "WXZLouPanHuXingCollectionCell.h"
#import "WXZLouPanHuXingModel.h"
#import <UIImageView+WebCache.h>

@interface WXZLouPanHuXingCollectionCell()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *huXingLabel;

@end
@implementation WXZLouPanHuXingCollectionCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setLouPanHuXingModel:(WXZLouPanHuXingModel *)louPanHuXingModel
{
    _louPanHuXingModel = louPanHuXingModel;
    NSString *picUrlString = [picBaseULR stringByAppendingString:louPanHuXingModel.pic];
//    WXZLog(@"%@", picUrlString);
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:picUrlString] placeholderImage:[UIImage imageNamed:@"lp_fyt4"]];
    self.huXingLabel.text = louPanHuXingModel.hx;
}
@end
