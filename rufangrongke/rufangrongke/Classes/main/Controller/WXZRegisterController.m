//
//  WXZRegisterController.m
//  rufangrongke
//
//  Created by 儒房融科 on 15/10/25.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

#import "WXZRegisterController.h"

@interface WXZRegisterController ()

@end

@implementation WXZRegisterController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 显示导航栏
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationItem.title = @"注册";
    
    // 隐藏导航栏
    [self.navigationController setNavigationBarHidden:NO];
//    self.navigationItem set
    // Do any additional setup after loading the view from its nib.
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
