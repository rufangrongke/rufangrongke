//
//  WXZTabBar.m
//  rufangrongke
//
//  Created by dymost on 15/10/20.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

#import "WXZTabBar.h"

@implementation WXZTabBar

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        // 设置tabbar的背景图片,背景色
//        [self setBackgroundImage:[UIImage imageNamed:@"tabBarBg"]];
        
//        // 添加发布按钮
//        UIButton *publishButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [publishButton setBackgroundImage:[UIImage imageNamed:@"tabBar_publish_icon"] forState:UIControlStateNormal];
//        [publishButton setBackgroundImage:[UIImage imageNamed:@"tabBar_publish_click_icon"] forState:UIControlStateHighlighted];
//        publishButton.size = publishButton.currentBackgroundImage.size;
//        [self addSubview:publishButton];
//        self.publishButton = publishButton;
//        WXZLog(@"self.subviews.count%zd", self.subviews.count);
//        WXZLouPanBottomBar *bar = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([WXZLouPanBottomBar class]) owner:nil options:nil].lastObject;
//        self.louPanBottomBar = bar;
////        bar.hidden = YES;
//        [self addSubview:bar];
    }
    return self;
}
static NSInteger ind = 0;
- (void)layoutSubviews
{
    [super layoutSubviews];
    if (ind == 0) {
        WXZLouPanBottomBar *bar = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([WXZLouPanBottomBar class]) owner:nil options:nil].lastObject;
        self.louPanBottomBar = bar;
        bar.hidden = YES;
        [self addSubview:bar];
        self.louPanBottomBar.frame = self.bounds;
    }
//    self.louPanBottomBar.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44);
//    CGFloat width = self.width;
//    CGFloat height = self.height;
//    
//    // 设置发布按钮的frame
//    self.publishButton.center = CGPointMake(width * 0.5, height * 0.5);
//    
//    // 设置其他UITabBarButton的frame
//    CGFloat buttonY = 0;
//    CGFloat buttonW = width / 5;
//    CGFloat buttonH = height;
//    NSInteger index = 0;
//    for (UIView *button in self.subviews) {
//        if (![button isKindOfClass:[UIControl class]] || button == self.publishButton) continue;
//        
//        // 计算按钮的x值
//        CGFloat buttonX = buttonW * ((index > 1)?(index + 1):index);
//        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
//        
//        // 增加索引
//        index++;
//    }
}


@end
