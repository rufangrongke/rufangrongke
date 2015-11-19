//
//  WXZWorkingTimeView.m
//  rufangrongke
//
//  Created by 儒房融科 on 15/10/29.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

#import "WXZWorkingTimeView.h"

@implementation WXZWorkingTimeView

- (void)awakeFromNib
{
    if (WXZ_ScreenWidth == 320 || WXZ_ScreenWidth == 414)
    {
        self.bgView.frame = CGRectMake(12, 40, WXZ_ScreenWidth-24, WXZ_ScreenWidth-23-64);
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
