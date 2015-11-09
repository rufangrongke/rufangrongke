//
//  WXZIRecommendCodeVC.m
//  rufangrongke
//
//  Created by 儒房融科 on 15/11/2.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

#import "WXZIRecommendCodeVC.h"
#import <UIImageView+WebCache.h>

@interface WXZIRecommendCodeVC ()

@property (weak, nonatomic) IBOutlet UIImageView *headImgView; // 头像

@property (weak, nonatomic) IBOutlet UILabel *customerNameLabel; // 用户名
@property (weak, nonatomic) IBOutlet UILabel *recommendCodeLabel; // 推荐码

@end

@implementation WXZIRecommendCodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // 视图整体背景色
    self.view.backgroundColor = WXZRGBColor(246, 246, 246);
    // 添加标题，设置标题的颜色和字号
    self.navigationItem.title = @"本人推荐码";
    
    [self initControl];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
}

// 初始化控件
- (void)initControl
{
    // 设置图片
    NSString *imgUrl = [picBaseULR stringByAppendingString:self.headUrl];
    self.headImgView.layer.cornerRadius = 50;
    self.headImgView.layer.masksToBounds = YES;
    self.headImgView.layer.borderColor = WXZRGBColor(229, 229, 229).CGColor;
    self.headImgView.layer.borderWidth = 2;
    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"wo_head"]];
    
    // 设置用户名
    self.customerNameLabel.text = self.userName;
    // 推荐码
    self.recommendCodeLabel.text = self.recommendedCodeStr;
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
