//
//  WXZModifyPhoneVC.m
//  rufangrongke
//
//  Created by 儒房融科 on 15/10/30.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

#import "WXZModifyPhoneVC.h"
#import "AFNetworking.h"
#import "WXZDetermineString.h"

@interface WXZModifyPhoneVC () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;

@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UITextField *xinPhoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *erPhoneTextField;

@property (weak, nonatomic) IBOutlet UILabel *currentPhoneNumLabel;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;
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
- (void)modifyRequestWithParameter1:(NSString *)parm1 parameter:(NSString *)parm2 isCode:(BOOL)iscode;
{
    NSString *url;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (iscode)
    {
        url = [OutNetBaseURL stringByAppendingString:yanzhengma];
        [param setObject:parm1 forKey:@"Act"]; // 验证码类型
        [param setObject:parm2 forKey:@"Mobile"]; // 当前手机号
    }
    else
    {
        url = [OutNetBaseURL stringByAppendingString:jinjirenxiugaishoujihao];
        [param setObject:parm1 forKey:@"yzm"]; // 旧手机号发送的验证码
        [param setObject:parm2 forKey:@"mob"]; // 新手机号
    }
    
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
             NSLog(@"%@",responseObject[@"msg"]);
         }
         
     } failure:^(NSURLSessionDataTask *task, NSError *error) {
         
     }];
}

- (IBAction)codeBtnAction:(id)sender
{
    NSLog(@"验证码");
    // 判断有没有手机号
    if (![WXZDetermineString determineString:self.currentPhoneNumLabel.text])
    {
        [self modifyRequestWithParameter1:@"ChageMobile" parameter:self.currentPhoneNumLabel.text isCode:YES];
    }
}

- (IBAction)determineBtn:(id)sender
{
    NSLog(@"确定");
    
    if (![WXZDetermineString determineString:self.xinPhoneTextField.text] && ![WXZDetermineString determineString:self.erPhoneTextField.text])
    {
        if ([self.xinPhoneTextField.text isEqualToString:self.erPhoneTextField.text])
        {
            [self modifyRequestWithParameter1:self.currentPhoneNumLabel.text parameter:self.currentPhoneNumLabel.text isCode:NO];
        }
        else
        {
            NSLog(@"两次手机号不一致，请重新输入");
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
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

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
