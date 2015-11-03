#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

// picBaseULR
//NSString * const picBaseULR = @"http://linshi.benbaodai.com";
NSString * const picBaseULR = @"http://192.168.1.21:34";

// 0.基础URL
//NSString * const OutNetBaseURL = @"http://linshi.benbaodai.com/svs/";
NSString * const OutNetBaseURL = @"http://192.168.1.61/Svs/";
// @"http://192.168.1.21:34/Svs/";

// 1.城市列表
NSString * const chengshileibiao = @"allcity.ashx";
NSString * const chengshileibiao_parameter;

// 2.验证码发送接口 --
NSString * const yanzhengma = @"sjyzm.ashx";
NSString * const yanzhengma_parameter = @"Act=Reg";

// 3.注册 --
NSString * const zhuce = @"UsReg.ashx";
NSString * const zhuce_parameter = @"xm=&mob=&pas=&yzm=&mobtj=";

// 4.登录
NSString * const denglu = @"Uslogin.ashx";
NSString * const denglu_parameter = @"mob=18833198077&pas=123456";

// 5.找回密码 --
NSString * const zhaohuimima = @"UsRpass.ashx";
NSString * const zhaohuimima_parameter = @"mob=&pas=&yzm=";

// 6.区域列表
NSString * const quyuliebiao = @"quList.ashx";
NSString * const quyuliebiao_parameter;

// 7.户型详情 --
NSString * const huxingxiangqing = @"HnHxView.ashx";
NSString * const huxingxiangqing_parameter = @"hxid=1";

// 8.楼盘列表
NSString * const loupanliebiao = @"HnList.ashx";
NSString * const loupanliebiao_parameter = @"inp=1";

// 9.楼盘详情 --
NSString * const loupanxiangqing = @"HnView.ashx";
NSString * const loupanxiangqing_parameter = @"fy=1";

// 10.佣金列表 --
NSString * const yongjinliebiao = @"HnYj.ashx";
NSString * const yongjinliebiao_parameter = @"fy=1";

// 11.楼盘上报备的客户 --
NSString * const loupanshangbaobeidekehu = @"KeListfy.ashx";
NSString * const loupanshangbaobeidekehu_parameter = @"fyhao=1";

// 12.客户报备 --
NSString * const kehubaobei = @"KeBB.ashx";
NSString * const kehubaobei_parameter = @"fyhao=1&kid=&loupan";

// 13.客户添加 --
NSString * const kehutianjia = @"KeAdd.ashx";
NSString * const kehutianjia_parameter = @"XingMing=&Sex=&Mobile=";

// 14.客户列表
NSString * const kehuliebiao = @"KeList.ashx";
NSString * const kehuliebiao_parameter = @"inp=1";

// 15.客户详情 --
NSString * const kehuxiangqing = @"KeOne.ashx";
NSString * const kehuxiangqing_parameter = @"fy=1";

// 16.客户修改 --
NSString * const kehuxiugai = @"KeGai.ashx";
NSString * const kehuxiugai_parameter = @"id=1";

// 17.上传图片 --
NSString * const shangchuangtupian = @"PicUser.ashx";
NSString * const shangchuangtupian_parameter = @"lx=&File=";

// 18.经纪人资料修改 --
NSString * const jinjirenziliaoxiugai = @"UsGai.ashx";
NSString * const jinjirenziliaoxiugai_parameter = @"lN=&lD=";

// 19.经纪人修改手机号 --
NSString * const jinjirenxiugaishoujihao = @"UsGaimob.ashx";
NSString * const jinjirenxiugaishoujihao_parameter = @"lN=&lD=";

// 20.经纪人修改密码 --
NSString * const jingjirenxiugaimima = @"UsGaipas.ashx";
NSString * const jingjirenxiugaimima_parameter = @"yzm=&mob=";

// 21.经纪人公司绑定 --
NSString * const jinjirengongsibagding = @"UsLt.ashx";
NSString * const jinjirengongsibagding_parameter = @"ltcid=&ltname=&picfile=";

// 22.经纪人实名认证 --
NSString * const jingjirenshimingrenzheng = @"UsRz.ashx";
NSString * const jingjirenshimingrenzheng_parameter = @"truename=&sfzid=&sfzPic=";

/************************************************************************************/
// 用户名密码常量
NSString * const phoneNumber = @"phoneNumber";
NSString * const password = @"password";

// 用户信息沙河存储路径userinfo.plist
NSString * const userinfoFile = @"userinfo.plist";
