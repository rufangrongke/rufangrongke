//
//  WXZPersonalInfoVC.m
//  rufangrongke
//
//  Created by 儒房融科 on 15/10/27.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

#import "WXZPersonalInfoVC.h"
#import "AFNetworking.h"
#import "WXZDetermineString.h"
#import "WXZLoginController.h"

@interface WXZPersonalInfoVC () <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIView *personalNameView;
@property (strong, nonatomic) IBOutlet UIView *personalSexView;
@property (strong, nonatomic) IBOutlet UIView *modifyPwdView;

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *currentPwdTextField;
@property (weak, nonatomic) IBOutlet UITextField *modifyPwdTextField;

@property (weak, nonatomic) IBOutlet UIImageView *menImgView;
@property (weak, nonatomic) IBOutlet UIImageView *womenImgView;
@property (weak, nonatomic) IBOutlet UIImageView *pwdShowImgView;

@property (weak, nonatomic) IBOutlet UIButton *menBtn;
@property (weak, nonatomic) IBOutlet UIButton *womenBtn;
@property (strong, nonatomic) IBOutlet UIButton *determineBtn;

@end

static NSString *sex = @"先生"; // 记录性别

@implementation WXZPersonalInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // 视图整体背景色
    self.view.backgroundColor = WXZRGBColor(246, 246, 246);
    // 添加标题，设置标题的颜色和字号
    self.navigationItem.title = self.titleStr;
    
    [self initControl]; // 初始化控件
    
    self.nameTextField.delegate = self;
    self.currentPwdTextField.delegate = self;
    self.modifyPwdTextField.delegate = self;
}

// 初始化控件
- (void)initControl
{
    // 判断当前controller，从而确定显示哪个view以及frame
    CGRect rect;
    if ([self.whichController isEqualToString:@"ModifyPersonalName"])
    {
        self.personalNameView.hidden = NO;
        self.personalSexView.hidden = YES;
        self.modifyPwdView.hidden = YES;
        self.personalNameView.frame = CGRectMake(0, 10, WXZ_ScreenWidth, 55);
        [self.view addSubview:self.personalNameView];
        rect = [self calculateRect:self.personalNameView.frame];
        self.nameTextField.text = self.nameOrSex;
    }
    else if ([self.whichController isEqualToString:@"ModifyPersonalSex"])
    {
        self.personalNameView.hidden = YES;
        self.personalSexView.hidden = NO;
        self.modifyPwdView.hidden = YES;
        self.personalSexView.frame = CGRectMake(0, 10, WXZ_ScreenWidth, 110);
        [self.view addSubview:self.personalSexView];
        rect = [self calculateRect:self.personalSexView.frame];
        sex = self.nameOrSex;
        // 设置默认选中(首先判断里边是否有缓存)
        if ([self.nameOrSex isEqualToString:@"女士"])
        {
            self.menImgView.hidden = YES;
            self.womenImgView.hidden = NO;
            sex = @"女士";
        }
        else
        {
            self.menImgView.hidden = NO;
            self.womenImgView.hidden = YES;
            sex = @"先生";
        }
    }
    else if ([self.whichController isEqualToString:@"ModifyPersonalPwd"])
    {
        self.personalNameView.hidden = YES;
        self.personalSexView.hidden = YES;
        self.modifyPwdView.hidden = NO;
        self.modifyPwdView.frame = CGRectMake(0, 10, WXZ_ScreenWidth, 110);
        [self.view addSubview:self.modifyPwdView];
        rect = [self calculateRect:self.modifyPwdView.frame];
    }
    self.determineBtn.frame = rect;
    [self.view addSubview:self.determineBtn];
}

// 计算button的frame
- (CGRect)calculateRect:(CGRect)frame
{
    CGRect rect = frame;
    rect.origin.x = 17;
    rect.origin.y = frame.origin.y + frame.size.height+10;
    rect.size.width = WXZ_ScreenWidth - 17 * 2;
    rect.size.height = 44;
    frame = rect;
    
    return frame;
}

