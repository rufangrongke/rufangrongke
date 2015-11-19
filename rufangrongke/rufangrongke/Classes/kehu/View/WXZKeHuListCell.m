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
#import "WXZDateObject.h"

@interface WXZKeHuListCell ()

@property (nonatomic,strong) UIWebView *phoneCallWebView; // 打电话方法二

@end

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
    // 添加报备单击事件
    [self.reportedBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    // 添加打电话单击事件
    [self.callBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

// 客户信息展示
- (void)setKeHuInfoModel:(WXZKeHuInfoModel *)keHuInfoModel
{
    self.customerNameLabel.text = keHuInfoModel.XingMing; // 姓名
    self.customerPhoneLabel.text = keHuInfoModel.Mobile; // 电话
    self.houseInfoLabel.text = keHuInfoModel.YiXiang; // 购房意向
    // 隐藏报备按钮，显示打电话按钮
    self.reportedBtn.hidden = YES;
    self.callBtn.hidden = NO;
    
    /**
     *  互动信息相关拼接和显示
     *  首先判断有没有互动信息，有则显示，否则隐藏互动信息这块内容
     */
    if (![WXZChectObject checkWhetherStringIsEmpty:keHuInfoModel.hdTime] || ![WXZChectObject checkWhetherStringIsEmpty:keHuInfoModel.typebig] || ![WXZChectObject checkWhetherStringIsEmpty:keHuInfoModel.loupan])
    {
        NSString *dateStr = keHuInfoModel.hdTime; // 获取互动时间
        dateStr = [WXZStringObject replacementString:dateStr replace:@"/" replaced:@"-"]; // 替换字符
        NSDate *date = [WXZDateObject formatDate1:dateStr dateFormat:@"yyyy-MM-dd HH:mm:ss"]; // 格式化为NSDate
        NSString *dateStr2 = [WXZDateObject formatDate2:date dateFormat:@"yy-MM-dd HH:mm"]; // 格式化为NSString
        // 格式化字符串（最终结果）
        NSString *footerStr = [NSString stringWithFormat:@"%@ %@ %@",dateStr2,keHuInfoModel.typebig,keHuInfoModel.loupan]; // 拼接最新互动信息
        
        self.footerViews.hidden = NO; // 不隐藏最新互动信息底层view
        self.yixiangLabel.text = footerStr; // 展示拼接好的最新互动信息
    }
    else
    {
        self.footerViews.hidden = YES; // 隐藏最新互动信息底层view
        self.yixiangLabel.text = @""; // 不展示最新互动信息
    }
}

// 报备/打电话事件
- (IBAction)reportedOrCallAction:(UIButton *)sender
{
    if (sender.tag == 100024)
    {
        // 报备事件，push到报备页面
        WXZReportPreparationVC *reportVC = [[WXZReportPreparationVC alloc] init];
        [_controller.navigationController pushViewController:reportVC animated:YES];
    }
    else
    {
        // 打电话事件方法一（可能是私有方法）
        NSString *phoneNumStr = [NSString stringWithFormat:@"telprompt://%@",self.customerPhoneLabel.text];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumStr]];
        // 打电话方法二
//        [self dialPhoneNumber:self.customerPhoneLabel.text];
    }
}

#pragma mark - 打电话方法二
- (void) dialPhoneNumber:(NSString *)aPhoneNumber
{
    NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",aPhoneNumber]];
    if ( !_phoneCallWebView ) {
        _phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
    }
    [_phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
}

- (void) dealloc
{
    // cleanup
    _phoneCallWebView = nil;
}
#pragma mark - end

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
