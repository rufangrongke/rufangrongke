//
//  WXZLouPanYongJinCell_1.m
//  rufangrongke
//
//  Created by 儒房融科 on 15/11/9.
//  Copyright © 2015年 王晓植. All rights reserved.
//

#import "WXZLouPanYongJinCell_1.h"

@interface WXZLouPanYongJinCell_1 ()
@property (weak, nonatomic) IBOutlet UILabel *heZuoShiJianLabel;
@property (weak, nonatomic) IBOutlet UILabel *heZuoFangYuanLabel;
@property (weak, nonatomic) IBOutlet UILabel *baoHuQiLabel;
@property (weak, nonatomic) IBOutlet UILabel *jiangLiLabel;
@property (weak, nonatomic) IBOutlet UILabel *kaiFaShangJiangLiLabel;
@end
@implementation WXZLouPanYongJinCell_1

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setKfsgzYongjin:(KfsgzYongjin *)kfsgzYongjin
{
    _kfsgzYongjin = kfsgzYongjin;
    /* 2015/10/1 0:00:00 */
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    NSDate *date =[dateFormat dateFromString:kfsgzYongjin.HeZuoTimeS];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    // 合作开始时间
    NSString *heZuoTimeS = [dateFormatter stringFromDate:date];
    // 合作结束时间
    date =[dateFormat dateFromString:kfsgzYongjin.HeZuoTimeE];
    NSString *heZuoTimeE = [dateFormatter stringFromDate:date];

    self.heZuoShiJianLabel.text = [NSString stringWithFormat:@"%@ 至 %@", heZuoTimeS, heZuoTimeE];
    self.heZuoFangYuanLabel.text = [NSString stringWithFormat:@"%@元/套", kfsgzYongjin.HeZuoFy];
    self.baoHuQiLabel.text = [NSString stringWithFormat:@"%@", kfsgzYongjin.BaoHuQi];
    self.jiangLiLabel.text = [NSString stringWithFormat:@"%@", kfsgzYongjin.JiangLi];
    self.kaiFaShangJiangLiLabel.text = [NSString stringWithFormat:@"%@", kfsgzYongjin.KFSJiangLi];
}

@end
