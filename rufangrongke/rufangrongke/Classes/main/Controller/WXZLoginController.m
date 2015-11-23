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
/* default */
@property (nonatomic , strong) NSUserDefaults *defaults;
@end

@implementation WXZLoginController
- (NSUserDefaults *)defaults{
    if (_defaults == nil) {
        _defaults = [NSUserDefaults standardUserDefaults];
    }
    return _defaults;
}
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
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    // 写入上次的状态
//    WXZLog(@"%zd", [defaults boolForKey:@"remenberPasswordBtnStatus"]);
//    WXZLog(@"phoneNumber:%@, password%@", [defaults stringForKey:@"phoneNumber"], [defaults stringForKey:@"password"]);
    sender.selected = [defaults boolForKey:@"remenberPasswordBtnStatus"];
    if (!sender.selected) {
//        self.usernameField.text = @"";
//        self.pwdField.text = @"";
        self.usernameField.text = [defaults stringForKey:@"phoneNumber"] ? [defaults stringForKey:@"phoneNumber"] : self.usernameField.text;
        self.pwdField.text = [defaults stringForKey:@"password"] ? [defaults stringForKey:@"password"] : self.pwdField.text;
    }else{
//        self.usernameField.text = @"";
//        self.pwdField.text = @"";
//        [defaults setObject:@"" forKey:@"phoneNumber"];
//        [defaults setObject:@"" forKey:@"password"];
        
    }
    sender.selected = !sender.selected;
    
    // 记住选中状态
    [defaults setBool:sender.selected forKey:@"remenberPasswordBtnStatus"];
//    WXZLog(@"%zd", [defaults boolForKey:@"remenberPasswordBtnStatus"]);
    if (self.remenberPasswordBtn.selected == NO) { // 取消记住密码
        // 取消自动登录
        [self.autoLoginBtn setSelected:NO];
    }
}
#pragma 自动登录
- (IBAction)autoLogin:(UIButton *)sender {
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    
//    if (sender.selected) {
//        self.pwdField.text = @"";
//    }else{
//        self.pwdField.text = [defaults stringForKey:@"password"];
//    }
    sender.selected = !sender.selected;
    if (self.autoLoginBtn.selected == YES) { // 取消记住密码
        // 取消自动登录
        [self.remenberPasswordBtn setSelected:YES];
    }
}

- (IBAction)login:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    // [defaults stringForKey:@"phoneNumber"] ? [defaults stringForKey:@"phoneNumber"] :
    // 用户名手机号
    NSString *usePhone = self.usernameField.text;
    // 检测用户号码
        if (usePhone.length == 0) {
            [SVProgressHUD showErrorWithStatus:@"请输入手机号"];
            return;
        }
    if (![WXZChectObject checkPhone2:usePhone withTipInfo:@"手机号格式不正确"]){
        return;
    }
    
    // 检测密码
    NSString *pwd = self.pwdField.text;
    if (pwd.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入密码"];
        return;
    }
    
    // 只要点击登陆就会缓存手机号和密码，以供后面使用
    [defaults setObject:usePhone forKey:@"CacheMobile"];
    [defaults setObject:pwd forKey:@"CachePwd"];
    
    // 显示HUD
    [SVProgressHUD showWithStatus:@"登录中..." maskType:SVProgressHUDMaskTypeBlack];
    
    // 1.创建请求对象
    NSString *urlString = [OutNetBaseURL stringByAppendingString:denglu];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"mob"] = usePhone;
    parameters[@"pas"] = pwd;
    // afn
    [[AFHTTPSessionManager manager] POST:urlString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *loginContentDic = (NSDictionary *)responseObject;
        // 获取沙河路径
        NSString *userinfoPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:userinfoFile];
        // 获取用户信息
        NSDictionary *userinfo = loginContentDic[@"u"];
//        WXZLog(@"%@",loginContentDic[@"u"]);
        if ([loginContentDic[@"ok"] isEqualToNumber:@1]) { // 正确登陆
            // 将用户信息写入字典
            [userinfo writeToFile:userinfoPath atomically:YES];
            
            // 存储用户名,存储密码
            if ([defaults boolForKey:@"remenberPasswordBtnStatus"]) {
                [defaults setObject:usePhone forKey:@"phoneNumber"];
                [defaults setObject:pwd forKey:@"password"];
            }else{
                [defaults setObject:@"" forKey:@"phoneNumber"];
                [defaults setObject:@"" forKey:@"password"];
                
            }
        }
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
//        WXZLog(@"%@", error);
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [SVProgressHUD showErrorWithStatus:@"请检查您的网络设置" maskType:SVProgressHUDMaskTypeBlack];
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
    self.remenberPasswordBtn.selected = [self.defaults boolForKey:@"remenberPasswordBtnStatus"];
    if (self.remenberPasswordBtn.selected) {
        self.usernameField.text = [self.defaults stringForKey:@"phoneNumber"];
        self.pwdField.text = [self.defaults stringForKey:@"password"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
#pragma 找回密码
- (IBAction)findPassWord:(id)sender {
    WXZLogFunc;
    // 添加找回密码控制器
    [self.navigationController pushViewController:[[WXZFindPasswordController alloc] init] animated:YES];
}
#pragma 注册
- (IBAction)registerAccount:(id)sender {
//    WXZLogFunc;
    // 添加注册控制器
    [self.navigationController pushViewController:[[WXZRegisterController alloc] init] animated:YES];
}

#pragma mark - 监听键盘
// 不遮盖textfield
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    //    WXZLogFunc;
    CGRect frame = [textField.superview convertRect:textField.frame toView:self.view];
    CGFloat offset = self.view.height - (260 + frame.size.height + frame.origin.y + 20);
    WXZLog(@"self.view.height=%f, textField.y=%f, textField.height=%f", self.view.height, textField.y, textField.height);
    WXZLog(@"%f", offset);
    if (offset <= 0) {
        [UIView animateWithDuration:0.3 animations:^{
            self.view.y = offset;
        }];
    }
    return YES;
}

// 点击return 搜索
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // 将view回置
    [UIView animateWithDuration:0.3 animations:^{
        WXZLog(@"%zd", self.view.y);
        self.view.y = 0;
        WXZLog(@"%zd", self.view.y);
        
    }];
    // 取消键盘
    [textField resignFirstResponder];
    // 最后一个textField == yaoqingren 注册
    if (textField == self.pwdField) {
        [self login:nil];
    }
    return YES;
}

// 取消键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.usernameField resignFirstResponder];
    [self.pwdField resignFirstResponder];
    // 将view回置
    [UIView animateWithDuration:0.3 animations:^{
        WXZLog(@"%zd", self.view.y);
        self.view.y = 0;
        WXZLog(@"%zd", self.view.y);
        
    }];
}
@end
