//
//  XMGPageView.h
//  08-分页
//
//  Created by xiaomage on 15/5/28.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XMGPageView : UIView
+ (instancetype)pageView;
/** 图片名字 */
@property (nonatomic, strong) NSArray *imageNames;
/** 其他圆点颜色 */
@property (nonatomic, strong) UIColor *otherColor;
/** 当前圆点颜色 */
@property (nonatomic, strong) UIColor *currentColor;
@end
