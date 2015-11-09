//
//  WXZLouPanInformationControllerModel.m
//  rufangrongke
//
//  Created by 儒房融科 on 15/11/6.
//  Copyright © 2015年 王晓植. All rights reserved.
//

#import "WXZLouPanInformationControllerModel.h"
#import <MJExtension.h>
@implementation WXZLouPanInformationControllerModel

+ (NSDictionary *)objectClassInArray{
    return @{@"others" : [OthersModel class]};
}
@end



@implementation OthersModel
+ (NSDictionary *)replacedKeyFromPropertyName
{
    
    return @{@"ID" : @"id"};
    
}
@end


