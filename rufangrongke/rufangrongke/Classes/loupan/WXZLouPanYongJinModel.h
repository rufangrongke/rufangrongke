//
//  WXZLouPanYongJinModel.h
//  rufangrongke
//
//  Created by 儒房融科 on 15/11/9.
//  Copyright © 2015年 王晓植. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KfsgzYongjin,ListYongJin;
@interface WXZLouPanYongJinModel : NSObject

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, assign) BOOL ok;

@property (nonatomic, strong) NSArray/*<ListYongJin *>*/ *list;

@property (nonatomic, strong) KfsgzYongjin *KFSgz;

@end
@interface KfsgzYongjin : NSObject

@property (nonatomic, copy) NSString *JiangLi;

@property (nonatomic, copy) NSString *fyhao;

@property (nonatomic, copy) NSString *HeZuoTimeS;

@property (nonatomic, copy) NSString *HeZuoFy;

@property (nonatomic, copy) NSString *HeZuoTimeE;

@property (nonatomic, copy) NSString *BaoHuQi;

@property (nonatomic, copy) NSString *KFSJiangLi;

@end

@interface ListYongJin : NSObject

@property (nonatomic, copy) NSString *JieDian_HY;

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *QianYong;

@property (nonatomic, copy) NSString *Title;

@property (nonatomic, copy) NSString *JieDian_Qy;

@property (nonatomic, copy) NSString *HouYong;

@end

