//
//  MIDU_Home_TopView.m
//  MiDu
//
//  Created by 胡双飞 on 15/9/4.
//  Copyright (c) 2015年 HSF. All rights reserved.
//

#import "MIDU_HomeTopView.h"
#import "MIDU_HomeDefineVariableTool.h"
#import "DefineVariableTool.h"
@interface MIDU_HomeTopView ()
@property (nonatomic, weak) UIImageView* logo;
@property (nonatomic, weak) UISearchBar* topSearchBar;
@property (weak, nonatomic) UIButton* btn;

@end
@implementation MIDU_HomeTopView
//初始时创建子视图
- (instancetype)init
{
    self = [super init];
    if (self) {
        // 左边按钮
        UIImageView* imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"welcome_logo"];
        [self addSubview:imageView];
        self.logo = imageView;

        // 中间搜索框
        UISearchBar* topSearchBar = [[UISearchBar alloc] init];
        topSearchBar.barTintColor = kUIBlue;
        [self addSubview:topSearchBar];
        self.topSearchBar = topSearchBar;

        // 右边搜索按钮
        UIButton* btn = [[UIButton alloc] init];
        [btn setTintColor:[UIColor whiteColor]];
        [btn setTitle:@"搜索" forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:16];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self addSubview:btn];
        self.btn = btn;
    }
    return self;
}

//布局
- (void)layoutSubviews
{
    [super layoutSubviews];

    //添加logo
    CGFloat logoY = kStatusHeight + (self.bounds.size.height - kStatusHeight - kLogoHeight) * 0.5;
    self.logo.frame = CGRectMake(kHome_Margin, logoY, kLogoWidth, kLogoHeight);

    //添加topSearchBar
    CGFloat topsearchBarX = CGRectGetMaxX(self.logo.frame) + kHome_Margin;
    CGFloat topsearchBarY = logoY - kHome_Margin * 0.5;
    CGFloat topsearchBarW = self.bounds.size.width - topsearchBarX - kHome_Margin - kLogoWidth;
    CGFloat topsearchBarH = kLogoHeight + kHome_Margin;
    self.topSearchBar.frame = CGRectMake(topsearchBarX, topsearchBarY, topsearchBarW, topsearchBarH);
    //添加搜索按钮
    CGFloat btnX = CGRectGetMaxX(self.topSearchBar.frame);
    CGFloat btnY = logoY;
    self.btn.frame = CGRectMake(btnX, btnY, kLogoWidth, kLogoHeight);
}

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    [self endEditing:YES];
}

@end
