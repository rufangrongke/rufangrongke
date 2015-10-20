//
//  WXZNavController.m
//  rufangrongke
//
//  Created by dymost on 15/10/20.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

#import "WXZNavController.h"

@interface WXZNavController ()

@end

@implementation WXZNavController

/**
 * 当第一次使用这个类的时候会调用一次
 */
+ (void)initialize
{
    // 当导航栏用在XMGNavigationController中, appearance设置才会生效
    //    UINavigationBar *bar = [UINavigationBar appearanceWhenContainedIn:[self class], nil];
    UINavigationBar *bar = [UINavigationBar appearance];
    // 设置导航栏背景图片,背景色
//    [bar setBackgroundImage:[UIImage imageNamed:@"navigationbarBackgroundWhite"] forBarMetrics:UIBarMetricsDefault];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbarBackgroundWhite"] forBarMetrics:UIBarMetricsDefault];
}

/**
 * 可以在这个方法中拦截所有push进来的控制器
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.childViewControllers.count > 0) { // 如果push进来的不是第一个控制器
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        [button setTitle:@"返回" forState:UIControlStateNormal];
//        [button setImage:[UIImage imageNamed:@"navigationButtonReturn"] forState:UIControlStateNormal];
//        [button setImage:[UIImage imageNamed:@"navigationButtonReturnClick"] forState:UIControlStateHighlighted];
//        button.size = CGSizeMake(70, 30);
//        // 让按钮内部的所有内容左对齐
//        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//        //        [button sizeToFit];
//        // 让按钮的内容往左边偏移10
//        button.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
//        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [button setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
//        [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
//        
//        // 修改导航栏左边的item
//        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        
        // 隐藏tabbar
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    // 这句super的push要放在后面, 让viewController可以覆盖上面设置的leftBarButtonItem
    [super pushViewController:viewController animated:animated];
    
}

- (void)back
{
    [self popViewControllerAnimated:YES];
}

@end
