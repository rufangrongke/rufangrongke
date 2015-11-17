//
//  WXZLouPanHomeHeadView.m
//  rufangrongke
//
//  Created by 儒房融科 on 15/11/17.
//  Copyright © 2015年 王晓植. All rights reserved.
//

#import "WXZLouPanHomeHeadView.h"

@interface WXZLouPanHomeHeadView ()<UIScrollViewDelegate>
@end
@implementation WXZLouPanHomeHeadView
+ (instancetype)louPanHomeHeadView
{
    WXZLouPanHomeHeadView *louPanHomeHeadView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([WXZLouPanHomeHeadView class]) owner:nil options:nil].lastObject;
    // 375 130
    int count = 2;
    CGFloat w = louPanHomeHeadView.scrollView.bounds.size.width;
    CGFloat h = louPanHomeHeadView.scrollView.bounds.size.height;
    
    for (int i = 0; i<=count; i++) {
        // 创建
        UIImageView *imageView = [[UIImageView alloc] init];
        NSString *name = [NSString stringWithFormat:@"lp_babber%d", i];
        imageView.image = [UIImage imageNamed:name];
        // frame
        imageView.frame = CGRectMake(i * w, 0, w, h);
        [louPanHomeHeadView.scrollView addSubview:imageView];
        
    }
    // 设置内容大小
    CGFloat contentW = count * w;
    louPanHomeHeadView.scrollView.contentSize = CGSizeMake(contentW, 0);
    louPanHomeHeadView.scrollView.showsHorizontalScrollIndicator = NO;
    // 开启分页功能
    louPanHomeHeadView.scrollView.pagingEnabled = YES;
    louPanHomeHeadView.scrollView.delegate = self;
    // 总页数
    louPanHomeHeadView.pageControl.numberOfPages = count;
    // 圈圈颜色
    louPanHomeHeadView.pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    
    return louPanHomeHeadView;
}

//- (void)layoutSubviews{
//    [super layoutSubviews];
//    
//}
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
@end
