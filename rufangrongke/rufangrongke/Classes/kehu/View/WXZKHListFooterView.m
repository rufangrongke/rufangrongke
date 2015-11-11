//
//  WXZKHListFooterView.m
//  rufangrongke
//
//  Created by 儒房融科 on 15/10/24.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

#import "WXZKHListFooterView.h"
#import "WXZChectObject.h"
#import "WXZStringObject.h"
#import "WXZDateObject.h"

@interface WXZKHListFooterView ()

@end

@implementation WXZKHListFooterView

// 加载nib文件
+ (instancetype)initListFooterView
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

- (void)setKeHuInfoModel:(WXZKeHuInfoModel *)keHuInfoModel
{
    UILabel *footerInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, WXZ_ScreenWidth-30, self.height)];
    footerInfoLabel.textColor = WXZRGBColor(140, 139, 139);
    footerInfoLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:footerInfoLabel];
    
    NSString *dateStr = keHuInfoModel.hdTime; // 获取时间
    dateStr = [WXZStringObject replacementString:dateStr replace:@"/" replaced:@"-"]; // 替换字符
    NSDate *date = [WXZDateObject formatDate1:dateStr dateFormat:@"yyyy-MM-dd HH:mm:ss"]; // 格式化为NSDate
    NSString *dateStr2 = [WXZDateObject formatDate2:date dateFormat:@"yy-MM-dd HH:mm"]; // 格式化为NSString
    // 格式化字符串（最终结果）
    NSString *footerStr = [NSString stringWithFormat:@"%@ %@ %@",dateStr2,keHuInfoModel.typebig,keHuInfoModel.loupan];
    footerInfoLabel.text = footerStr;
}

// footer信息
//- (void)footerInfoLabel:(NSDictionary *)info
//{
//    UILabel *footerInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, WXZ_ScreenWidth-30, self.height)];
//    footerInfoLabel.textColor = WXZRGBColor(140, 139, 139);
//    footerInfoLabel.font = [UIFont systemFontOfSize:14];
//    [self addSubview:footerInfoLabel];
//    
//    NSString *dateStr = info[@"hdTime"]; // 获取时间
//    dateStr = [WXZStringObject replacementString:dateStr replace:@"/" replaced:@"-"]; // 替换字符
//    NSDate *date = [WXZDateObject formatDate1:dateStr dateFormat:@"yyyy-MM-dd HH:mm:ss"]; // 格式化为NSDate
//    NSString *dateStr2 = [WXZDateObject formatDate2:date dateFormat:@"yy-MM-dd HH:mm"]; // 格式化为NSString
//    // 格式化字符串（最终结果）
//    NSString *footerStr = [NSString stringWithFormat:@"%@ %@ %@",dateStr2,info[@"typebig"],info[@"loupan"]];
//    footerInfoLabel.text = footerStr;
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
