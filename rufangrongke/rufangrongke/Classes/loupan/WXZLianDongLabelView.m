//
//  WXZLianDongLabelView.m
//  rufangrongke
//
//  Created by 儒房融科 on 15/11/5.
//  Copyright © 2015年 王晓植. All rights reserved.
//

#import "WXZLianDongLabelView.h"

@implementation WXZLianDongLabelView

+ (instancetype)lianDongLabelView
{
    return [[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
}

@end
