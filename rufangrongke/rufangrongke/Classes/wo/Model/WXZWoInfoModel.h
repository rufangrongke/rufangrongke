//
//  WXZWoInfoModel.h
//  rufangrongke
//
//  Created by 儒房融科 on 15/11/10.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

/**
 * “我”页面数据模型（登录请求的数据）
 **/

#import <Foundation/Foundation.h>

@interface WXZWoInfoModel : NSObject

@property (nonatomic,copy) NSString *ID; // 用户id
@property (nonatomic,copy) NSString *Mobile; // 用户手机号
@property (nonatomic,copy) NSString *sfzid; // 身份证id
@property (nonatomic,copy) NSString *tjm; // 我的推荐码
@property (nonatomic,copy) NSString *cityName; // 城市名
@property (nonatomic,copy) NSString *sfzPic; // 身份证正面照
@property (nonatomic,copy) NSString *cityid; // 城市id
@property (nonatomic,copy) NSString *LtName; // 门店名称
@property (nonatomic,copy) NSString *CongYeTime; // 从业时间
@property (nonatomic,copy) NSString *TrueName; // 用户真实姓名
@property (nonatomic,copy) NSString *XuanYan; // 服务宣言
@property (nonatomic,copy) NSString *Sex; // 用户性别
@property (nonatomic,copy) NSString *LtCid; // 门店id
@property (nonatomic,copy) NSString *TouXiang; // 用户头像
@property (nonatomic,copy) NSString *IsShiMing; // 是否已实名认证

@end
