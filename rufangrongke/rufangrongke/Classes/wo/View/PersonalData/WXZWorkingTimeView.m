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
    if ([UIScreen mainScreen].bounds.size.width == 320)
    {
        self.bgView.frame = CGRectMake(12, 40, 320-24, 320-24+1);
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
