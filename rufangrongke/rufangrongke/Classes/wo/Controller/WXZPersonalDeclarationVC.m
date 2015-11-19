//
//  WXZPersonalDeclarationVC.m
//  rufangrongke
//
//  Created by 儒房融科 on 15/10/26.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

#import "WXZPersonalDeclarationVC.h"
#import "AFNetworking.h"
#import "WXZChectObject.h"
#import <SVProgressHUD.h>

@interface WXZPersonalDeclarationVC () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;
@property (weak, nonatomic) IBOutlet UITextView *declarationTextView; // 服务宣言输入框
@property (weak, nonatomic) IBOutlet UILabel *declarationWordPromptLabel; // 字数提示

@end

@implementation WXZPersonalDeclarationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // 视图整体背景色
    self.view.backgroundColor = WXZRGBColor(246, 246, 246);
    // 添加标题，设置标题的颜色和字号
    self.navigationItem.title = @"服务宣言";
    
    // 赋值，遵循协议
    self.declarationTextView.text = self.declarationContent; // 显示原有内容
    self.declarationTextView.delegate = self; // 遵循协议
    self.declarationWordPromptLabel.text = [NSString stringWithFormat:@"%lu/30",(unsigned long)self.declarationContent.length]; // 显示原有字数
}

// 提交服务宣言事件
- (IBAction)declarationCommitAction:(id)sender
{
    [self.declarationTextView resignFirstResponder];
    // 判断参数是否符合规范
    if (![WXZChectObject checkWhetherStringIsEmpty:self.declarationTextView.text withTipInfo:@"请输入服务宣言"] && ![WXZChectObject isBeyondTheScopeOf:30 string:self.declarationTextView.text withTipInfo:@"请输入30个字符内的服务宣言"])
    {
        // 显示菊花
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
        [self modifyRequestWithParameter:self.declarationTextView.text]; // 提交服务宣言请求
    }
}

#pragma mark - 修改服务宣言请求
- (void)modifyRequestWithParameter:(NSString *)param1
{
    NSString *nameUrlStr = [OutNetBaseURL stringByAppendingString:jinjirenziliaoxiugai]; // 请求url
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@"XuanYan" forKey:@"lN"]; // 修改的属性名
    [param setObject:param1 forKey:@"lD"]; // 服务宣言内容
    
    [[AFHTTPSessionManager manager] POST:nameUrlStr parameters:param success:^(NSURLSessionDataTask *task, id responseObject)
     {
         if ([responseObject[@"ok"] integerValue] == 1)
         {
             [SVProgressHUD showSuccessWithStatus:responseObject[@"msg"] maskType:SVProgressHUDMaskTypeBlack]; // 取消菊花
             // 发送通知，更新个人资料页面
             [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdatePersonalDataPage" object:nil];
             [self.navigationController popViewControllerAnimated:YES]; // 修改成功返回上一页面
         }
         else
         {
             [SVProgressHUD showErrorWithStatus:responseObject[@"msg"] maskType:SVProgressHUDMaskTypeBlack];
             if ([responseObject[@"msg"] isEqualToString:@"登录超时"])
             {
                 [self goBackLoginPage]; // 回到登录页面
             }
         }
         
     } failure:^(NSURLSessionDataTask *task, NSError *error) {
         [SVProgressHUD showErrorWithStatus:@"请求失败" maskType:SVProgressHUDMaskTypeBlack];
     }];
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView
{
    // 显示输入的字数
    self.declarationWordPromptLabel.text = [NSString stringWithFormat:@"%lu/30",(unsigned long)textView.text.length];
    if (textView.text.length >= 30)
    {
        NSString *wordNumStr = [NSString stringWithFormat:@"%lu/30",(unsigned long)textView.text.length];
        // 富文本
        NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:wordNumStr];
        NSDictionary *inFanWeiDic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor lightGrayColor],NSForegroundColorAttributeName, nil];
        NSDictionary *outFanWeiDic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor redColor],NSForegroundColorAttributeName, nil];
        [attributedStr addAttributes:outFanWeiDic range:NSMakeRange(0, wordNumStr.length-3)];
        [attributedStr addAttributes:inFanWeiDic range:NSMakeRange(wordNumStr.length-3, 3)];
        
        self.declarationWordPromptLabel.attributedText = attributedStr;
    }
}

// 轻击手势事件
- (IBAction)declarationTapAction:(id)sender
{
    [self.declarationTextView resignFirstResponder]; // textView失去第一响应
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
