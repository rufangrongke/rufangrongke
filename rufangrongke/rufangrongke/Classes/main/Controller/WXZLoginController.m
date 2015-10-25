//
//  WXZLoginController.m
//  rufangrongke
//
//  Created by 儒房融科 on 15/10/22.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

#import "WXZLoginController.h"
#import <SVProgressHUD.h>
#import "WXZTabBarController.h"
#import "WXZRegisterController.h"
#import "WXZFindPasswordController.h"

@interface WXZLoginController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameField;

@property (weak, nonatomic) IBOutlet UITextField *pwdField;

@end

@implementation WXZLoginController
- (IBAction)login:(id)sender {
    
//    // 检测用户名
//    NSString *username = self.usernameField.text;
//    if (username.length == 0) {
//        [SVProgressHUD showErrorWithStatus:self.usernameField.placeholder];
//        return;
//    }
//    
//    // 检测密码
//    NSString *pwd = self.pwdField.text;
//    if (pwd.length == 0) {
//        [SVProgressHUD showErrorWithStatus:self.pwdField.placeholder];
//        return;
//    }
    
    // 显示HUD
    [SVProgressHUD showWithStatus:@"登录中..." maskType:SVProgressHUDMaskTypeBlack];
    
    // 0.请求路径
    // 基本URL
    NSString *baseURL = @"http://linshi.benbaodai.com/svs/";
    NSString *urlString = [baseURL stringByAppendingString:@"Uslogin.ashx"];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    // URL
    NSURL *url = [NSURL URLWithString:urlString];
    //    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://192.168.1.21:34/Svs/Uslogin.ashx?mob=18833198077&pas=123456"]];
    //    NSLog(@"%@", url);
    
    // 1.创建请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    request.HTTPBody = [@"mob=18833198077&pas=123456" dataUsingEncoding:NSUTF8StringEncoding];

    
    // 2.发送请求
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        // 3.解析服务器返回的数据（解析成字符串）
        NSDictionary *loginContentDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
//        WXZLog(@"%@", loginContentDic);
        
        
        // 4.回到主线程
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            if ([loginContentDic[@"ok"] isEqualToNumber:@1]) { // 正确登陆
                // 隐藏HUD
                [SVProgressHUD dismiss];
                
                // 添加tabBarcontroller
                WXZTabBarController *tabBarController = [[WXZTabBarController alloc]init];
                [[[[UIApplication sharedApplication] delegate] window] setRootViewController:tabBarController];
                
            }else{ //登陆失败
                [SVProgressHUD showErrorWithStatus:@"用户名或者密码错误" maskType:SVProgressHUDMaskTypeBlack];
            }
            
            // 显示一些提示信息
//            NSUInteger loc = [string rangeOfString:@"\":\""].location + 3;
//            NSUInteger len = [string rangeOfString:@"\"}"].location - loc;
//            NSString *msg = [string substringWithRange:NSMakeRange(loc, len)];
//            if ([string containsString:@"success"]) {
//                [SVProgressHUD showSuccessWithStatus:msg];
//            } else {
//                [SVProgressHUD showErrorWithStatus:msg];
//            }
        }];
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 隐藏导航栏
    [self.navigationController setNavigationBarHidden:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)findPassWord:(id)sender {
    // 添加找回密码控制器
    [self.navigationController pushViewController:[[WXZFindPasswordController alloc] init] animated:YES];
}

- (IBAction)registerAccount:(id)sender {
    // 添加注册控制器
    [self.navigationController pushViewController:[[WXZRegisterController alloc] init] animated:YES];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.usernameField resignFirstResponder];
    [self.pwdField resignFirstResponder];
}

@end
