//
//  WXZKeHuDetailModel.h
//  rufangrongke
//
//  Created by 儒房融科 on 15/11/10.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

/**
 * 客户详情页数据模型
 **/

#import <Foundation/Foundation.h>

@interface WXZKeHuDetailModel : NSObject

@property (nonatomic,copy) NSString *ID; // 客户id
@property (nonatomic,copy) NSString *Mobile; // 客户电话
@property (nonatomic,copy) NSString *bbTime; // 互动时间
@property (nonatomic,copy) NSString *uid; //
@property (nonatomic,copy) NSString *JiaGeS; // 客户购房价格范围－开始价格
@property (nonatomic,copy) NSString *LastLookTime; // 最后看房时间
@property (nonatomic,copy) NSString *typeBig; // 互动类型
@property (nonatomic,copy) NSString *XingMing; // 客户姓名
@property (nonatomic,copy) NSString *QuYu; // 购房意向区域
@property (nonatomic,copy) NSString *fyhao; // 房源号
@property (nonatomic,copy) NSString *YiXiang; // 客户购房整体意向
@property (nonatomic,copy) NSString *JiaGeE; // 客户购房价格范围－结束价格
@property (nonatomic,copy) NSString *cityid; // 城市id
@property (nonatomic,copy) NSString *Hx; // 意向房型和户型
@property (nonatomic,copy) NSString *xiaoqu; // 小区名称
@property (nonatomic,copy) NSString *AddTime; // 添加时间
@property (nonatomic,copy) NSString *Sex; // 客户性别
@property (nonatomic,copy) NSString *typeSmall; // 互动详情

@end
