//
//  WXZStringObject.m
//  rufangrongke
//
//  Created by 儒房融科 on 15/11/4.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

#import "WXZStringObject.h"

@implementation WXZStringObject

// 按“/”等截取字符串
+ (NSArray *)interceptionOfString:(NSString *)str  interceptType:(NSString *)type
{
    return [str componentsSeparatedByString:@"-"];
}

// 截取一定范围的字符串
+ (NSString *)interceptionOfARangeOfString:(NSString *)str range:(NSRange)range
{
    return [str substringWithRange:range];
}

// 截取从一个索引到另一个索引的字符串
+ (NSString *)string2:(NSString *)str fromIndex:(NSInteger)fIndex toIndex:(NSInteger)tIndex
{
    [str substringFromIndex:fIndex];
    [str substringToIndex:tIndex];
    return str;
}

// 按“/”替换字符串为“-”等
+ (NSString *)replacementString:(NSString *)str replace:(NSString *)replace replaced:(NSString *)replaced
{
    return [str stringByReplacingOccurrencesOfString:replace withString:replaced];
}

// 拼接字符串
+ (NSString *)stringConcatenation:(NSString *)str stitchingFormat:(NSString *)format
{
    return [NSString stringWithFormat:format,str];
}

// 判断字符串里边是否包含某个字符
+ (BOOL)whetherStringContainsCharacter:(NSString *)str character:(NSString *)character
{
    if ([str rangeOfString:character].location != NSNotFound)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

// 遍历并拼接字符串
+ (NSString *)pinJieString1:(NSMutableArray *)arr
{
    [arr sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return obj1 > obj2;
    }];
    
    NSString *str = @"";
    if (arr.count > 1)
    {
        for (int i = 0; i < arr.count; i++)
        {
//            NSSortDescriptor* sortByA = [NSSortDescriptor sortDescriptorWithKey:keystring ascending:isAscending];
//            NSMutableArray * arrm = [[NSMutableArray alloc]initWithArray:[self.sourceArry sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortByA]]];
            if (i == arr.count-1)
            {
                str = [str stringByAppendingFormat:@"%@,",arr[i]];
            }
            else
            {
                str = [str stringByAppendingFormat:@"%@/",arr[i]];
            }
        }
        return str;
    }
    else if (arr.count == 1)
    {
        return str = [str stringByAppendingFormat:@"%@,",arr[0]];
    }
    return str = @"";
}

// 遍历并拼接字符串
+ (NSString *)pinJieString2:(NSMutableArray *)arr1 array2:(NSMutableArray *)arr2
{
    NSString *str = @"";
    if (arr1.count > 1)
    {
        for (int i = 0; i < arr1.count; i++)
        {
            str = [str stringByAppendingFormat:@"%@/",arr1[i]];
            if (i == arr1.count-1)
            {
                str = [str stringByAppendingFormat:@"%@",arr1[i]];
            }
        }
        return str;
    }
    return str = [str stringByAppendingFormat:@"%@,",arr1[0]];
}

@end
