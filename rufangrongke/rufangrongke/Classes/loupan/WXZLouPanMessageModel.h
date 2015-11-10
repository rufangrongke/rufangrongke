//
//  WXZLouPanMessageModel.h
//  rufangrongke
//
//  Created by 儒房融科 on 15/11/10.
//  Copyright © 2015年 王晓植. All rights reserved.
//

#import <Foundation/Foundation.h>

@class View,Pics,Hxs;
@interface WXZLouPanMessageModel : NSObject

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) View *view;

@property (nonatomic, assign) BOOL ok;

@end
@interface View : NSObject

@property (nonatomic, copy) NSString *RongJiLv;

@property (nonatomic, copy) NSString *MuBiaoKeHu;

@property (nonatomic, copy) NSString *qu;

@property (nonatomic, copy) NSString *XiangMuJingLi;

@property (nonatomic, copy) NSString *KaiPanTime;

@property (nonatomic, copy) NSString *XiangMuTel;

@property (nonatomic, copy) NSString *Area_JianZhu;

@property (nonatomic, copy) NSString *AddTime;

@property (nonatomic, copy) NSString *PicUrl;

@property (nonatomic, copy) NSString *JiaoFangTime;

@property (nonatomic, strong) NSArray<Pics *> *pics;

@property (nonatomic, copy) NSString *KaiFaShang;

@property (nonatomic, assign) NSInteger ChengJiaoNum;

@property (nonatomic, strong) NSArray<Hxs *> *hxs;

@property (nonatomic, copy) NSString *xiaoqu;

@property (nonatomic, assign) BOOL IsHot;

@property (nonatomic, assign) NSInteger HeZuoJJrNum;

@property (nonatomic, copy) NSString *KaiFaShangPiPai;

@property (nonatomic, copy) NSString *MapX;

@property (nonatomic, copy) NSString *MaiDian;

@property (nonatomic, assign) NSInteger AddUser;

@property (nonatomic, copy) NSString *LvHuaLv;

@property (nonatomic, copy) NSString *CheWeiBi;

@property (nonatomic, copy) NSString *fyhao;

@property (nonatomic, copy) NSString *TJHX;

@property (nonatomic, copy) NSString *WeiZhi;

@property (nonatomic, copy) NSString *WuYeFei;

@property (nonatomic, assign) NSInteger YongJin;

@property (nonatomic, assign) NSInteger cityid;

@property (nonatomic, copy) NSString *MapY;

@property (nonatomic, copy) NSString *WuYeGongSi;

@property (nonatomic, copy) NSString *ChanQuanNianXian;

@property (nonatomic, assign) NSInteger isTop;

@property (nonatomic, assign) NSInteger ShouCangNum;

@property (nonatomic, copy) NSString *Area_ZhanDi;

@property (nonatomic, copy) NSString *JianZhuLeiXing;

@property (nonatomic, copy) NSString *TuoKeJiQiao;

@property (nonatomic, assign) NSInteger YiXiangKeHuNum;

@property (nonatomic, copy) NSString *ZongHuShu;

@property (nonatomic, copy) NSString *ZhuangXiu;

@property (nonatomic, copy) NSString *JunJia;

@property (nonatomic, copy) NSString *CheWeiShu;

@property (nonatomic, copy) NSString *pian;

@end

@interface Pics : NSObject

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *PicUrl;

@property (nonatomic, copy) NSString *PicType;

@end

@interface Hxs : NSObject

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *Area;

@property (nonatomic, copy) NSString *pic;

@property (nonatomic, copy) NSString *abc;

@property (nonatomic, copy) NSString *hx;

@end

