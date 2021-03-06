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
#import "WXZLoginController.h"
#import "WXZNavController.h"

@interface WXZModifyPhoneVC () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView; // 底层scrollView

@property (weak, nonatomic) IBOutlet UIView *xinPCodeView; // 新手机号验证码view
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *xinPCodeViewHeight; // 新手机号验证码view的高度的约束属性

@property (weak, nonatomic) IBOutlet UITextField *codeTextField; // 验证码输入框
@property (weak, nonatomic) IBOutlet UITextField *xinPhoneTextField; // 新手机号输入框
@property (weak, nonatomic) IBOutlet UITextField *erPhoneTextField; // 再次输入手机号
@property (weak, nonatomic) IBOutlet UITextField *xinPCodeTextField; // 新手机号验证码输入框

@property (weak, nonatomic) IBOutlet UILabel *currentPhoneNumLabel; // 当前手机号
@property (weak, nonatomic) IBOutlet UIButton *codeBtn; // 发送验证码按钮
@property (weak, nonatomic) IBOutlet UIButton *determineBtn; // 确定按钮
@end

static NSInteger isModifyCount; // 第几次请求

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
    self.xinPCodeTextField.delegate = self;
    isModifyCount = 1; // 初始值为1
    
    // 赋值
    self.currentPhoneNumLabel.text = self.phone;
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.xinPCodeView.hidden = YES; // 不显示输入新手机号输入框
    self.xinPCodeViewHeight.constant = 0.0f; // 更改新手机号验证码view的高度
}

// 修改手机号请求1或2
- (void)modifyRequestWithParameter1:(NSString *)parm1 parameter:(NSString *)parm2
{
    NSString *url = @"";
    if (isModifyCount == 1)
    {
        url = [OutNetBaseURL stringByAppendingString:jinjirenxiugaishoujihao]; // 第一次请求url
    }
    else if (isModifyCount == 2)
    {
        url = [OutNetBaseURL stringByAppendingString:jinjirenxiugaishoujihao2]; // 第二次请求url
    }
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:parm1 forKey:@"yzm"]; // 旧/新手机号验证码
    [param setObject:parm2 forKey:@"mob"]; // 新手机号
    
    [[AFHTTPSessionManager manager] POST:url parameters:param success:^(NSURLSessionDataTask *task, id responseObject)
     {
         if ([responseObject[@"ok"] integerValue] == 1)
         {
             [SVProgressHUD showSuccessWithStatus:responseObject[@"msg"] maskType:SVProgressHUDMaskTypeBlack]; // 取消菊花
             
             if (isModifyCount == 1)
             {
                 self.xinPCodeView.hidden = NO; // 请求成功，显示输入新手机号验证码输入框
                 self.xinPCodeViewHeight.constant = 55; // 更改新手机号验证码view的高度
                 isModifyCount = 2; // 更改为第二次请求
             }
             else
             {
                 // 跳转到登录页面（修改手机号）
                 WXZLoginController *loginController = [[WXZLoginController alloc]init];
                 WXZNavController *nav = [[WXZNavController alloc] initWithRootViewController:loginController];
                 [[[[UIApplication sharedApplication] delegate] window] setRootViewController:nav];
             }
         }
         else
         {
             [SVProgressHUD showErrorWithStatus:responseObject[@"msg"] maskType:SVProgressHUDMaskTypeBlack];
             // 判断是否为登陆超时，登录超时则返回登录页面重新登录
             if ([responseObject[@"msg"] isEqualToString:@"登录超时"] || [responseObject[@"msg"] isEqualToString:@"登陆超时"])
             {
                 [self goBackLoginPage]; // 回到登录页面
             }
         }
         
     } failure:^(NSURLSessionDataTask *task, NSError *error) {
         [SVProgressHUD showErrorWithStatus:@"请求失败" maskType:SVProgressHUDMaskTypeBlack];
     }];
}

