//
//  UIViewController+WXZLogin.m
//  rufangrongke
//
//  Created by 儒房融科 on 15/10/26.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

#import "UIViewController+WXZLogin.h"

@implementation UIViewController (WXZLogin)
- (NSDictionary *)loginMessage
{
    // 0.请求路径
    // 基本URL
//    NSString *baseURL = @"http://linshi.benbaodai.com/svs/";
//    NSString *urlString = [baseURL stringByAppendingString:@"Uslogin.ashx"];
//    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    // URL
//    NSURL *url = [NSURL URLWithString:urlString];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://192.168.1.21:34/Svs/Uslogin.ashx?mob=18833198077&pas=123456"]];
    //    NSLog(@"%@", url);
    
    // 1.创建请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
//    request.HTTPMethod = @"POST";
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSString *parameter = [NSString stringWithFormat:@"mob=%@&pas=%@",[defaults objectForKey:@"phoneNumber"],[defaults objectForKey:@"password"]];
//    request.HTTPBody = [@"mob=18833198077&pas=123456" dataUsingEncoding:NSUTF8StringEncoding];
    
    __block NSMutableDictionary *loginContentDic = [NSMutableDictionary dictionary];
    // 2.发送请求
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        loginContentDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        
        // 获取沙河路径
        NSString *userInfoPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingString:userinfoFile];
        // 获取用户信息
        NSDictionary *userInfo = loginContentDic[@"u"];
        // 将用户信息写入字典
        [userInfo writeToFile:userInfoPath atomically:YES];
        
//        return dic;
//        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//            return dic
//        }];
    }];
    
    return nil;
   
}

- (void)loginRequest:(loginMessage)message
{
    // 基本URL
    NSString *urlString = [OutNetBaseURL stringByAppendingString:@"Uslogin.ashx"];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    // URL
    NSURL *url = [NSURL URLWithString:urlString];
    
    // 1.创建请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    request.HTTPBody = [@"mob=18833198077&pas=123456" dataUsingEncoding:NSUTF8StringEncoding];
    
    // 2.发送请求
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
    {
        if (data != nil)
        {
            // 3.解析服务器返回的数据（解析成字符串）
            NSDictionary *loginContentDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            WXZLog(@"%@", loginContentDic);
            
            // 获取沙河路径
            NSString *userinfoPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingString:userinfoFile];
            // 获取用户信息
            NSDictionary *userinfo = loginContentDic[@"u"];
            // 讲用户信息写入字典
            [userinfo writeToFile:userinfoPath atomically:YES];
            
            message(userinfo);
        }
        else
        {
            message(@"请求失败");
        }
    }];
}

- (NSDictionary *)localUserInfo
{
    NSString *userinfoPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingString:userinfoFile];

    return [NSDictionary dictionaryWithContentsOfFile:userinfoPath];
}

@end
