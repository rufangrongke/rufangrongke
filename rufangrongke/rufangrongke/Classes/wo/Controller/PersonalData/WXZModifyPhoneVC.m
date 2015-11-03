//
//  WXZModifyPhoneVC.m
//  rufangrongke
//
//  Created by 儒房融科 on 15/10/30.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

#import "WXZModifyPhoneVC.h"
#import "AFNetworking.h"
#import "WXZChectObject.h"
#import "JxbScaleButton.h"
#import <SVProgressHUD.h>

@interface WXZModifyPhoneVC () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;

@property (weak, nonatomic) IBOutlet UITextField *codeTextField; // 验证码输入框
@property (weak, nonatomic) IBOutlet UITextField *xinPhoneTextField; // 新手机号输入框
@property (weak, nonatomic) IBOutlet UITextField *erPhoneTextField; // 再次输入手机号

@property (weak, nonatomic) IBOutlet UILabel *currentPhoneNumLabel; // 当前手机号
@property (weak, nonatomic) IBOutlet JxbScaleButton *codeBtn; // 发送验证码按钮
@end

@implementation WXZModifyPhoneVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // 视图整体背景色
    self.view.backgroundColor = WXZRGBColor(246, 246, 246);
    // 添加标题，设置标题的颜色和字号
    self.navigationItem.title = @"修改绑定手机";
    
    
    self.codeTextField.delegate = self;
    self.xinPhoneTextField.delegate = self;
    self.erPhoneTextField.delegate = self;
    
    // 赋值
    self.currentPhoneNumLabel.text = self.phone;
}

// 修改手机号请求
- (void)modifyRequestWithParameter1:(NSString *)parm1 parameter:(NSString *)parm2
{
    NSString *url = [OutNetBaseURL stringByAppendingString:jinjirenxiugaishoujihao];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:parm1 forKey:@"yzm"]; // 旧手机号发送的验证码
    [param setObject:parm2 forKey:@"mob"]; // 新手机号
    
    [[AFHTTPSessionManager manager] POST:url parameters:param success:^(NSURLSessionDataTask *task, id responseObject)
     {
         if ([responseObject[@"ok"] integerValue] == 1)
         {
             NSLog(@"%@",responseObject[@"msg"]);
             // 发送通知
             [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdatePersonalDataPage" object:nil];
             [self.navigationController popViewControllerAnimated:YES]; // 修改成功返回上一页面
         }
         else
         {
             [SVProgressHUD showErrorWithStatus:responseObject[@"msg"]];
         }
         [SVProgressHUD dismiss]; // 取消菊花
         
     } failure:^(NSURLSessionDataTask *task, NSError *error) {
         [SVProgressHUD showErrorWithStatus:@"请求失败"];
         [SVProgressHUD dismiss]; // 取消菊花
     }];
}

