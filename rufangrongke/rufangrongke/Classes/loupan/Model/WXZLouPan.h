//
//  WXZLouPan.h
//  rufangrongke
//
//  Created by dymost on 15/10/20.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WXZLouPan : NSObject
/*
 PicUrl : /upFile/house/loupan/20151015/20151015235322_7825.jpg,
	TJHX : 2室90平,3室117平,
	MapX : ,
	fyhao : 4,
	addtime : 2015-10-15,
	YiXiangKeHuNum : 2733,
	xiaoqu : 藏龙居,
	JunJia : 5100,
	qu : 兰山区,
	YongJin : 7000,
	isTop : 0,
	Row : 1,
	MapY : ,
	HeZuoJJrNum : 480
 */

@property(nonatomic ,copy) NSString *PicUrl;
//@property(nonatomic ,copy) NSString *TJHX;
//@property(nonatomic ,strong) NSNumber *fyhao;
//@property(nonatomic ,copy) NSString *addtime;
@property(nonatomic ,copy) NSString *YiXiangKeHuNum;
@property(nonatomic ,copy) NSString *xiaoqu;
@property(nonatomic ,copy) NSString *JunJia;
//@property(nonatomic ,copy) NSString *qu;
@property(nonatomic ,copy) NSString *YongJin;
//@property(nonatomic ,assign) BOOL isTop;
//@property(nonatomic ,strong) NSNumber *Row;
@property(nonatomic ,copy) NSString *HeZuoJJrNum;

@end
