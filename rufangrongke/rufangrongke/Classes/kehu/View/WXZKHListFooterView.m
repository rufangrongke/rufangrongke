//
//  WXZKHListFooterView.m
//  rufangrongke
//
//  Created by 儒房融科 on 15/10/24.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

#import "WXZKHListFooterView.h"

@implementation WXZKHListFooterView

// 加载nib文件
+ (instancetype)initListFooterView
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

// footer信息
- (void)footerInfoLabel:(NSString *)info
{
    UILabel *footerInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, WXZ_ScreenWidth-30, self.height)];
    footerInfoLabel.text = info;
    footerInfoLabel.textColor = WXZRGBColor(140, 139, 139);
    footerInfoLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:footerInfoLabel];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
