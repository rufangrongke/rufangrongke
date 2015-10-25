//
//  WXZPersonalSexVC.m
//  rufangrongke
//
//  Created by 儒房融科 on 15/10/25.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

#import "WXZPersonalSexVC.h"

@interface WXZPersonalSexVC ()

// 选中图片
@property (weak, nonatomic) IBOutlet UIImageView *nanSelectImgView;
@property (weak, nonatomic) IBOutlet UIImageView *nvSelectImgView;

@end

static NSString *sex = @"男"; // 记录性别

@implementation WXZPersonalSexVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // 视图整体背景色
    self.view.backgroundColor = WXZRGBColor(246, 246, 246);
    // 添加标题，设置标题的颜色和字号
    self.navigationItem.title = @"修改姓名";
    NSDictionary *titleAttributeDic = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:WXZ_SystemFont(17)};
    [self.navigationController.navigationBar setTitleTextAttributes:titleAttributeDic];
    
    // 设置默认选中(首先判断里边是否有缓存)
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"pSex"] isEqualToString:@"女"])
    {
        self.nanSelectImgView.hidden = YES;
        self.nvSelectImgView.hidden = NO;
        sex = @"女";
    }
    else
    {
        self.nanSelectImgView.hidden = NO;
        self.nvSelectImgView.hidden = YES;
        sex = @"男";
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

// 性别选择事件
- (IBAction)sexSelectAction:(id)sender
{
    UIButton *sexBtn = (UIButton *)sender;
    if (sexBtn.tag == 100007)
    {
        self.nanSelectImgView.hidden = NO;
        self.nvSelectImgView.hidden = YES;
        sex = @"男";
    }
    else if (sexBtn.tag == 100008)
    {
        self.nanSelectImgView.hidden = YES;
        self.nvSelectImgView.hidden = NO;
        sex = @"女";
    }
}

// 确定事件
- (IBAction)determineAction:(id)sender
{
    NSLog(@"sex = %@",sex);
    [[NSUserDefaults standardUserDefaults] setObject:sex forKey:@"pSex"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdatePersonalDataPage" object:nil];
    [self backAction:nil];
}

// 返回button 事件
- (void)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
