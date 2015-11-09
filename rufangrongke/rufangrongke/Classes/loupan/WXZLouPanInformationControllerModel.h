//
//  WXZLouPanInformationControllerModel.h
//  rufangrongke
//
//  Created by 儒房融科 on 15/11/6.
//  Copyright © 2015年 王晓植. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 {
 "pic":"/upFile/house/hx/20151106/20151106195240_9111.jpg",
 "fyhao":"5",
 "biaoQian":"南北通透,北向客厅,超大落地窗",
 "hx":"3室2厅1卫",
 "Area":"105.00",
 "JiaGe":"4000.00",
 "ChuShouNum":"100",
 "ChengJiaoNum":"13",
 "YouHui":"交1万减2万，装修基金1-2万。砸金蛋抽奖。",
 "ChaoXiang":"南北",
 "ZhuangXiu":"毛坯",
 "TuiJianLiYou":"北向客厅超大落地窗，超大楼间距，采光好。南北通透，性价比高，买就赚！",
 "abc":"A3",
 "others":[
 {
 "id":"12",
 "pic":"/upFile/house/hx/20151106/20151106195843_2490.jpg",
 "abc":"A2",
 "hx":"3室2厅1卫",
 "Area":"88.00",
 "JiaGe":"4000.00",
 "biaoQian":"双南卧,南向落地大阳台,飘窗"
 }
 ]
 }
 */
@class OthersModel;
@interface WXZLouPanInformationControllerModel : NSObject

@property (nonatomic, copy) NSString *ZhuangXiu;

@property (nonatomic, copy) NSString *TuiJianLiYou;

@property (nonatomic, copy) NSString *fyhao;

@property (nonatomic, copy) NSString *JiaGe;

@property (nonatomic, copy) NSString *ChengJiaoNum;

@property (nonatomic, strong) NSArray<OthersModel *> *others;

@property (nonatomic, copy) NSString *YouHui;

@property (nonatomic, copy) NSString *pic;

@property (nonatomic, copy) NSString *hx;

@property (nonatomic, copy) NSString *abc;

@property (nonatomic, copy) NSString *Area;

@property (nonatomic, copy) NSString *ChaoXiang;

@property (nonatomic, copy) NSString *biaoQian;

@property (nonatomic, copy) NSString *ChuShouNum;

@end
@interface OthersModel : NSObject

@property (nonatomic, copy) NSString *biaoQian;

@property (nonatomic, copy) NSString *hx;

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *pic;

@property (nonatomic, copy) NSString *abc;

@property (nonatomic, copy) NSString *JiaGe;

@property (nonatomic, copy) NSString *Area;

@end

