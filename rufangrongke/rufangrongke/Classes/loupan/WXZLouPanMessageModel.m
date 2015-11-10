//
//  WXZLouPanMessageModel.m
//  rufangrongke
//
//  Created by 儒房融科 on 15/11/10.
//  Copyright © 2015年 王晓植. All rights reserved.
//

#import "WXZLouPanMessageModel.h"

@implementation WXZLouPanMessageModel

@end


@implementation View

+ (NSDictionary *)objectClassInArray{
    return @{@"pics" : [Pics class], @"hxs" : [Hxs class]};
}

@end


@implementation Pics
+ (NSDictionary *)replacedKeyFromPropertyName
{
    
    return @{@"ID" : @"id"};
    
}

@end


@implementation Hxs
+ (NSDictionary *)replacedKeyFromPropertyName
{
    
    return @{@"ID" : @"id"};
    
}

@end


