//
//  WXZKeHuInfoModel.h
//  rufangrongke
//
//  Created by 儒房融科 on 15/11/10.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

/**
 * 客户首页列表数据模型
 **/

#import <Foundation/Foundation.h>

@interface WXZKeHuInfoModel : NSObject

@property (nonatomic,copy) NSString *ID; // 客户号
@property (nonatomic,copy) NSString *Mobile; // 客户手机号
@property (nonatomic,copy) NSString *XingMing; // 客户姓名
@property (nonatomic,copy) NSString *QuYu; // 购房区域
@property (nonatomic,copy) NSString *YiXiang; // 购房整体意向
@property (nonatomic,copy) NSString *loupan; // 最新互动的楼盘名称
@property (nonatomic,copy) NSString *hdTime; // 最新互动时间
@property (nonatomic,copy) NSString *Hx; // 购房户型和房型
@property (nonatomic,copy) NSString *typebig; // 互动类型
@property (nonatomic,copy) NSString *Row; // 行号
@property (nonatomic,copy) NSString *Sex; // 客户性别
@property (nonatomic,copy) NSString *typeSmall; // 互动详情

@end
