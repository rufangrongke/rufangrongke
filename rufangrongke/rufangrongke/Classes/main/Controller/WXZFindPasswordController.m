//
//  WXZFindPasswordController.m
//  rufangrongke
//
//  Created by 儒房融科 on 15/10/25.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

#import "WXZFindPasswordController.h"

@interface WXZFindPasswordController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *verificationCode;
@property (weak, nonatomic) IBOutlet UITextField *resetPassword;

@end

@implementation WXZFindPasswordController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 显示导航栏
    [self.navigationController setNavigationBarHidden:NO];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
// 取消键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
//    [self.usernameField resignFirstResponder];
//    [self.pwdField resignFirstResponder];
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
