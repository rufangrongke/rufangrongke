//
//  WXZLouPanHuXingController.h
//  rufangrongke
//
//  Created by 儒房融科 on 15/11/6.
//  Copyright © 2015年 王晓植. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  LouPanHuXingControllerDelegate <NSObject>

- (void)louPanHuXingControllerDelegate:(UIViewController *)vc;

@end
@interface WXZLouPanHuXingController : UIViewController
/* 代理 */
@property (nonatomic , weak) id<LouPanHuXingControllerDelegate> delegate;

/* 楼盘参数 */
@property(nonatomic,copy) NSString *fyhao;
@end
