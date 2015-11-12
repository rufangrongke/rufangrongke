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
    
    self.myScrollView.contentSize = CGSizeMake(WXZ_ScreenWidth, 300); // 设置scrollView的contentSize
    // 赋值，遵循协议
    self.declarationTextView.text = self.declarationContent;
    self.declarationTextView.delegate = self;
}

// 提交服务宣言
- (IBAction)declarationCommitAction:(id)sender
{
    [self.declarationTextView resignFirstResponder];
    if (![WXZChectObject checkWhetherStringIsEmpty:self.declarationTextView.text withTipInfo:@"请输入服务宣言"] && ![WXZChectObject isBeyondTheScopeOf:30 string:self.declarationTextView.text withTipInfo:@"请输入30个字符内的服务宣言"])
    {
        // 显示菊花
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
        [self modifyRequestWithParameter:self.declarationTextView.text]; // 提交请求
    }
}

// 修改服务宣言请求
- (void)modifyRequestWithParameter:(NSString *)param1
{
    NSString *nameUrlStr = [OutNetBaseURL stringByAppendingString:jinjirenziliaoxiugai];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@"XuanYan" forKey:@"lN"]; // 属性名
    [param setObject:param1 forKey:@"lD"]; // 服务宣言内容
    
    [[AFHTTPSessionManager manager] POST:nameUrlStr parameters:param success:^(NSURLSessionDataTask *task, id responseObject)
     {
         if ([responseObject[@"ok"] integerValue] == 1)
         {
             [SVProgressHUD dismiss]; // 取消菊花
             // 发送通知
             [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdatePersonalDataPage" object:nil];
             [self.navigationController popViewControllerAnimated:YES]; // 修改成功返回上一页面
         }
         else
         {
             [SVProgressHUD showErrorWithStatus:responseObject[@"msg"]];
         }
         
     } failure:^(NSURLSessionDataTask *task, NSError *error) {
         [SVProgressHUD showErrorWithStatus:@"请求失败"];
//         [SVProgressHUD dismiss]; // 取消菊花
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
        
        NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:wordNumStr];
        NSDictionary *inFanWeiDic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor lightGrayColor],NSForegroundColorAttributeName, nil];
        NSDictionary *outFanWeiDic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor redColor],NSForegroundColorAttributeName, nil];
        [attributedStr addAttributes:outFanWeiDic range:NSMakeRange(0, wordNumStr.length-3)];
        [attributedStr addAttributes:inFanWeiDic range:NSMakeRange(wordNumStr.length-3, 3)];
        
        self.declarationWordPromptLabel.attributedText = attributedStr;
    }
}

- (IBAction)declarationTapAction:(id)sender
{
    [self.declarationTextView resignFirstResponder];
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
