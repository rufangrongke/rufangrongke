//
//  WXZPersonalCityVC.h
//  rufangrongke
//
//  Created by 儒房融科 on 15/10/26.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXZLouPanController.h"

#pragma mark - 返货城市名称的代理方法
@protocol BackCityNameDelegate <NSObject>

- (void)backCityName:(NSString *)cityName;

@end

@interface WXZPersonalCityVC : UIViewController

@property (nonatomic,strong) NSString *currentCity;

@property (nonatomic,assign) id<BackCityNameDelegate> cityDelegate;

@end
