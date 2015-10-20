//
//  WXZTabBarController.m
//  rufangrongke
//
//  Created by dymost on 15/10/18.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

#import "WXZTabBarController.h"
#import "WXZLouPanController.h"
#import "WXZKeHuController.h"
#import "WXZWoController.h"
#import "WXZNavController.h"
#import "WXZTabBar.h"

@interface WXZTabBarController ()

@end

#define FontSize 12

@implementation WXZTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 通过appearance统一设置所有UITabBarItem的文字属性
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:FontSize];
    attrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSFontAttributeName] = attrs[NSFontAttributeName];
    selectedAttrs[NSForegroundColorAttributeName] = [UIColor darkGrayColor];
    
    UITabBarItem *item = [UITabBarItem appearance];
    [item setTitleTextAttributes:attrs forState:UIControlStateNormal];
    [item setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
    
    // 添加子控制器
    [self setupChildVc:[[WXZLouPanController alloc] init] title:@"楼盘" image:@"ico_index_normal" selectedImage:@"ico_index_press"];
    
    [self setupChildVc:[[WXZKeHuController alloc] init] title:@"客户" image:@"ico_customer_normal" selectedImage:@"ico_customer_press"];
    
    [self setupChildVc:[[WXZWoController alloc] init] title:@"我" image:@"ico_me_normal" selectedImage:@"ico_me_press"];
    
    // 自定义Tabbar
    [self setValue:[[WXZTabBar alloc] init] forKey:@"tabBar"];
}

/**
 * 初始化子控制器
 */
- (void)setupChildVc:(UIViewController *)vc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    // 设置文字和图片
    vc.navigationItem.title = title;
    vc.tabBarItem.title = title;
    vc.tabBarItem.image = [UIImage imageNamed:image];
    vc.tabBarItem.selectedImage = [UIImage imageNamed:selectedImage];
    
    // 包装一个导航控制器, 添加导航控制器为tabbarcontroller的子控制器
    WXZNavController *nav = [[WXZNavController alloc] initWithRootViewController:vc];
    
    // 设置导航栏背景图片和颜色
    [nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"NavBg"] forBarMetrics:UIBarMetricsDefault];
    
    [self addChildViewController:nav];
}

@end
