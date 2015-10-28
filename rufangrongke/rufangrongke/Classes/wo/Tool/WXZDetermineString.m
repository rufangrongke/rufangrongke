//
//  WXZDetermineString.m
//  rufangrongke
//
//  Created by 儒房融科 on 15/10/27.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

#import "WXZDetermineString.h"

@implementation WXZDetermineString

// 判断字符串是否为空
+ (BOOL)determineString:(NSString *)str
{
    if ([str isEqualToString:@""] || str == nil || [str isEqual:[NSNull null]])
    {
        NSLog(@"字符串不能为空");
        return YES;
    }
    return NO;
}
// 是否超出规定范围
+ (BOOL)isBeyondTheScopeOf:(NSInteger)length string:(NSString *)str
{
    if (str.length > length)
    {
        NSLog(@"字符串超出规定范围");
        return YES;
    }
    return NO;
}

@end
