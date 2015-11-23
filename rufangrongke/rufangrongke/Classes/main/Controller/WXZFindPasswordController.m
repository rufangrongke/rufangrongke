//
//  WXZFindPasswordController.m
//  rufangrongke
//
//  Created by 儒房融科 on 15/10/25.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

#import "WXZFindPasswordController.h"
#import "JxbScaleButton.h"
#import <SVProgressHUD.h>
#import "AFNetworking.h"
#import "WXZChectObject.h"

@interface WXZFindPasswordController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *verificationCode;
@property (weak, nonatomic) IBOutlet UITextField *resetPassword;
@property (weak, nonatomic) IBOutlet UIButton *getVerificationCode_button;

@end

@implementation WXZFindPasswordController
// 获取验证码
- (IBAction)getVerificationCode:(id)sender {
    if (![WXZChectObject checkPhone2:self.phoneNumber.text withTipInfo:@"请输入正确手机号"])
    {return;}
    
    // 蒙版
    [SVProgressHUD show];
    // 请求路径
    NSString *urlString = [OutNetBaseURL stringByAppendingString:yanzhengma];
    // AFNetworking
    NSMutableDictionary *parameterS = [NSMutableDictionary dictionary];
    parameterS[@"Act"] = @"GetPass";
    parameterS[@"Mobile"] = self.phoneNumber.text;
    [[AFHTTPSessionManager manager] POST:urlString parameters:parameterS success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dic = (NSDictionary *)responseObject;
        WXZLog(@"%@",responseObject);
        if ([dic[@"msg"] isEqualToString:@"发送成功"]) {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self countdownWithTimeOut:dic[@"timeout"]];
                [SVProgressHUD showSuccessWithStatus:@"验证码已发送,请稍等..."];
            }];
            
        }else{
            [SVProgressHUD showErrorWithStatus:dic[@"msg"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        WXZLog(@"%@", error);
        [SVProgressHUD showErrorWithStatus:@"请求失败"];
    }];

}
// 点击确定,找回密码
- (IBAction)findPassword:(id)sender {
    if (self.verificationCode.text.length != 6) {
        [SVProgressHUD showErrorWithStatus:@"请输入6位验证码"];
        return;
    }
    // 蒙版
    [SVProgressHUD show];
    // 1.创建请求对象
    NSString *urlString = [OutNetBaseURL stringByAppendingString:zhaohuimima];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"mob"] = self.phoneNumber.text;
    parameters[@"pas"] = self.resetPassword.text;
    parameters[@"yzm"] = self.verificationCode.text;
    // afnetworking
    [[AFHTTPSessionManager manager] POST:urlString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *loginContentDic = (NSDictionary *)responseObject;
        WXZLog(@"%@", responseObject);
        if ([loginContentDic[@"ok"] isEqualToNumber:@(0)]) {
            [SVProgressHUD showErrorWithStatus:@"修改失败" maskType:SVProgressHUDMaskTypeBlack];
        }else{
            [SVProgressHUD showSuccessWithStatus:@"修改成功" maskType:SVProgressHUDMaskTypeBlack];
            [self.resetPassword resignFirstResponder];
            [self.phoneNumber resignFirstResponder];
            [self.verificationCode resignFirstResponder];
        }
        
//        // 4.回到主线程
//        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//            if ([loginContentDic[@"ok"] isEqualToNumber:@1]) { // 正确登陆
//                // 隐藏HUD
//                [SVProgressHUD dismiss];
//                
//                // 添加tabBarcontroller
//                WXZTabBarController *tabBarController = [[WXZTabBarController alloc]init];
//                [[[[UIApplication sharedApplication] delegate] window] setRootViewController:tabBarController];
//                
//            }else{ //登陆失败
//                [SVProgressHUD showErrorWithStatus:@"用户名或者密码错误" maskType:SVProgressHUDMaskTypeBlack];
//            }
//            
//        }];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [SVProgressHUD showErrorWithStatus:@"登陆超时,请重新登录." maskType:SVProgressHUDMaskTypeBlack];
        }];
    }];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 显示导航栏
    [self.navigationController setNavigationBarHidden:NO];
    
    // 设置导航栏标题
    self.navigationItem.title = @"找回密码";
    // 倒计时按钮
//    self.getVerificationCode_button = [[JxbScaleButton alloc] init];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (IBAction)showHidenPwd:(UIButton *)sender {
    // 隐藏或者显示密码
    // 默认是隐藏
    //    UIButton *btn = (UIButton *)sender;
    if (self.resetPassword.secureTextEntry) {
        self.resetPassword.secureTextEntry = NO;
        sender.selected = YES;
    }else{
        self.resetPassword.secureTextEntry = YES;
        sender.selected = NO;
    }
}
// 倒计时
- (void)countdownWithTimeOut:(NSString *)timeOutStr
{
    int timeOut2 = timeOutStr.intValue;
    __block int timeout = timeOut2; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        
        if(timeout <= 0)
        {
            //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.getVerificationCode_button setTitle:@"获取验证码" forState:UIControlStateNormal];
                self.getVerificationCode_button.userInteractionEnabled = YES;
            });
        }
        else
        {
            int seconds = timeout; // 或 timeout % 300 或 timeout（计算分几次，每次60秒）
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self.getVerificationCode_button setTitle:[NSString stringWithFormat:@"%@秒",strTime] forState:UIControlStateNormal];
                self.getVerificationCode_button.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
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
        self.view.y = 64;
        WXZLog(@"%zd", self.view.y);
        
    }];
    // 取消键盘
    [textField resignFirstResponder];
    // 最后一个textField == yaoqingren 注册
    if (textField == self.resetPassword) {
        [self findPassword:nil];
    }
    return YES;
}

// 取消键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.phoneNumber resignFirstResponder];
    [self.verificationCode resignFirstResponder];
    [self.resetPassword resignFirstResponder];
    // 将view回置
    [UIView animateWithDuration:0.3 animations:^{
        WXZLog(@"%zd", self.view.y);
        self.view.y = 64;
        WXZLog(@"%zd", self.view.y);
        
    }];
}

@end
