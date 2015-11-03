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
    
    self.myScrollView.contentSize = CGSizeMake(WXZ_ScreenWidth, 300);
    
    self.declarationTextView.text = self.declarationContent;
    self.declarationTextView.delegate = self;
}

// 提交服务宣言
- (IBAction)declarationCommitAction:(id)sender
{
    NSLog(@"提交");
    if (![WXZChectObject checkWhetherStringIsEmpty:self.declarationTextView.text] && ![WXZChectObject isBeyondTheScopeOf:30 string:self.declarationTextView.text])
    {
        // 显示菊花
        [SVProgressHUD showWithStatus:@"正在提交..." maskType:SVProgressHUDMaskTypeBlack];
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
             NSLog(@"%@",responseObject[@"msg"]);
             // 发送通知
             [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdatePersonalDataPage" object:nil];
             [self.navigationController popViewControllerAnimated:YES]; // 修改成功返回上一页面
         }
         else
         {
             NSLog(@"%@",responseObject[@"msg"]);
             [SVProgressHUD showErrorWithStatus:responseObject[@"msg"]];
         }
         [SVProgressHUD dismiss]; // 取消菊花
         
     } failure:^(NSURLSessionDataTask *task, NSError *error) {
         [SVProgressHUD showErrorWithStatus:@"请求失败"];
         [SVProgressHUD dismiss]; // 取消菊花
     }];
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
//    bool isChinese;//判断当前输入法是否是中文
//    if ([[[UITextInputMode currentInputMode] primaryLanguage] isEqualToString: @"en-US"]) {
//        isChinese = false;
//    }
//    else
//    {
//        isChinese = true;
//    }
//    
//    if(sender == self.txtName) {
//        // 8位
//        NSString *str = [[self.txtName text] stringByReplacingOccurrencesOfString:@"?" withString:@""];
//        if (isChinese) { //中文输入法下
//            UITextRange *selectedRange = [self.txtName markedTextRange];
//            //获取高亮部分
//            UITextPosition *position = [self.txtName positionFromPosition:selectedRange.start offset:0];
//            // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
//            if (!position) {
//                NSLog(@"汉字");
//                if ( str.length>=9) {
//                    NSString *strNew = [NSString stringWithString:str];
//                    [self.txtName setText:[strNew substringToIndex:8]];
//                }
//            }
//            else
//            {
//                NSLog(@"输入的英文还没有转化为汉字的状态");
//                
//            }
//        }else{
//            NSLog(@"str=%@; 本次长度=%d",str,[str length]);
//            if ([str length]>=9) {
//                NSString *strNew = [NSString stringWithString:str];
//                [self.txtName setText:[strNew substringToIndex:8]];
//            }
//        }
//    }
    
    return YES;
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
