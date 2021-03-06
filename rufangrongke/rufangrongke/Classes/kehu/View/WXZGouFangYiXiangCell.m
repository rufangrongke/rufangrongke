//
//  WXZGouFangYiXiangCell.m
//  rufangrongke
//
//  Created by 儒房融科 on 15/11/5.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

#import "WXZGouFangYiXiangCell.h"
#import "WXZChectObject.h"
#import "WXZAddCustomerVC.h"
#import "WXZReportPreparationVC.h"
#import <SVProgressHUD.h>

@interface WXZGouFangYiXiangCell ()

@property (weak, nonatomic) IBOutlet UILabel *yixiangLabel; // 展示购房意向

//@property (nonatomic,strong) NSDictionary *dDic; // 存储传进来的详情信息

@end

@implementation WXZGouFangYiXiangCell

- (void)awakeFromNib {
    // Initialization code
}

+ (instancetype)initGouFangYiXiangCell
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

- (void)setDetailModel:(WXZKeHuDetailModel *)detailModel
{
    NSString *str2 = [NSString stringWithFormat:@"%@",detailModel.YiXiang];
    if ([str2 isEqualToString:@""] || str2 == nil || [str2 isEqual:[NSNull null]] || [str2 isEqualToString:@"<null>"])
    {
        NSString *str = @"未填写（完善购房意向可获得额外积分）";
        NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc] initWithString:str];
        NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:WXZRGBColor(27, 28, 27),NSForegroundColorAttributeName, nil];
        NSDictionary *dic2 = [NSDictionary dictionaryWithObjectsAndKeys:WXZRGBColor(2, 137, 223),NSForegroundColorAttributeName, nil];
        [attributed addAttributes:dic1 range:NSMakeRange(0, 3)];
        [attributed addAttributes:dic2 range:NSMakeRange(3, str.length-3)];
        self.yixiangLabel.attributedText = attributed;
    }
    else
    {
        self.yixiangLabel.text = detailModel.YiXiang;
    }
}

- (IBAction)baobeiloupanAction:(id)sender
{
    // 报备楼盘
    [SVProgressHUD showErrorWithStatus:@"流程：选择楼盘->报备客户" maskType:SVProgressHUDMaskTypeBlack];
//    WXZReportPreparationVC *rpVC = [[WXZReportPreparationVC alloc] init];
//    [_controller.navigationController pushViewController:rpVC animated:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