// 选择性别事件
- (IBAction)selectSexAction:(UIButton *)sender
{
    UIButton *sexBtn = (UIButton *)sender;
    if (sexBtn.tag == 100007)
    {
        self.menImgView.hidden = NO;
        self.womenImgView.hidden = YES;
        sex = @"先生";
    }
    else if (sexBtn.tag == 100008)
    {
        self.menImgView.hidden = YES;
        self.womenImgView.hidden = NO;
        sex = @"女士";
    }
}
// 密码显示
- (IBAction)pwdShowAction:(id)sender
{
    if ([self.pwdShowImgView.image isEqual:[UIImage imageNamed:@"wo_pwdcipher"]])
    {
        self.pwdShowImgView.image = [UIImage imageNamed:@"wo_pwdplaintext"];
        self.modifyPwdTextField.secureTextEntry = NO;
    }
    else
    {
        self.pwdShowImgView.image = [UIImage imageNamed:@"wo_pwdcipher"];
        self.modifyPwdTextField.secureTextEntry = YES;
    }
}

// 确定按钮事件
- (IBAction)determineAction:(id)sender
{
    // 判断是哪个controller，并进行相应请求
    if ([self.whichController isEqualToString:@"ModifyPersonalName"])
    {
        if (![WXZDetermineString determineString:self.nameTextField.text] && ![WXZDetermineString isBeyondTheScopeOf:4 string:self.nameTextField.text])
        {
            [self modifyRequestWithParameter1:self.nameTextField.text parameter:@""];
        }
    }
    else if ([self.whichController isEqualToString:@"ModifyPersonalSex"])
    {
        if (![WXZDetermineString determineString:sex])
        {
            [self modifyRequestWithParameter1:sex parameter:@""];
        }
    }
    else if ([self.whichController isEqualToString:@"ModifyPersonalPwd"])
    {
        if (![WXZDetermineString determineString:self.currentPwdTextField.text] && ![WXZDetermineString determineString:self.modifyPwdTextField.text])
        {
            [self modifyRequestWithParameter1:self.currentPwdTextField.text parameter:self.modifyPwdTextField.text];
        }
    }
}

// 修改姓名，性别，密码请求
- (void)modifyRequestWithParameter1:(NSString *)param1 parameter:(NSString *)param2
{
    NSString *nameUrlStr;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if ([self.whichController isEqualToString:@"ModifyPersonalPwd"])
    {
        nameUrlStr = [OutNetBaseURL stringByAppendingString:jingjirenxiugaimima];
        [param setObject:param1 forKey:@"pasOld"];
        [param setObject:param2 forKey:@"pasNew"];
    }
    else if ([self.whichController isEqualToString:@"ModifyPersonalSex"])
    {
        nameUrlStr = [OutNetBaseURL stringByAppendingString:jinjirenziliaoxiugai];
        [param setObject:@"Sex" forKey:@"lN"];
        [param setObject:param1 forKey:@"lD"];
    }
    else
    {
        nameUrlStr = [OutNetBaseURL stringByAppendingString:jinjirenziliaoxiugai];
        [param setObject:@"TrueName" forKey:@"lN"];
        [param setObject:param1 forKey:@"lD"];
    }
    
    [[AFHTTPSessionManager manager] POST:nameUrlStr parameters:param success:^(NSURLSessionDataTask *task, id responseObject)
    {
        if ([responseObject[@"ok"] integerValue] == 1)
        {
            if ([self.whichController isEqualToString:@"ModifyPersonalPwd"])
            {
                // 跳转到登录页面
                WXZLoginController *loginVC = [[WXZLoginController alloc] init];
                [self.navigationController pushViewController:loginVC animated:YES];
            }
            else
            {
                NSLog(@"%@",responseObject[@"msg"]);
                // 发送通知
                [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdatePersonalDataPage" object:nil];
                [self.navigationController popViewControllerAnimated:YES]; // 修改成功返回上一页面
            }
        }
        else
        {
            NSLog(@"%@",responseObject[@"msg"]);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

#pragma mark - UITextFieldDelegate Methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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