- (IBAction)codeBtnAction:(id)sender
{
    NSLog(@"验证码");
    // 判断有没有手机号
    if (![WXZChectObject checkWhetherStringIsEmpty:self.currentPhoneNumLabel.text])
    {
//        // 请求路径
//        NSString *urlString = [OutNetBaseURL stringByAppendingString:yanzhengma];
//        // AFNetworking
//        NSMutableDictionary *parameterS = [NSMutableDictionary dictionary];
//        parameterS[@"Act"] = @"ChangMobile";
//        parameterS[@"Mobile"] = self.currentPhoneNumLabel.text;
//        [[AFHTTPSessionManager manager] POST:urlString parameters:parameterS success:^(NSURLSessionDataTask *task, id responseObject) {
//            NSDictionary *dic = (NSDictionary *)responseObject;
//            WXZLog(@"%@", responseObject);
//            if ([dic[@"msg"] isEqualToString:@"发送成功"]) {
//                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//                    JxbScaleButton* btn = (JxbScaleButton*)sender;
//                    JxbScaleSetting* setting = [[JxbScaleSetting alloc] init];
//                    setting.strPrefix = @"";
//                    setting.strSuffix = @"秒";
//                    setting.strCommon = @"重新发送";
//                    
//                    setting.indexStart = [dic[@"timeout"] integerValue];
//                    WXZLog(@"%@", btn);
//                    [btn startWithSetting:setting];
//                    [self.view setNeedsDisplay];
//                    //                [self.view layoutIfNeeded];
//                    //                WXZLog(@"%@", dic);
//                }];
//                //            NSLog(@"hhhhhhhhhh");
//                
//            }else{
//                [SVProgressHUD showErrorWithStatus:dic[@"msg"]];
//            }
//        } failure:^(NSURLSessionDataTask *task, NSError *error) {
//            //        WXZLog(@"%@", error);
//            [SVProgressHUD showErrorWithStatus:@"请求失败"];
//        }];

        // 显示菊花
        [SVProgressHUD showWithStatus:@"发送中..." maskType:SVProgressHUDMaskTypeBlack];
        NSString *url = [OutNetBaseURL stringByAppendingString:yanzhengma];
        
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setObject:@"ChangMobile" forKey:@"Act"]; // 验证码类型
        [param setObject:self.currentPhoneNumLabel.text forKey:@"Mobile"]; // 当前手机号
        
        [[AFHTTPSessionManager manager] POST:url parameters:param success:^(NSURLSessionDataTask *task, id responseObject)
         {
             NSDictionary *dic = (NSDictionary *)responseObject;
             WXZLog(@"%@",dic);
             if ([responseObject[@"status"] integerValue] == 1)
             {
                 NSLog(@"%@",responseObject[@"msg"]);
                 // 倒计时
                 [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                     JxbScaleButton* btn = (JxbScaleButton *)sender;
                     JxbScaleSetting* setting = [[JxbScaleSetting alloc] init];
                     setting.strPrefix = @"";
                     setting.strSuffix = @"秒";
                     setting.strCommon = @"重新发送";
                     
                     setting.indexStart = [dic[@"timeout"] integerValue];
                     
                     [btn startWithSetting:setting];
                     [self.view setNeedsDisplay];
                 }];
             }
             else
             {
                 [SVProgressHUD showErrorWithStatus:dic[@"msg"]];
             }
             [SVProgressHUD dismiss]; // 取消菊花
             
         } failure:^(NSURLSessionDataTask *task, NSError *error) {
             [SVProgressHUD showErrorWithStatus:@"请求失败"];
             [SVProgressHUD dismiss]; // 取消菊花
         }];
    }
}

// 确定按钮单击事件
- (IBAction)determineBtn:(id)sender
{
    NSLog(@"确定");
    if (![WXZChectObject checkWhetherStringIsEmpty:self.xinPhoneTextField.text] && ![WXZChectObject checkWhetherStringIsEmpty:self.erPhoneTextField.text])
    {
        if ([WXZChectObject checkPhone2:self.xinPhoneTextField.text])
        {
            if ([self.xinPhoneTextField.text isEqualToString:self.erPhoneTextField.text])
            {
                // 显示菊花
                [SVProgressHUD showWithStatus:@"发送中..." maskType:SVProgressHUDMaskTypeBlack];
                [self modifyRequestWithParameter1:self.currentPhoneNumLabel.text parameter:self.currentPhoneNumLabel.text];
            }
            else
            {
                NSLog(@"两次手机号不一致，请重新输入");
            }
        }
        
    }
    else
    {
        NSLog(@"手机号不能为空！");
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // 不同输入框限定输入的字数
    NSInteger sum = 0;
    if (textField.tag == 100011)
    {
        sum = 6; // 验证码位数
    }
    else
    {
        sum = 11; // 手机号位数
    }
    
    if (range.location >= sum)
    {
        return NO; // 超位数不能输入
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

// 取消第一响应
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.codeTextField resignFirstResponder];
    [self.xinPhoneTextField resignFirstResponder];
    [self.erPhoneTextField resignFirstResponder];
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
