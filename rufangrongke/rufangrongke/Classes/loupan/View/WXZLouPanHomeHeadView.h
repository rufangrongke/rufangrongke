//
//  WXZLouPanHomeHeadView.h
//  rufangrongke
//
//  Created by 儒房融科 on 15/11/17.
//  Copyright © 2015年 王晓植. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WXZLouPanHomeHeadView : UIView
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
+ (instancetype)louPanHomeHeadView;
@end
