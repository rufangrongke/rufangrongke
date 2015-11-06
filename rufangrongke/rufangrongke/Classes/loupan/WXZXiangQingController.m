//
//  WXZXiangQingController.m
//  rufangrongke
//
//  Created by 儒房融科 on 15/11/4.
//  Copyright © 2015年 王晓植. All rights reserved.
//

#import "WXZXiangQingController.h"
#import <SVProgressHUD.h>
#import <MJRefresh.h>
#import <MJExtension.h>
#import <UIImageView+WebCache.h>
#import "AFNetworking.h"
#import "WXZLouPanXiangQingModel.h"

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

/* WXZLouPanXiangQingModel */
@property (nonatomic , strong) WXZLouPanXiangQingModel *louPanXiangQingModel;
@end

@implementation WXZXiangQingController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 1.创建请求对象
    NSString *urlString = [OutNetBaseURL stringByAppendingString:@"HnView.ashx"];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"fy"] = @4;
    // afn
    [[AFHTTPSessionManager manager] POST:urlString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dic = (NSDictionary *)responseObject;
//        NSDictionary *view = dic[@"view"];
        self.louPanXiangQingModel = [WXZLouPanXiangQingModel objectWithKeyValues:dic[@"view"]];

        // 4.回到主线程
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//            if ([dic[@"ok"] isEqualToNumber:@1]) { // 正确登陆
//                // 隐藏HUD
//                [SVProgressHUD dismiss];
//                
//            }else{ //登陆失败
//                [SVProgressHUD showErrorWithStatus:@"用户名或者密码错误" maskType:SVProgressHUDMaskTypeBlack];
//            }
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
            NSDate *date =[dateFormat dateFromString:self.louPanXiangQingModel.KaiPanTime];
            [dateFormat setDateFormat:@"yyyyn年MM月dd日 HH:mm:ss"];
            NSString *kaiPanTime = [dateFormat stringFromDate:date];
            NSLog(@"%@", kaiPanTime);
//            self.kaipanshijian.text = self.louPanXiangQingModel.KaiPanTime;
//            self.jiaofangshijian.text = self.louPanXiangQingModel.JiaoFangTime;
//            self.kaifashangpinpai.text = self.louPanXiangQingModel.JiaoFangTime;
//            self.wuyegongsi.text = self.louPanXiangQingModel.JiaoFangTime;
//            self.jianzhumianji.text = self.louPanXiangQingModel.JiaoFangTime;
//            self.zonghushu.text = self.louPanXiangQingModel.JiaoFangTime;
//            self.rongjilv.text = self.louPanXiangQingModel.JiaoFangTime;
//            self.lvhualv.text = self.louPanXiangQingModel.JiaoFangTime;
//            self.cheweishu.text = self.louPanXiangQingModel.JiaoFangTime;
//            self.cheweibi.text = self.louPanXiangQingModel.JiaoFangTime;
//            self.junjia.text = self.louPanXiangQingModel.JiaoFangTime;
//            self.wuyefei.text = self.louPanXiangQingModel.JiaoFangTime;
//            self.jianzhuleixing.text = self.louPanXiangQingModel.JiaoFangTime;
//            self.zhuangxiuleixing.text = self.louPanXiangQingModel.JiaoFangTime;
//            self.chanquannianxian.text = self.louPanXiangQingModel.JiaoFangTime;
            
            
        }];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [SVProgressHUD showErrorWithStatus:@"登陆超时,请重新登陆." maskType:SVProgressHUDMaskTypeBlack];
        }];
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
