//
//  WXZPersonalNameVC.m
//  rufangrongke
//
//  Created by 儒房融科 on 15/10/25.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

#import "WXZPersonalNameVC.h"

@interface WXZPersonalNameVC () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UIButton *determineBtn;

@end

@implementation WXZPersonalNameVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // 视图整体背景色
    self.view.backgroundColor = WXZRGBColor(246, 246, 246);
    // 添加标题，设置标题的颜色和字号
    self.navigationItem.title = @"修改姓名";
    NSDictionary *titleAttributeDic = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:WXZ_SystemFont(17)};
    [self.navigationController.navigationBar setTitleTextAttributes:titleAttributeDic];
    
    // 设置button圆角
    self.determineBtn.layer.cornerRadius = 5;
    self.determineBtn.layer.masksToBounds = YES;
    
    self.nameTextField.delegate = self;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"pName"])
    {
        self.nameTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"pName"];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    // 返回按钮
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 40, 44);
    [leftBtn setImage:[UIImage imageNamed:@"kh_rjt"] forState:UIControlStateNormal];
    leftBtn.transform = CGAffineTransformMakeRotation(M_PI); // 图片旋转d
    [leftBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)]; // 标题向左侧偏移
    [leftBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
}

#pragma mark - 
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)determineAction:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setObject:self.nameTextField.text forKey:@"pName"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdatePersonalDataPage" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateWoPage" object:nil];
    [self backAction:nil];
}

// 返回button 事件
- (void)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.nameTextField resignFirstResponder];
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
