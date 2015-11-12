//
//  WXZRegisterController.m
//  rufangrongke
//
//  Created by 儒房融科 on 15/10/25.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

#import "WXZRegisterController.h"
#import "JxbScaleButton.h"
#import "AFNetworking.h"
#import <SVProgressHUD.h>

@interface WXZRegisterController ()
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *verificationCode;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *yaoqingren;
@property (weak, nonatomic) IBOutlet JxbScaleButton *getVerificationCode_Button;

@end

@implementation WXZRegisterController

- (IBAction)huoquyanzhengma:(id)sender {
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
    NSString *parameter = [NSString stringWithFormat:@"Act=Reg&Mobile=%@",self.phoneNumber.text];
    request.HTTPBody = [parameter dataUsingEncoding:NSUTF8StringEncoding];
    
    // AFNetworking
    NSMutableDictionary *parameterS = [NSMutableDictionary dictionary];
    parameterS[@"Act"] = @"Reg";
    parameterS[@"Mobile"] = self.phoneNumber.text;
    [[AFHTTPSessionManager manager] POST:urlString parameters:parameterS success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dic = (NSDictionary *)responseObject;
        WXZLog(@"%@", responseObject);
        if ([dic[@"msg"] isEqualToString:@"发送成功"]) {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                JxbScaleButton* btn = (JxbScaleButton*)sender;
                JxbScaleSetting* setting = [[JxbScaleSetting alloc] init];
                setting.strPrefix = @"";
                setting.strSuffix = @"秒";
                setting.strCommon = @"重新发送";
                
                setting.indexStart = [dic[@"timeout"] integerValue];
                
                [btn startWithSetting:setting];
                [self.view setNeedsDisplay];
//                WXZLog(@"%@", dic);
            }];
//                NSLog(@"hhhhhhhhhh");
            
        }else{
            [SVProgressHUD showErrorWithStatus:dic[@"msg"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //        WXZLog(@"%@", error);
        [SVProgressHUD showErrorWithStatus:@"请求失败"];
    }];
    

    
}
// 取消键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.name resignFirstResponder];
    [self.phoneNumber resignFirstResponder];
    [self.verificationCode resignFirstResponder];
    [self.password resignFirstResponder];
    [self.yaoqingren resignFirstResponder];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // 显示导航栏
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationItem.title = @"注册";
    
    // 隐藏导航栏
    [self.navigationController setNavigationBarHidden:NO];
}

- (IBAction)register:(id)sender {
    // 0.请求路径
    // 基本URL
    NSString *baseURL = OutNetBaseURL;
    NSString *urlString = [baseURL stringByAppendingString:zhuce];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    // URL
    NSURL *url = [NSURL URLWithString:urlString];
    
    // 1.创建请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    NSString *parameter = [NSString stringWithFormat:@"xm=%@&mob=%@&yzm=%@&pas=%@&mobtj=%@",self.name.text, self.phoneNumber.text, self.verificationCode.text, self.password.text, self.yaoqingren.text];
    request.HTTPBody = [parameter dataUsingEncoding:NSUTF8StringEncoding];
    
    
    // 2.发送请求
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        // 3.解析服务器返回的数据（解析成字符串）
        //            WXZLog(@"%@", data);
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        // 获取用户信息
        //            WXZLog(@"Act=GetPass");
        WXZLog(@"%@", dic);
        
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//// 倒计时
//- (void)countdownWithTimeOut:(NSString *)timeOutStr
//{
//    int timeOut2 = timeOutStr.intValue;
//    __block int timeout = timeOut2; //倒计时时间
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
//    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
//    dispatch_source_set_event_handler(_timer, ^{
//        
//        if(timeout <= 0)
//        {
//            //倒计时结束，关闭
//            dispatch_source_cancel(_timer);
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [_codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
//                _codeBtn.userInteractionEnabled = YES;
//            });
//        }
//        else
//        {
//            int seconds = timeout; // 或 timeout % 300 或 timeout（计算分几次，每次60秒）
//            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                //设置界面的按钮显示 根据自己需求设置
//                [_codeBtn setTitle:[NSString stringWithFormat:@"%@秒",strTime] forState:UIControlStateNormal];
//                _codeBtn.userInteractionEnabled = NO;
//            });
//            timeout--;
//        }
//    });
//    dispatch_resume(_timer);
//}


@end
