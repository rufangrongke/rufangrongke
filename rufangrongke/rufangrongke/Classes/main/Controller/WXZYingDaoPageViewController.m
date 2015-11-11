//
//  WXZYingDaoPageViewController.m
//  引导页
//
//  Created by 儒房融科 on 15/11/11.
//  Copyright © 2015年 儒房融科. All rights reserved.
//

#import "WXZYingDaoPageViewController.h"
#import "WXZNavController.h"
#import "WXZLoginController.h"

@interface WXZYingDaoPageViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@end

@implementation WXZYingDaoPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    int count = 3;
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    CGFloat h = [UIScreen mainScreen].bounds.size.height;
    
    for (int i = 0; i<=count; i++) {
        // 创建
        UIImageView *imageView = [[UIImageView alloc] init];
        NSString *name = [NSString stringWithFormat:@"qz-sp%d", i+1];
        imageView.image = [UIImage imageNamed:name];
        // frame
        imageView.frame = CGRectMake(i * w, 0, w, h);
        [self.scrollView addSubview:imageView];
        if (i == 2) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
            [btn setBackgroundImage:[UIImage imageNamed:@"qz-button"] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(liKeJinRu) forControlEvents:UIControlEventTouchUpInside];
            // size
            CGRect frame = btn.frame;
            frame.size = btn.currentBackgroundImage.size;
            // y
            frame.origin.y = h - 100;
            btn.frame = frame;
            // center.x
            CGPoint center = btn.center;
            center.x = 2.5 * w;
            btn.center = center;
            [self.scrollView addSubview:btn];
        }

    }
    // 设置内容大小
    CGFloat contentW = count * w;
    self.scrollView.contentSize = CGSizeMake(contentW, 0);
    self.scrollView.showsHorizontalScrollIndicator = NO;
    // 开启分页功能
    self.scrollView.pagingEnabled = YES;
    
    // 总页数
    self.pageControl.numberOfPages = count;
    // 圈圈颜色
    self.pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
}

#pragma mark - <UIScrollViewDelegate>
/**
 * 只要scrollView在滚动，就会调用
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 0.3 > (int)(0.3 + 0.5) > 0
    // 0.6 > (int)(0.6 + 0.5) > 1
    // 小数四舍五入为整数 ： (int)(小数 + 0.5)
    int page = (int)(scrollView.contentOffset.x / scrollView.frame.size.width + 0.5);
    self.pageControl.currentPage = page;
}

// 按钮点击
- (void)liKeJinRu{
    // 创建Nav控制器
    WXZNavController *nav = [[WXZNavController alloc] initWithRootViewController:[[WXZLoginController alloc] init]];
    
    // 设置窗口的根控制器
    [[[[UIApplication sharedApplication] delegate] window] setRootViewController:nav];
}
@end
