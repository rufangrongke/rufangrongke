//
//  WXZChectObject.h
//  rufangrongke
//
//  Created by 儒房融科 on 15/11/2.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WXZChectObject : NSObject

+ (BOOL)checkWhetherStringIsEmpty:(NSString *)str; // 检查字符串是否为空

+ (BOOL)checkWhetherStringIsEmpty:(NSString *)str withTipInfo:(NSString *)tip; // 检查字符串是否为空

+ (BOOL)isBeyondTheScopeOf:(NSInteger)length string:(NSString *)str; // 检查是否超出范围

+ (BOOL)isBeyondTheScopeOf:(NSInteger)length string:(NSString *)str withTipInfo:(NSString *)tip; // 检查是否超出范围

+(BOOL)checkEmail:(NSString *)email; // 邮件--

+(BOOL)checkPhone:(NSString *)mobileNum; // 电话－方法一

+(BOOL)checkPhone2:(NSString *)mobileNum withTipInfo:(NSString *)tip; // 电话－方法二

+(BOOL)checkEmailCode:(NSString *)emaliCode; // --邮编

+(BOOL)checkPassWordLength:(NSString *)pwd; // 密码长度

+(BOOL)checkPassWordInputBoxIsNil:(NSString *)oldPwd withNewPwd:(NSString *)newPwd; // 检查密码输入框是否为空

+(BOOL)checkSpace:(NSString *)text; // 判断空格

+(BOOL)checkIsAllNumber:(NSString *)numberString; // 判断是否为纯数字

@end
