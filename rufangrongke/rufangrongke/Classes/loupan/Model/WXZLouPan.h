//
//  WXZLouPan.h
//  rufangrongke
//
//  Created by dymost on 15/10/20.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Fys;
@interface WXZLouPan : NSObject

@property (nonatomic, assign) NSInteger rowcount;

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, assign) BOOL ok;

@property (nonatomic, strong) NSArray/*<Fys *>*/ *fys;

@end
@interface Fys : NSObject

@property (nonatomic, copy) NSString *PicUrl;

@property (nonatomic, copy) NSString *TJHX;

@property (nonatomic, copy) NSString *MapX;

@property (nonatomic, copy) NSString *fyhao;

@property (nonatomic, copy) NSString *addtime;

@property (nonatomic, copy) NSString *YiXiangKeHuNum;

@property (nonatomic, copy) NSString *xiaoqu;

@property (nonatomic, copy) NSString *JunJia;

@property (nonatomic, copy) NSString *qu;

@property (nonatomic, copy) NSString *YongJin;

@property (nonatomic, copy) NSString *isTop;

@property (nonatomic, assign) NSInteger Row;

@property (nonatomic, copy) NSString *MapY;

@property (nonatomic, copy) NSString *HeZuoJJrNum;

@end

