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

@interface WXZFindPasswordController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *verificationCode;
@property (weak, nonatomic) IBOutlet UITextField *resetPassword;
@property (weak, nonatomic) IBOutlet UIButton *getVerificationCode_button;

@end

@implementation WXZFindPasswordController
// 获取验证码
- (IBAction)getVerificationCode:(id)sender {
    
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
    // 0.请求路径
    // 基本URL
    NSString *baseURL = OutNetBaseURL;
    NSString *urlString = [baseURL stringByAppendingString:zhaohuimima];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    // URL
    NSURL *url = [NSURL URLWithString:urlString];
    
    // 1.创建请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    NSString *parameter = [NSString stringWithFormat:@"mob=%@&pas=%@&yzm=%@",self.phoneNumber.text, self.resetPassword.text, self.verificationCode.text];
    request.HTTPBody = [parameter dataUsingEncoding:NSUTF8StringEncoding];
    
    
    // 2.发送请求
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            // 3.解析服务器返回的数据（解析成字符串）
//            WXZLog(@"%@", data);
            NSDictionary *loginContentDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            // 获取用户信息
//            WXZLog(@"Act=GetPass");
            WXZLog(@"%@", loginContentDic);
        
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
// 取消键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.phoneNumber resignFirstResponder];
    [self.verificationCode resignFirstResponder];
    [self.resetPassword resignFirstResponder];
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


@end
