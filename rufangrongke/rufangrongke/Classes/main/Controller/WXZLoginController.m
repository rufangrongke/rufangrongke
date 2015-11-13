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
#import "WXZChectObject.h"

@interface WXZLoginController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *usernameField;

@property (weak, nonatomic) IBOutlet UITextField *pwdField;
@property (weak, nonatomic) IBOutlet UIButton *showHideCode_Button;
@property (weak, nonatomic) IBOutlet UIButton *remenberPasswordBtn;
@property (weak, nonatomic) IBOutlet UIButton *autoLoginBtn;

@end

@implementation WXZLoginController

// 隐藏或者显示密码
- (IBAction)showHideCode:(UIButton *)sender {
    // 隐藏或者显示密码
    // 默认是隐藏
//    UIButton *btn = (UIButton *)sender;
    if (self.pwdField.secureTextEntry) {
        self.pwdField.secureTextEntry = NO;
        sender.selected = YES;
    }else{
        self.pwdField.secureTextEntry = YES;
        sender.selected = NO;
    }
}
#pragma 记住密码
- (IBAction)remenberPassword:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (self.remenberPasswordBtn.selected == NO) { // 取消记住密码
        // 取消自动登录
        [self.autoLoginBtn setSelected:NO];
    }
}
#pragma 自动登录
- (IBAction)autoLogin:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (self.autoLoginBtn.selected == YES) { // 取消记住密码
        // 取消自动登录
        [self.remenberPasswordBtn setSelected:YES];
    }
}

- (IBAction)login:(id)sender {
    
    // 检测用户号码
    NSString *username = @"18311281581";
//    NSString *username = self.usernameField.text;
    //    if (username.length == 0) {
    //        [SVProgressHUD showErrorWithStatus:self.usernameField.placeholder];
    //        return;
    //    }

//    if (![WXZChectObject checkPhone2:self.usernameField.text withTipInfo:@"手机号格式不正确"])
//        return;
    // 号码符合规范
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:username forKey:@"phoneNumber"];
    
    // 检测密码
//    NSString *pwd = self.pwdField.text;
    NSString *pwd = @"123456";
    [defaults setObject:pwd forKey:@"password"];
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
    parameters[@"pas"] = @"123456";
    // 17701261104
//    parameters[@"mob"] = @"17701261104"; // 18833198078
//    parameters[@"pas"] = @"123456";
    // afn
    [[AFHTTPSessionManager manager] POST:urlString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *loginContentDic = (NSDictionary *)responseObject;
        // 获取沙河路径
        NSString *userinfoPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingString:userinfoFile];
        // 获取用户信息
        NSDictionary *userinfo = loginContentDic[@"u"];
//        WXZLog(@"%@",loginContentDic[@"u"]);
        // 将用户信息写入字典
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

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (self.usernameField)
    {
        if (range.location > 11)
        {
            return NO;
        }
    }
    return YES;
}

// 隐藏导航栏
- (void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.usernameField.delegate = self;
//    WXZLog(@"self.view.height-%f, textField.y-%f, textField.height-%f", self.view.frame.size.height, self.usernameField.frame.origin.y, self.usernameField.frame.size.height);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma 找回密码
- (IBAction)findPassWord:(id)sender {
    WXZLogFunc;
    // 添加找回密码控制器
    [self.navigationController pushViewController:[[WXZFindPasswordController alloc] init] animated:YES];
}
#pragma 注册
- (IBAction)registerAccount:(id)sender {
    WXZLogFunc;
    // 添加注册控制器
    [self.navigationController pushViewController:[[WXZRegisterController alloc] init] animated:YES];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.usernameField resignFirstResponder];
    [self.pwdField resignFirstResponder];
}

#pragma 键盘处理 不遮盖textfield
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    WXZLogFunc;
    CGFloat offset = self.view.height - (260 + textField.height + 216 +50);
    WXZLog(@"self.view.height-%f, textField.y-%f, textField.height-%f", self.view.height, textField.y, textField.height);
    WXZLog(@"%f", offset);
    if (offset <= 0) {
        [UIView animateWithDuration:0.3 animations:^{
            self.view.y = offset;
        }];
    }
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    WXZLogFunc;
    [UIView animateWithDuration:0.3 animations:^{
        self.view.y = 0;
    }];
    return YES;
}
@end
