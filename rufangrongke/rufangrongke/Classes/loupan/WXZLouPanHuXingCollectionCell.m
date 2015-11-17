//
//  WXZLouPanHuXingCollectionCell.m
//  rufangrongke
//
//  Created by 儒房融科 on 15/11/6.
//  Copyright © 2015年 王晓植. All rights reserved.
//

#import "WXZLouPanHuXingCollectionCell.h"
#import <UIImageView+WebCache.h>

@interface WXZLouPanHuXingCollectionCell()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *huXingLabel;

@end
@implementation WXZLouPanHuXingCollectionCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setHxs:(Hxs *)hxs
{
    _hxs = hxs;
    NSString *picUrlString = [picBaseULR stringByAppendingFormat:@"%@", hxs.pic];
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:picUrlString] placeholderImage:[UIImage imageNamed:@"lp_fyt4"]];
    self.huXingLabel.text = [NSString stringWithFormat:@"%@平米 %@",hxs.Area, hxs.hx];

}

@end
