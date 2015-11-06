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

// 更新数据
- (void)showKeHuListInfo:(NSDictionary *)dic
{
    self.customerNameLabel.text = dic[@"XingMing"]; // 姓名
    self.customerPhoneLabel.text = dic[@"Mobile"]; // 电话
    
    /**
     *  房源信息：
     *  1. 判断内容是否为空
     *  2. 判断内容里是否包含“/”,并进行替换
     *  3. 拼接字符串
     */
    NSString *houseStr = @"";
    if (![WXZChectObject checkWhetherStringIsEmpty:dic[@"QuYu"]])
    {
        NSString *quyu = dic[@"QuYu"];
        if ([WXZStringObject whetherStringContainsCharacter:quyu character:@"/"])
        {
            quyu = [WXZStringObject replacementString:quyu replace:@"/" replaced:@"|"];
        }
        houseStr = [houseStr stringByAppendingFormat:@"%@，",quyu];
    }
    if (![WXZChectObject checkWhetherStringIsEmpty:dic[@"Hx"]])
    {
        NSString *hx = dic[@"Hx"];
        if ([WXZStringObject whetherStringContainsCharacter:hx character:@"/"])
        {
            hx = [WXZStringObject replacementString:hx replace:@"/" replaced:@"|"];
        }
        houseStr = [houseStr stringByAppendingFormat:@"%@|",hx];
    }
    if (![WXZChectObject checkWhetherStringIsEmpty:dic[@"loupan"]])
    {
        NSString *loupan = dic[@"loupan"];
        if ([WXZStringObject whetherStringContainsCharacter:loupan character:@"/"])
        {
            loupan = [WXZStringObject replacementString:loupan replace:@"/" replaced:@"|"];
        }
        houseStr = [houseStr stringByAppendingFormat:@"%@，",dic[@"loupan"]];
    }
    if (![WXZChectObject checkWhetherStringIsEmpty:dic[@"YiXiang"]])
    {
        houseStr = [houseStr stringByAppendingFormat:@"%@万",dic[@"YiXiang"]];
    }
    self.houseInfoLabel.text = houseStr;
    
    self.reportedBtn.hidden = YES;
    self.callBtn.hidden = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
