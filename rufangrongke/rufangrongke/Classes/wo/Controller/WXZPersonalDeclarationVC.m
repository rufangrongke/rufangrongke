//
//  WXZPersonalDeclarationVC.m
//  rufangrongke
//
//  Created by 儒房融科 on 15/10/26.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

#import "WXZPersonalDeclarationVC.h"

@interface WXZPersonalDeclarationVC ()

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
}

// 提交服务宣言
- (IBAction)declarationCommitAction:(id)sender
{
    NSLog(@"提交");
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
