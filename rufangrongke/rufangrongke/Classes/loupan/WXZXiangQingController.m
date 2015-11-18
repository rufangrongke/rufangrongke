//
//  WXZXiangQingController.m
//  rufangrongke
//
//  Created by 儒房融科 on 15/11/4.
//  Copyright © 2015年 王晓植. All rights reserved.
//

#import "WXZXiangQingController.h"

@interface WXZXiangQingController ()
@property (weak, nonatomic) IBOutlet UILabel *kaipanshijian;
@property (weak, nonatomic) IBOutlet UILabel *jiaofangshijian;
@property (weak, nonatomic) IBOutlet UILabel *kaifashangpinpai;
@property (weak, nonatomic) IBOutlet UILabel *wuyegongsi;
@property (weak, nonatomic) IBOutlet UILabel *jianzhumianji;
@property (weak, nonatomic) IBOutlet UILabel *zonghushu;
@property (weak, nonatomic) IBOutlet UILabel *rongjilv;
@property (weak, nonatomic) IBOutlet UILabel *lvhualv;
@property (weak, nonatomic) IBOutlet UILabel *cheweishu;
@property (weak, nonatomic) IBOutlet UILabel *cheweibi;
@property (weak, nonatomic) IBOutlet UILabel *junjia;
@property (weak, nonatomic) IBOutlet UILabel *wuyefei;
@property (weak, nonatomic) IBOutlet UILabel *jianzhuleixing;
@property (weak, nonatomic) IBOutlet UILabel *zhuangxiuleixing;
@property (weak, nonatomic) IBOutlet UILabel *chanquannianxian;

@end

@implementation WXZXiangQingController

- (void)viewDidLoad {
    [super viewDidLoad];
//    WXZLog(@"%@----viewdidiload", self.kaifashangpinpai);
    [self setModel:_model];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setModel:(View *)model
{
    _model = model;
    /*
     @property (weak, nonatomic) IBOutlet UILabel *kaipanshijian;
     @property (weak, nonatomic) IBOutlet UILabel *jiaofangshijian;
     @property (weak, nonatomic) IBOutlet UILabel *kaifashangpinpai;
     @property (weak, nonatomic) IBOutlet UILabel *wuyegongsi;
     @property (weak, nonatomic) IBOutlet UILabel *jianzhumianji;
     @property (weak, nonatomic) IBOutlet UILabel *zonghushu;
     @property (weak, nonatomic) IBOutlet UILabel *rongjilv;
     @property (weak, nonatomic) IBOutlet UILabel *lvhualv;
     @property (weak, nonatomic) IBOutlet UILabel *cheweishu;
     @property (weak, nonatomic) IBOutlet UILabel *cheweibi;
     @property (weak, nonatomic) IBOutlet UILabel *junjia;
     @property (weak, nonatomic) IBOutlet UILabel *wuyefei;
     @property (weak, nonatomic) IBOutlet UILabel *jianzhuleixing;
     @property (weak, nonatomic) IBOutlet UILabel *zhuangxiuleixing;
     @property (weak, nonatomic) IBOutlet UILabel *chanquannianxian;
     */
    /*
     1、字符串转换为日期
     
     　　NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
     
     [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//设定时间格式,这里可以设置成自己需要的格式
     
     NSDate *date =[dateFormat dateFromString:@"1980-01-01 00:00:01"];
     
     2、日期转换为字符串
     
     　　NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
     
     [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//设定时间格式,这里可以设置成自己需要的格式
     
     　　NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
     
     // y 年  M 月  d 日
     // m 分 s 秒  H （24）时  h（12）时
     */
    /* 06/01/2016 00:00:00 */
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
    NSDate *date =[dateFormat dateFromString:model.KaiPanTime];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    NSString *wxzTime = [dateFormatter stringFromDate:date];
    // 开盘时间
    if (model.KaiPanTime) {
        self.kaipanshijian.text = wxzTime;
    }
    // 交房时间
    date =[dateFormat dateFromString:model.JiaoFangTime];
    wxzTime = [dateFormatter stringFromDate:date];
    if (model.JiaoFangTime) {
        self.jiaofangshijian.text = wxzTime;
    }
    // 开发商品牌
    if (model.KaiFaShangPiPai) {
        self.kaifashangpinpai.text = model.KaiFaShangPiPai;
    }
    // 物业公司
    if (model.WuYeGongSi) {
        self.wuyegongsi.text = model.WuYeGongSi;
    }
    // 建筑面积
    if (model.Area_JianZhu) {
        self.jianzhumianji.text = [NSString stringWithFormat:@"%@平米", model.Area_JianZhu];
    }
    // 总户数
    if (model.ZongHuShu) {
        self.zonghushu.text = [NSString stringWithFormat:@"%@", model.ZongHuShu];
    }
    // 容积率
    if (model.RongJiLv) {
        self.rongjilv.text = [NSString stringWithFormat:@"%@", model.RongJiLv];
    }
    // 绿化率
    if (model.LvHuaLv) {
        self.lvhualv.text = [NSString stringWithFormat:@"%@", model.LvHuaLv];
    }
    // 车位数
    if (model.CheWeiShu) {
        self.cheweishu.text = [NSString stringWithFormat:@"%@", model.CheWeiShu];
    }
    // 车位比
    if (model.CheWeiBi) {
        self.cheweibi.text = model.CheWeiBi;
    }
    
    // 均价
    if (model.JunJia) {
        self.junjia.text = [NSString stringWithFormat:@"%@元", model.JunJia];
    }
    // 物业费
    if (model.WuYeFei) {
        self.wuyefei.text = [NSString stringWithFormat:@"%@", model.WuYeFei];
    }
    // 建筑类型
    if (model.JianZhuLeiXing) {
        self.jianzhuleixing.text = model.JianZhuLeiXing;
    }
    // 装修类型
    if (model.ZhuangXiu) {
        self.zhuangxiuleixing.text = model.ZhuangXiu;
    }
    // 产权年限
    if (model.ChanQuanNianXian) {
        self.chanquannianxian.text = [NSString stringWithFormat:@"%@", model.ChanQuanNianXian];
    }
}

@end
