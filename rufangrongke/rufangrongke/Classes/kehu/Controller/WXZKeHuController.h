//
//  WXZKeHuController.h
//  rufangrongke
//
//  Created by dymost on 15/10/18.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

/**
 * 客户列表页面
 **/

#import <UIKit/UIKit.h>

#pragma mark - 返回筛选类型协议
@protocol BackFilterTypeDelegate <NSObject>

- (void)backScreeningType:(NSString *)type; // 返回筛选类型

@end

@interface WXZKeHuController : UITableViewController

@end
