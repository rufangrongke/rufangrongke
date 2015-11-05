//
//  WXZLiandong.m
//  1102-footView
//
//  Created by 儒房融科 on 15/11/2.
//  Copyright (c) 2015年 儒房融科. All rights reserved.
//

#import "WXZLiandong.h"

@interface WXZLiandong()<UIScrollViewDelegate>
/* labelScrollView */
@property (nonatomic , strong) UIScrollView *labelScrollView;
/* contentScrollView*/
@property (nonatomic , strong) UIScrollView *contentScrollView;

@end
@implementation WXZLiandong

+ (instancetype)makeLiandongView:(NSMutableArray *)VCArray
{
    WXZLiandong *liandong = [[WXZLiandong alloc] init];
    liandong.VC_array = VCArray;
    // 常量
    CGFloat labelScrollView_height = 35;
    CGFloat labelScrollView_width = [UIScreen mainScreen].bounds.size.width;
    // 添加labelScrollView
    UIScrollView *labelScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, labelScrollView_width, labelScrollView_height)];
    labelScrollView.backgroundColor = [UIColor redColor];
    labelScrollView.showsHorizontalScrollIndicator = NO;
    labelScrollView.showsVerticalScrollIndicator = NO;
    liandong.labelScrollView = labelScrollView;
    [liandong addSubview:labelScrollView];
    
    // 添加contentScrollView
    UIScrollView *contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 35, labelScrollView_width, 300 - labelScrollView_height)];
    contentScrollView.backgroundColor = [UIColor blueColor];
    contentScrollView.showsVerticalScrollIndicator = NO;
    contentScrollView.pagingEnabled = YES;
    contentScrollView.delegate = liandong;
    liandong.contentScrollView = contentScrollView;
    [liandong addSubview:contentScrollView];
    
    // 添加控制器
//    [liandong setUpVc];
    // 添加label
    [liandong setUpLabel];
    
    // 默认显示第一个控制器
    [liandong scrollViewDidEndScrollingAnimation:liandong.contentScrollView];
    return liandong;
}
- (NSMutableArray *)VC_array
{
    if (_VC_array == nil) {
        _VC_array = [NSMutableArray array];
    }
    return _VC_array;
}
//- (instancetype)initWithFrame:(CGRect)frame
//{
//    if (self = [super initWithFrame:frame]) {
//        [self setUp];
//    }
//    return self;
//}

- (void)setUp{
    // 常量
    CGFloat labelScrollView_height = 35;
    CGFloat labelScrollView_width = [UIScreen mainScreen].bounds.size.width;
    // 添加labelScrollView
    UIScrollView *labelScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, labelScrollView_width, labelScrollView_height)];
    labelScrollView.backgroundColor = [UIColor redColor];
    labelScrollView.showsHorizontalScrollIndicator = NO;
    labelScrollView.showsVerticalScrollIndicator = NO;
    self.labelScrollView = labelScrollView;
    [self addSubview:labelScrollView];
    
    // 添加contentScrollView
    UIScrollView *contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 35, labelScrollView_width, 300 - labelScrollView_height)];
    contentScrollView.backgroundColor = [UIColor blueColor];
    contentScrollView.showsVerticalScrollIndicator = NO;
    contentScrollView.pagingEnabled = YES;
    contentScrollView.delegate = self;
    self.contentScrollView = contentScrollView;
    [self addSubview:contentScrollView];
    
    // 添加控制器
//    [self setUpVc];
    // 添加label
    [self setUpLabel];
    
    // 默认显示第一个控制器
    [self scrollViewDidEndScrollingAnimation:self.contentScrollView];

}

/**
 *  添加控制器
 */
//- (void)setUpVc{
//    UIViewController *vc01 = [[UIViewController alloc] init];
//    vc01.view.backgroundColor = [UIColor greenColor];
//    vc01.title = @"户型";
//    [self.VC_array addObject:vc01];
//    
//    UIViewController *vc02 = [[UIViewController alloc] init];
//    vc02.view.backgroundColor = [UIColor yellowColor];
//    vc02.title = @"卖点";
//    [self.VC_array addObject:vc02];
//    
//    UIViewController *vc03 = [[UIViewController alloc] init];
//    vc03.view.backgroundColor = [UIColor purpleColor];
//    vc03.title = @"详情";
//    [self.VC_array addObject:vc03];
//}

/**
 *  添加label
 */
- (void)setUpLabel{
    
    // label总数
    NSInteger index = 3;
    
    // label长宽高
    CGFloat labelX;
    CGFloat labelY = 0;
    CGFloat labelW = [UIScreen mainScreen].bounds.size.width / 3;
    CGFloat labelH = self.labelScrollView.frame.size.height;
    
    for (NSInteger i = 0; i < index; i++) {
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor colorWithRed:arc4random_uniform(100) / 100.0 green:arc4random_uniform(100) / 100.0 blue:arc4random_uniform(100) / 100.0 alpha:1.0];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = [self.VC_array[i] title];
        labelX = i * labelW;
        label.frame = CGRectMake(labelX, labelY, labelW, labelH);
        [label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickLabel:)]];
        label.userInteractionEnabled = YES;
        [self.labelScrollView addSubview:label];
    }
    
    // 设置contentSize
    self.labelScrollView.contentSize = CGSizeMake(index * labelW, 0);
    self.contentScrollView.contentSize = CGSizeMake(index * [UIScreen mainScreen].bounds.size.width, 0);
}

/**
 *  监听label点击
 */
- (void)clickLabel:(UITapGestureRecognizer *)tap{
    // 获取点击的索引
    NSInteger index = [self.labelScrollView.subviews indexOfObject:tap.view];
    // 偏移相对应的索引
    CGPoint offset = self.contentScrollView.contentOffset;
    offset.x = index * [UIScreen mainScreen].bounds.size.width;
    [self.contentScrollView setContentOffset:offset animated:YES];
}

#pragma UIScrollViewDelegate
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    // 索引
    NSInteger index = scrollView.contentOffset.x / scrollView.frame.size.width;
    // 将控制器的view添加到contentScrollView中
    UIViewController *showVC = self.VC_array[index];
    showVC.view.frame = CGRectMake(scrollView.contentOffset.x, 0, scrollView.frame.size.width, scrollView.frame.size.height);
    [scrollView addSubview:showVC.view];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
}
@end
