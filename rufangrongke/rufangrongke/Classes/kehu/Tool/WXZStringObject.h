//
//  WXZStringObject.h
//  rufangrongke
//
//  Created by 儒房融科 on 15/11/4.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WXZStringObject : NSObject

+ (NSArray *)interceptionOfString:(NSString *)str interceptType:(NSString *)type; // 按“/”等截取字符串

+ (NSString *)interceptionOfARangeOfString:(NSString *)str  range:(NSRange)range; // 截取一定范围的字符串

+ (NSString *)string2:(NSString *)str fromIndex:(NSInteger)fIndex toIndex:(NSInteger)tIndex; // 截取从一个索引到另一个索引的字符串

+ (NSString *)replacementString:(NSString *)str replace:(NSString *)replace replaced:(NSString *)replaced; // 按“/”替换字符串为“-”等
+ (NSString *)stringConcatenation:(NSString *)str stitchingFormat:(NSString *)format; // 拼接字符串

+ (BOOL)whetherStringContainsCharacter:(NSString *)str character:(NSString *)character; // 判断字符串里边是否包含某个字符

+ (NSString *)whetherStringContainsCharacter2:(NSString *)str character:(NSString *)character; // 判断字符串最后是否为某个字符,并进行修改

+ (NSString *)pinJieString1:(NSMutableArray *)arr; // 遍历并拼接字符串

+ (NSString *)pinJieString2:(NSMutableArray *)arr array2:(NSMutableArray *)arr; // 遍历并拼接字符串

+ (NSArray *)traversalReturnsString:(NSArray *)arr1 allArr:(NSArray *)arr2; // 遍历并返回数组

@end
