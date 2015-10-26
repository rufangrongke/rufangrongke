//
//  WXZTableViewCell.m
//  rufangrongke
//
//  Created by dymost on 15/10/20.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

#import "WXZTableViewCell.h"
#import <UIImageView+WebCache.h>

@interface WXZTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *loupantupian;
@property (weak, nonatomic) IBOutlet UILabel *loupanmingcheng;
@property (weak, nonatomic) IBOutlet UIImageView *yong;
@property (weak, nonatomic) IBOutlet UILabel *loufangtaoshu;
@property (weak, nonatomic) IBOutlet UILabel *jingjirenshu;
@property (weak, nonatomic) IBOutlet UILabel *pingmijiage;
@property (weak, nonatomic) IBOutlet UILabel *yixiangkehushu;
@property (weak, nonatomic) IBOutlet UIView *fenggexian;
@property (weak, nonatomic) IBOutlet UIImageView *dituchibiao;
@property (weak, nonatomic) IBOutlet UILabel *xiangjujuli;


@end
@implementation WXZTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

// 模型-->cell
- (void)setLoupan:(WXZLouPan *)loupan
{
    _loupan = loupan;
    
    NSString *picUrlString = [picBaseULR stringByAppendingString:loupan.PicUrl];
    [self.loupantupian sd_setImageWithURL:[NSURL URLWithString:picUrlString] placeholderImage:[UIImage imageNamed:@"lp_fyt4"]];
    self.loupanmingcheng.text = loupan.xiaoqu;
    self.loufangtaoshu.text = loupan.YongJin;
    self.pingmijiage.text = loupan.JunJia;
    self.jingjirenshu.text = loupan.HeZuoJJrNum;
    self.yixiangkehushu.text = loupan.YiXiangKeHuNum;
    
}

@end
