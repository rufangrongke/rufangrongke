//
//  WXZPersonalInfoVC.m
//  rufangrongke
//
//  Created by 儒房融科 on 15/10/27.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

#import "WXZPersonalInfoVC.h"

@interface WXZPersonalInfoVC ()

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

static NSString *sex = @"男"; // 记录性别

@implementation WXZPersonalInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // 视图整体背景色
    self.view.backgroundColor = WXZRGBColor(246, 246, 246);
    // 添加标题，设置标题的颜色和字号
    self.navigationItem.title = self.titleStr;
    
    [self initsome];
}

- (void)initsome
{
    CGRect rect;
    if ([self.whichController isEqualToString:@"ModifyPersonalName"])
    {
        self.personalNameView.hidden = NO;
        self.personalSexView.hidden = YES;
        self.modifyPwdView.hidden = YES;
        self.personalNameView.frame = CGRectMake(0, 10, WXZ_ScreenWidth, 55);
        [self.view addSubview:self.personalNameView];
        rect = [self calculateRect:self.personalNameView.frame];
    }
    else if ([self.whichController isEqualToString:@"ModifyPersonalSex"])
    {
        self.personalNameView.hidden = YES;
        self.personalSexView.hidden = NO;
        self.modifyPwdView.hidden = YES;
        self.personalSexView.frame = CGRectMake(0, 10, WXZ_ScreenWidth, 110);
        [self.view addSubview:self.personalSexView];
        rect = [self calculateRect:self.personalSexView.frame];
        
        // 设置默认选中(首先判断里边是否有缓存)
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"pSex"] isEqualToString:@"女"])
        {
            self.menImgView.hidden = YES;
            self.womenImgView.hidden = NO;
            sex = @"女";
        }
        else
        {
            self.menImgView.hidden = NO;
            self.womenImgView.hidden = YES;
            sex = @"男";
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
        sex = @"男";
    }
    else if (sexBtn.tag == 100008)
    {
        self.menImgView.hidden = YES;
        self.womenImgView.hidden = NO;
        sex = @"女";
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

- (IBAction)determineAction:(id)sender
{
    
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
