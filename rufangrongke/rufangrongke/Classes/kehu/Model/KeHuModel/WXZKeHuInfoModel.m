//
//  WXZKeHuInfoModel.m
//  rufangrongke
//
//  Created by 儒房融科 on 15/11/10.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

#import "WXZKeHuInfoModel.h"

@implementation WXZKeHuInfoModel

// 转换id（把id转换成ID）
+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"ID" : @"id"};
}

@end
