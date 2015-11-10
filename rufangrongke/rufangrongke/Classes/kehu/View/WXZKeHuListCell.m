//
//  WXZKeHuListCell.m
//  rufangrongke
//
//  Created by 儒房融科 on 15/10/22.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

#import "WXZKeHuListCell.h"
#import "WXZChectObject.h"
#import "WXZStringObject.h"
#import "WXZReportPreparationVC.h"

@implementation WXZKeHuListCell

- (void)awakeFromNib {
    // Initialization code
}

// 加载nib文件
+ (instancetype)initListCell
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

// 添加 button 单击事件
- (void)buttonWithTarget:(id)target action:(SEL)action
{
    // 添加单击事件
    [self.reportedBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    [self.callBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

- (void)setKeHuInfoModel:(WXZKeHuInfoModel *)keHuInfoModel
{
    self.customerNameLabel.text = keHuInfoModel.XingMing; // 姓名
    self.customerPhoneLabel.text = keHuInfoModel.Mobile; // 电话
    
    /**
     *  房源信息：
     */
    self.houseInfoLabel.text = keHuInfoModel.YiXiang;
    
    self.reportedBtn.hidden = YES;
    self.callBtn.hidden = NO;
}

// 更新数据
//- (void)showKeHuListInfo:(NSDictionary *)dic
//{
//    self.customerNameLabel.text = dic[@"XingMing"]; // 姓名
//    self.customerPhoneLabel.text = dic[@"Mobile"]; // 电话
//    
//    /**
//     *  房源信息：
//     */
//    self.houseInfoLabel.text = dic[@"YiXiang"];
//    
//    self.reportedBtn.hidden = YES;
//    self.callBtn.hidden = NO;
//}

// 报备/打电话事件
- (IBAction)reportedOrCallAction:(UIButton *)sender
{
    if (sender.tag == 100024)
    {
        NSLog(@"报备事件");
        WXZReportPreparationVC *reportVC = [[WXZReportPreparationVC alloc] init];
        [_controller.navigationController pushViewController:reportVC animated:YES];
    }
    else
    {
        NSLog(@"打电话事件:%@",self.customerPhoneLabel.text);
        // 打电话
        NSString *phoneNumStr = [NSString stringWithFormat:@"telprompt://%@",self.customerPhoneLabel.text];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumStr]];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