// 获取验证码事件及请求
- (IBAction)codeBtnAction:(JxbScaleButton *)sender
{
    // 判断有没有手机号
    if (![WXZChectObject checkWhetherStringIsEmpty:self.currentPhoneNumLabel.text withTipInfo:@"未发现当前手机号"])
    {
        // 显示菊花
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
        NSString *url = [OutNetBaseURL stringByAppendingString:yanzhengma];
        
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setObject:@"ChangeMobile" forKey:@"Act"]; // 验证码类型
        [param setObject:self.currentPhoneNumLabel.text forKey:@"Mobile"]; // 当前手机号
        
        [[AFHTTPSessionManager manager] POST:url parameters:param success:^(NSURLSessionDataTask *task, id responseObject)
         {
             NSDictionary *dic = (NSDictionary *)responseObject;
             
             if ([dic[@"status"] integerValue] == 1)
             {
                 [SVProgressHUD showSuccessWithStatus:responseObject[@"msg"] maskType:SVProgressHUDMaskTypeBlack];
                 // 倒计时
                 [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                     [self countdownWithTimeOut:dic[@"timeout"]]; // 倒计时
                     [self.view setNeedsDisplay]; // 
                 }];
             }
             else
             {
                 [SVProgressHUD showErrorWithStatus:dic[@"msg"] maskType:SVProgressHUDMaskTypeBlack];
                 // 判断是否为登陆超时，登录超时则返回登录页面重新登录
                 if ([responseObject[@"msg"] isEqualToString:@"登陆超时"])
                 {
                     [self goBackLoginPage]; // 回到登录页面
                 }
             }
             
         } failure:^(NSURLSessionDataTask *task, NSError *error) {
             [SVProgressHUD showErrorWithStatus:@"请求失败" maskType:SVProgressHUDMaskTypeBlack];
         }];
    }
}

// 倒计时方法
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
                isModifyCount = 1; // 倒计时结束还没有修改成功，则需要重新请求
                self.xinPCodeView.hidden = YES; // 隐藏新手机验证码view
                self.xinPCodeViewHeight.constant = 0; // 更改新手机号验证码view的高度
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
    [self.codeTextField resignFirstResponder];
    [self.xinPhoneTextField resignFirstResponder];
    [self.erPhoneTextField resignFirstResponder];
    [self.xinPCodeTextField resignFirstResponder];
    
    // 判断所需参数是否符合规范
    if (![WXZChectObject checkWhetherStringIsEmpty:self.codeTextField.text withTipInfo:@"验证码不能为空"] && ![WXZChectObject checkWhetherStringIsEmpty:self.xinPhoneTextField.text withTipInfo:@"请输入手机号"] && ![WXZChectObject checkWhetherStringIsEmpty:self.erPhoneTextField.text withTipInfo:@"请再次输入手机号"] && [WXZChectObject checkPhone2:self.xinPhoneTextField.text withTipInfo:@"手机号格式不正确"])
    {
        // 判断两次输入的手机号是否一致
        if ([self.xinPhoneTextField.text isEqualToString:self.erPhoneTextField.text])
        {
            if (isModifyCount == 1)
            {
                // 第1次数据请求
                [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack]; // 显示菊花
                [self modifyRequestWithParameter1:self.codeTextField.text parameter:self.xinPhoneTextField.text];
            }
            else if (isModifyCount == 2)
            {
                // 判断新手机号验证码是否为空
                if (![WXZChectObject checkWhetherStringIsEmpty:self.xinPCodeTextField.text withTipInfo:@"新手机号验证码不能为空"])
                {
                    // 第2次数据请求
                    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack]; // 显示菊花
                    [self modifyRequestWithParameter1:self.xinPCodeTextField.text parameter:self.xinPhoneTextField.text];
                }
            }
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:@"两次输入的手机号不一致，请重新输入"];
        }
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    // 键盘出来时，改变父view的坐标，使输入框露出来
    [UIView animateWithDuration:0.25 animations:^{
        if (textField.tag == 100013) // 再次输入新手机号
        {
            self.view.frame = CGRectMake(0, -60, WXZ_ScreenWidth, WXZ_ScreenHeight);
        }
        else if (textField.tag == 100012) // 新手机号
        {
            self.view.frame = CGRectMake(0, 0, WXZ_ScreenWidth, WXZ_ScreenHeight);
        }
        else if (textField.tag == 100027) // 新手机号验证码
        {
            self.view.frame = CGRectMake(0, -110, WXZ_ScreenWidth, WXZ_ScreenHeight);
        }
        else // 旧手机号验证码
        {
            self.view.frame = CGRectMake(0, 64, WXZ_ScreenWidth, WXZ_ScreenHeight-64);
        }
    }];
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // 不同输入框限定输入的字数
    NSInteger sum = 0;
    if (textField.tag == 100011 || textField.tag == 100027)
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
//当键退出时调用
-(void)keyboardWillHide:(NSNotification *)aNotification
{
    self.view.frame = CGRectMake(0, 64, WXZ_ScreenWidth, WXZ_ScreenHeight-64);
}

// 取消第一响应
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.codeTextField resignFirstResponder];
    [self.xinPhoneTextField resignFirstResponder];
    [self.erPhoneTextField resignFirstResponder];
    [self.xinPCodeTextField resignFirstResponder];
}

// dealloc中需要移除监听
-(void)dealloc
{
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
