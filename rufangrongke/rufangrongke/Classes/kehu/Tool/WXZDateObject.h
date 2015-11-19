//
//  WXZDateObject.h
//  rufangrongke
//
//  Created by 儒房融科 on 15/11/4.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

/**
 * 日期对象格式化类
 **/

#import <Foundation/Foundation.h>

@interface WXZDateObject : NSObject

+ (NSDate *)formatDate1:(NSString *)dateStr dateFormat:(NSString *)format;
+ (NSString *)formatDate2:(NSDate *)date dateFormat:(NSString *)format;

@end
