//
//  WXZLouPanMessageCell_0_0.m
//  rufangrongke
//
//  Created by 儒房融科 on 15/10/28.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

#import "WXZLouPanMessageCell_0_0.h"

@interface WXZLouPanMessageCell_0_0()

@property (strong, nonatomic) IBOutlet UIImageView *shouCangPic;

@end
@implementation WXZLouPanMessageCell_0_0

- (void)awakeFromNib {
    // Initialization code
}
//static NSInteger index = 0;
static int index_1 = 0;
- (IBAction)clickShouCangPic:(id)sender {
    WXZLogFunc;
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber *numTemp = [numberFormatter numberFromString:self.shouCangNum.text];
    NSInteger number = [numTemp integerValue];
    WXZLog(@"%zd", number);
    if (index_1 == 0) {
        self.shouCangPic.image = [UIImage imageNamed:@"loupan-favourite"];
        index_1 = 1;
        
        // 修改收藏人数
        number += 1;
        NSNumber *num = [NSNumber numberWithInteger:number];
        self.shouCangNum.text = [NSString stringWithFormat:@"%@", num];
    }else{
        self.shouCangPic.image = [UIImage imageNamed:@"loupan-unfavourite"];
        index_1 = 0;
        
        // 修改收藏人数
        number -= 1;
        NSNumber *num = [NSNumber numberWithInteger:number];
        self.shouCangNum.text = [NSString stringWithFormat:@"%@", num];
    }
    
}

- (void)setModel:(View *)model
{
    _model = model;
    // 楼盘均价
    self.loupanJunJia.text = [NSString stringWithFormat:@"%@元/平", model.JunJia];;
    [self.loupanJunJia setTextColor:[UIColor redColor]];
    // 楼盘位置
    self.loupanWeiZhi.text = model.WeiZhi;
    [self.loupanWeiZhi setTextColor:[UIColor darkGrayColor]];
    // 楼盘收藏人数
    self.shouCangNum.text = [NSString stringWithFormat:@"%zd", model.ShouCangNum];
}
// cell数据源
//- (void)setWXZLouPanMessageCell_0_0_Dic:(NSMutableDictionary *)WXZLouPanMessageCell_0_0_Dic
//{
//    WXZLog(@"%@", WXZLouPanMessageCell_0_0_Dic);
//    // 楼盘均价
//    self.loupanJunJia.text = [NSString stringWithFormat:@"%@元/平", WXZLouPanMessageCell_0_0_Dic[@"JunJia"]];;
//    [self.loupanJunJia setTextColor:[UIColor redColor]];
//    // 楼盘位置
//    self.loupanWeiZhi.text = WXZLouPanMessageCell_0_0_Dic[@"WeiZhi"];
//    [self.loupanWeiZhi setTextColor:[UIColor darkGrayColor]];
//    // 楼盘收藏人数
//    self.shouCangNum.text = [NSString stringWithFormat:@"%@", WXZLouPanMessageCell_0_0_Dic[@"ShouCangNum"]];
//
//}

@end
