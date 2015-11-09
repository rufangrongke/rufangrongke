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
#import "CDPMonitorKeyboard.h"
#import "WXZLoginController.h"

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
    
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
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
             // 跳转到登录页面（修改密码）
             WXZLoginController *loginVC = [[WXZLoginController alloc] init];
             [self.navigationController pushViewController:loginVC animated:YES];
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

// 获取验证码事件及请求
- (IBAction)codeBtnAction:(JxbScaleButton *)sender
{
    NSLog(@"验证码");
    // 判断有没有手机号
    if (![WXZChectObject checkWhetherStringIsEmpty:self.currentPhoneNumLabel.text])
    {
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
             if ([dic[@"status"] integerValue] == 1)
             {
                 NSLog(@"%@",responseObject[@"msg"]);
                 // 倒计时
                 [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                     [self countdownWithTimeOut:dic[@"timeout"]]; // 倒计时
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
                [_codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
                _codeBtn.userInteractionEnabled = YES;
            });
        }
        else
        {
            int seconds = timeout; // 或 timeout % 300 或 timeout（计算分几次，每次60秒）
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [_codeBtn setTitle:[NSString stringWithFormat:@"%@秒",strTime] forState:UIControlStateNormal];
                _codeBtn.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
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
                [self modifyRequestWithParameter1:self.codeTextField.text parameter:self.xinPhoneTextField.text];
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

#pragma mark 键盘监听方法设置
//当键盘出现时调用
-(void)keyboardWillShow:(NSNotification *)aNotification
{
    //如果想不通输入view获得不同高度，可自己在此方法里分别判断区别
    [[CDPMonitorKeyboard defaultMonitorKeyboard] keyboardWillShowWithSuperView:self.view andNotification:aNotification higherThanKeyboard:0];
}

//当键退出时调用
-(void)keyboardWillHide:(NSNotification *)aNotification
{
    [[CDPMonitorKeyboard defaultMonitorKeyboard] keyboardWillHide];
}

// 取消第一响应
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.codeTextField resignFirstResponder];
    [self.xinPhoneTextField resignFirstResponder];
    [self.erPhoneTextField resignFirstResponder];
}

// dealloc中需要移除监听
-(void)dealloc{
    //移除监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    
    //移除监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
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
