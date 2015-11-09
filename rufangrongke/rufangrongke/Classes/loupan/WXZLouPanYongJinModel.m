//
//  WXZLouPanYongJinModel.m
//  rufangrongke
//
//  Created by 儒房融科 on 15/11/9.
//  Copyright © 2015年 王晓植. All rights reserved.
//

#import "WXZLouPanYongJinModel.h"

@implementation WXZLouPanYongJinModel


+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [ListYongJin class]};
}
@end
@implementation KfsgzYongjin

@end


@implementation ListYongJin
+ (NSDictionary *)replacedKeyFromPropertyName
{
    
    return @{@"ID" : @"id"};
    
}
@end


