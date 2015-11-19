//
//  WXZPersonalCityVC.h
//  rufangrongke
//
//  Created by 儒房融科 on 15/10/26.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

/**
 * 修改城市页面
 **/

#import <UIKit/UIKit.h>
#import "WXZLouPanController.h"

#pragma mark - 返回城市名称的协议
@protocol BackCityNameDelegate <NSObject>

- (void)backCityName:(NSString *)cityName; // 返回城市名称

@end

@interface WXZPersonalCityVC : UIViewController

@property (nonatomic,strong) NSString *currentCity; // 当前城市

@property (nonatomic,assign) id<BackCityNameDelegate> cityDelegate; // 返回城市名称的代理

@end
