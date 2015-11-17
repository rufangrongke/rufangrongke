//
//  WXZChectObject.m
//  rufangrongke
//
//  Created by 儒房融科 on 15/11/2.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

#import "WXZChectObject.h"
#import <SVProgressHUD.h>

@implementation WXZChectObject

// 判断字符串是否为空
+ (BOOL)checkWhetherStringIsEmpty:(NSString *)str
{
    if ([str isEqualToString:@""] || str == nil || [str isEqual:[NSNull null]] || [str isEqualToString:@"<null>"] || [str isEqualToString:@"(null)"])
    {
        return YES;
    }
    return NO;
}

// 判断字符串是否为空
+ (BOOL)checkWhetherStringIsEmpty:(NSString *)str withTipInfo:(NSString *)tip
{
    if ([str isEqualToString:@""] || str == nil || [str isEqual:[NSNull null]] || [str isEqualToString:@"<null>"] || [str isEqualToString:@"(null)"])
    {
        [SVProgressHUD showErrorWithStatus:tip maskType:SVProgressHUDMaskTypeBlack];
        return YES;
    }
    return NO;
}

// 是否超出规定范围
+ (BOOL)isBeyondTheScopeOf:(NSInteger)length string:(NSString *)str
{
    if (str.length > length)
    {
        return YES;
    }
    return NO;
}

// 是否超出规定范围
+ (BOOL)isBeyondTheScopeOf:(NSInteger)length string:(NSString *)str withTipInfo:(NSString *)tip
{
    if (str.length > length)
    {
        [SVProgressHUD showErrorWithStatus:tip maskType:SVProgressHUDMaskTypeBlack];
        return YES;
    }
    return NO;
}

// 邮件--
+(BOOL)checkEmail:(NSString *)email{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    if ([emailTest evaluateWithObject:email] == YES) {
        return YES;
    }else{
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"邮箱格式不正确" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        
        return NO;
    }
}

// 电话
+(BOOL)checkPhone:(NSString *)mobileNum{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189,177
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[0235-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|7[0-9]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    //    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    //    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        NSString *msg= @"该手机号不正确";
        if ([mobileNum isEqualToString:@""]||!mobileNum) {
            msg = @"请填写手机号";
        }
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        return NO;
    }
    //    @"[1][3578]\\d{9}"判断手机号的正则表达式
}

// 电话－方法二 判断手机号
+ (BOOL)checkPhone2:(NSString *)mobileNum withTipInfo:(NSString *)tip
{
    if (mobileNum.length == 11)
    {
        if ([WXZChectObject checkIsAllNumber:mobileNum])
        {
            NSString *regex = @"[1][34578]\\d{9}"; // 判断手机号的正则表达式
            NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
            BOOL isMatch = [pred evaluateWithObject:mobileNum];
            if (isMatch)
            {
                return YES;
            }
        }
    }
    [SVProgressHUD showErrorWithStatus:tip maskType:SVProgressHUDMaskTypeBlack];
    return NO;
}

// --邮编
+(BOOL)checkEmailCode:(NSString *)emaliCode{
    const char *cvalue = [emaliCode UTF8String];
    int len = (int)strlen(cvalue);
    if (len != 6) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"邮政编码格式不正确" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        return NO;
    }
    for (int i = 0; i < len; i++)
    {
        if (!(cvalue[i] >= '0' && cvalue[i] <= '9'))
        {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"邮政编码格式不正确" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
            return NO;
        }
    }
    return YES;
    
}

// 密码长度
+(BOOL)checkPassWordLength:(NSString *)pwd{
    
    
    if ([pwd length]>5&&[pwd length]<17) {
        return YES;
    }else{
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"密码长度不正确<6-16位>" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        return NO;
    }
}

// 检查密码输入框是否为空
+(BOOL)checkPassWordInputBoxIsNil:(NSString *)oldPwd withNewPwd:(NSString *)newPwd
{
    //判断两个输入框是否都为空
    if (oldPwd == nil || [oldPwd isEqualToString:@""] || newPwd == nil || [newPwd isEqualToString:@""])
    {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"密码不能为空" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return NO;
    }
    else
    {
        return YES;
    }
}

// 判断空格
+(BOOL)checkSpace:(NSString *)text
{
    NSRange range=[text rangeOfString:@" "];
    int length = (int)range.length;
    if (length>0)
    {
        return NO;
    }
    return YES;
}

// 判断是否为纯数字
+(BOOL)checkIsAllNumber:(NSString*)numberString
{
    NSScanner* scan = [NSScanner scannerWithString:numberString];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

// 判断是否为纯数字
+(BOOL)checkIsAllNumber:(NSString*)numberString withTipInfo:(NSString *)tip
{
    NSScanner* scan = [NSScanner scannerWithString:numberString];
    int val;
    
    if ([scan scanInt:&val] && [scan isAtEnd])
    {
        return YES;
    }
    [SVProgressHUD showErrorWithStatus:tip maskType:SVProgressHUDMaskTypeBlack];
    return NO;
}

// 检查身份证号
+ (BOOL)checkIdCard:(NSString *)idCard
{
    if (![WXZChectObject checkWhetherStringIsEmpty:idCard])
    {
        if (idCard.length == 18)
        {
            NSString *regex = @"^[0-9]{17}[0-9|xX]{1}$"; // 判断身份证号的正则表达式
            NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
            BOOL isMatch = [pred evaluateWithObject:idCard];
            if (isMatch)
            {
                return YES;
            }
        }
        [SVProgressHUD showErrorWithStatus:@"身份证号不足18位或有误，请检查" maskType:SVProgressHUDMaskTypeBlack];
        return NO;
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:@"身份证号不能为空" maskType:SVProgressHUDMaskTypeBlack];
        return NO;
    }
}

@end
