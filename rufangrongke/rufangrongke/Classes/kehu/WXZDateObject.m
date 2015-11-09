//
//  WXZDateObject.m
//  rufangrongke
//
//  Created by 儒房融科 on 15/11/4.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

#import "WXZDateObject.h"

@implementation WXZDateObject

+ (NSDate *)formatDate1:(NSString *)dateStr dateFormat:(NSString *)format
{
    // A convenience method that formats the date in Year/Month-Year format
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = format; // 格式化方式
    return [formatter dateFromString:dateStr];
}

+ (NSString *)formatDate2:(NSDate *)date dateFormat:(NSString *)format
{
    // A convenience method that formats the date in Year/Month-Year format
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = format; // 格式化方式
    return [formatter stringFromDate:date];
}

@end
