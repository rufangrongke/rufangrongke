//
//  UIViewController+WXZLogin.m
//  rufangrongke
//
//  Created by 儒房融科 on 15/10/26.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

#import "UIViewController+WXZLogin.h"
#import "AFNetworking.h"
#import "WXZLoginController.h"

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

// 登录请求（修改个人资料更新的时候用）
- (void)loginRequest:(loginSuccessMsg)message
{
    // 1.创建请求对象
    NSString *urlString = [OutNetBaseURL stringByAppendingString:denglu];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"mob"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"CacheMobile"]; // 手机号
    param[@"pas"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"CachePwd"]; // 密码
    
    [[AFHTTPSessionManager manager] POST:urlString parameters:param success:^(NSURLSessionDataTask *task, id responseObject)
    {
        if ([responseObject[@"ok"] integerValue] == 1)
        {
            NSDictionary *loginContentDic = (NSDictionary *)responseObject;
            /** 更新登录缓存内容 **/
            // 获取沙河路径
            NSString *userinfoPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:userinfoFile];
            // 获取用户信息
            NSDictionary *userinfo = loginContentDic[@"u"];
            // 将用户信息写入字典
            [userinfo writeToFile:userinfoPath atomically:YES];
            message(userinfo);
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:responseObject[@"msg"] maskType:SVProgressHUDMaskTypeBlack];
            // 判断是否为登录超时，登录超时则返回登录页面重新登录
            if ([responseObject[@"msg"] isEqualToString:@"登录超时"])
            {
                [self goBackLoginPage]; // 回到登录页面
            }
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"请求失败" maskType:SVProgressHUDMaskTypeBlack];
    }];
}

- (NSDictionary *)localUserInfo
{
    NSString *userinfoPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:userinfoFile];
    
    return [NSDictionary dictionaryWithContentsOfFile:userinfoPath];
}

- (void)reloadCityRegionList{
    NSString *url = [OutNetBaseURL stringByAppendingString:quyuliebiao];
    [[AFHTTPSessionManager manager] POST:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
//        WXZLog(@"%@", responseObject);
        NSDictionary *cityListDic = (NSDictionary *)responseObject;
        // 获取沙河路径
        NSString *cityListInfoPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingString:cityListInfoFile];
        // 将用户信息写入字典
        [cityListDic writeToFile:cityListInfoPath atomically:YES];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        WXZLog(@"%@", error);
        // 显示失败信息
//        [SVProgressHUD showErrorWithStatus:@"加载信息失败!"];
    }];
}
- (void)goBackLoginPage{
    // 添加tabBarcontroller
    WXZLoginController *vc = [[WXZLoginController alloc]init];
    [[[[UIApplication sharedApplication] delegate] window] setRootViewController:vc];
}
@end
