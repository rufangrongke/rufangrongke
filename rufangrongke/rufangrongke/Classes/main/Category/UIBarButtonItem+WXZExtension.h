//
//  UIBarButtonItem+WXZExtension.h
//  rufangrongke
//
//  Created by 儒房融科 on 15/10/26.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (WXZExtension)
+ (instancetype)itemWithImage:(NSString *)image highImage:(NSString *)highImage target:(id)target action:(SEL)action;

+ (instancetype)itemWithImage2:(NSString *)image highImage:(NSString *)highImage title:(NSString *)title target:(id)target action:(SEL)action isEnable:(BOOL)enable;
@end
