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

@interface WXZFindPasswordController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *verificationCode;
@property (weak, nonatomic) IBOutlet UITextField *resetPassword;
@property (weak, nonatomic) IBOutlet JxbScaleButton *getVerificationCode_button;

@end

@implementation WXZFindPasswordController
// 获取验证码
- (IBAction)getVerificationCode:(id)sender {
    // 0.请求路径
    // 基本URL
    NSString *baseURL = OutNetBaseURL;
    NSString *urlString = [baseURL stringByAppendingString:yanzhengma];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    // URL
    NSURL *url = [NSURL URLWithString:urlString];
    
    // 1.创建请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    NSString *parameter = [NSString stringWithFormat:@"Act=GetPass&Mobile=%@",self.phoneNumber.text];
    request.HTTPBody = [parameter dataUsingEncoding:NSUTF8StringEncoding];
    
    
    // 2.发送请求
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        // 3.解析服务器返回的数据（解析成字符串）
//        WXZLog(@"%@", data);
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        // 获取用户信息
        WXZLog(@"%@", dic);
        
        if ([dic[@"msg"] isEqualToString:@"发送成功"]) {
            JxbScaleSetting* setting = [[JxbScaleSetting alloc] init];
            setting.strPrefix = @"";
            setting.strSuffix = @"秒";
            setting.strCommon = @"重新发送";
            setting.indexStart = [dic[@"timeout"] integerValue];
            [self.getVerificationCode_button startWithSetting:setting];
//            [self.view setNeedsDisplay];
        }else{
            [SVProgressHUD showErrorWithStatus:dic[@"msg"]];
        }
        /*
         {
         status : 1,
         msg : 发送成功,
         timeout : 300
         }
         
         */

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
    
    // 倒计时按钮
    self.getVerificationCode_button = [[JxbScaleButton alloc] init];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
// 取消键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.phoneNumber resignFirstResponder];
    [self.verificationCode resignFirstResponder];
    [self.resetPassword resignFirstResponder];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
