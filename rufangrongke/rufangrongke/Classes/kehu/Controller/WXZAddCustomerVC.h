//
//  WXZAddCustomerVC.h
//  rufangrongke
//
//  Created by 儒房融科 on 15/11/4.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

/**
 * 添加新客户，或修改客户购房意向页面
 **/

#import <UIKit/UIKit.h>
#import "WXZKeHuDetailModel.h"

#pragma mark - 更新客户详情页信息协议
@protocol UpdateKeHuDetailInfoDelegate <NSObject>

- (void)updateKeHuDetailInfo:(NSString *)customerId; // 更新客户详情页信息方法

@end

@interface WXZAddCustomerVC : UIViewController 

@property (nonatomic,strong) NSString *titleStr; // 导航栏标题

@property (nonatomic,strong) WXZKeHuDetailModel *detailModel; // 客户详情数据模型

@property (nonatomic,assign) BOOL isModifyCustomerInfo; // 判断是否为修改客户信息

@property (nonatomic,assign) BOOL isKeHuDetail; // 判断是否是客户详情页面

@property (nonatomic,assign) id<UpdateKeHuDetailInfoDelegate> updateDelegate; // 声明更新客户详情页代理

@end
