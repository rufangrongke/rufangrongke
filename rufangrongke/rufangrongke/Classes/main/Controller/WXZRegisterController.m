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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
