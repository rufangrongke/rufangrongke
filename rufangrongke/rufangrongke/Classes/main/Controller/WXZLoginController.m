//
//  WXZLoginController.m
//  rufangrongke
//
//  Created by 儒房融科 on 15/10/22.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

#import "WXZLoginController.h"
#import <SVProgressHUD.h>

@interface WXZLoginController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameField;

@property (weak, nonatomic) IBOutlet UITextField *pwdField;

@end

@implementation WXZLoginController
- (IBAction)login:(id)sender {
    
    // 检测用户名
    NSString *username = self.usernameField.text;
//    if (username.length == 0) {
////        [SVProgressHUD showErrorWithStatus:self.usernameField.placeholder];
//        return;
//    }
    
    // 检测密码
    NSString *pwd = self.pwdField.text;
//    if (pwd.length == 0) {
////        [SVProgressHUD showErrorWithStatus:self.pwdField.placeholder];
//        return;
//    }
    
    // 显示HUD
//    [SVProgressHUD showWithStatus:@"登录中..." maskType:SVProgressHUDMaskTypeBlack];
    
    // 0.请求路径
//    NSString *urlString = BaseURL;
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://192.168.1.21:34/Svs/Uslogin.ashx?mob=18833198077&pas=123456"]];
    
    // 1.创建请求对象
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // 2.发送请求
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        // 3.解析服务器返回的数据（解析成字符串）
        NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@",string);
        
//        NSDictionary *dic = [];
        
//        // 4.回到主线程
//        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//            // 隐藏HUD
//            //            [SVProgressHUD dismiss];
//            
//            // 显示一些提示信息
//            NSUInteger loc = [string rangeOfString:@"\":\""].location + 3;
//            NSUInteger len = [string rangeOfString:@"\"}"].location - loc;
//            NSString *msg = [string substringWithRange:NSMakeRange(loc, len)];
//            if ([string containsString:@"success"]) {
//                [SVProgressHUD showSuccessWithStatus:msg];
//            } else {
//                [SVProgressHUD showErrorWithStatus:msg];
//            }
//        }];
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
