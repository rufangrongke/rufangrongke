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
#import "AFNetworking.h"

@interface WXZLoginController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameField;

@property (weak, nonatomic) IBOutlet UITextField *pwdField;
@property (weak, nonatomic) IBOutlet UIButton *showHideCode_Button;

@end

@implementation WXZLoginController

// 隐藏或者显示密码
- (IBAction)showHideCode:(id)sender {
    // 隐藏或者显示密码
    // 默认是隐藏
    UIButton *btn = (UIButton *)sender;
    if (self.pwdField.secureTextEntry) {
        self.pwdField.secureTextEntry = NO;
        btn.selected = YES;
    }else{
        self.pwdField.secureTextEntry = YES;
        btn.selected = NO;
    }
}


- (IBAction)login:(id)sender {
    
//    // 检测用户名
//    NSString *username = self.usernameField.text;
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    [defaults setObject:username forKey:@"phoneNumber"];
//    if (username.length == 0) {
//        [SVProgressHUD showErrorWithStatus:self.usernameField.placeholder];
//        return;
//    }
//    
//    // 检测密码
//    NSString *pwd = self.pwdField.text;
//    [defaults setObject:pwd forKey:@"password"];
//    if (pwd.length == 0) {
//        [SVProgressHUD showErrorWithStatus:self.pwdField.placeholder];
//        return;
//    }
    
    // 显示HUD
    [SVProgressHUD showWithStatus:@"登录中..." maskType:SVProgressHUDMaskTypeBlack];
    
    
    // 1.创建请求对象
    NSString *urlString = [OutNetBaseURL stringByAppendingString:denglu];
    
    
    // 18833198077   18311281581   17701261104 18310532603
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"mob"] = @"18311281581";
    parameters[@"pas"] = @"1234567";
    // afn
    [[AFHTTPSessionManager manager] POST:urlString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *loginContentDic = (NSDictionary *)responseObject;
        // 获取沙河路径
        NSString *userinfoPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingString:userinfoFile];
        // 获取用户信息
        NSDictionary *userinfo = loginContentDic[@"u"];
        // 讲用户信息写入字典
        [userinfo writeToFile:userinfoPath atomically:YES];
        
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
            
        }];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [SVProgressHUD showErrorWithStatus:@"登陆超时,请重新登陆." maskType:SVProgressHUDMaskTypeBlack];
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
