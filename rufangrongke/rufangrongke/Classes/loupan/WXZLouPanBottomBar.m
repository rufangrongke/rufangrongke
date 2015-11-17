//
//  WXZLouPanBottomBar.m
//  rufangrongke
//
//  Created by 儒房融科 on 15/11/6.
//  Copyright © 2015年 王晓植. All rights reserved.
//

#import "WXZLouPanBottomBar.h"

@interface WXZLouPanBottomBar ()
/* 摇积分 */
@property (weak, nonatomic) IBOutlet UIImageView *yaojifeng_bgView;
@property (weak, nonatomic) IBOutlet UIImageView *yaojifeng_image;
@property (weak, nonatomic) IBOutlet UILabel *yaojifen_label;
@property (weak, nonatomic) IBOutlet UIButton *yaojifeng_btn;
/* 驻守 */
@property (weak, nonatomic) IBOutlet UIImageView *zhushou_bgView;
@property (weak, nonatomic) IBOutlet UIImageView *zhushou_image;
@property (weak, nonatomic) IBOutlet UILabel *zhushou_label;
@property (weak, nonatomic) IBOutlet UIButton *zhushou_btn;
/* 我的客户 */
@property (weak, nonatomic) IBOutlet UIImageView *wodekehu_bgView;
@property (weak, nonatomic) IBOutlet UIImageView *wodekehu_image;
@property (weak, nonatomic) IBOutlet UILabel *wodekehu_label;
@property (weak, nonatomic) IBOutlet UIButton *wodekehu_btn;
/* 报备客户 */
@property (weak, nonatomic) IBOutlet UIImageView *babeikehu_bgView;
@property (weak, nonatomic) IBOutlet UILabel *baobeikehu_label;
@property (weak, nonatomic) IBOutlet UIButton *baobeikehu_btn;

@end
@implementation WXZLouPanBottomBar
/**
 *  yaojifeng_btn
 */
- (IBAction)yaojifeng:(UIButton *)yaojifeng_btn {
//    yaojifeng_btn.selected = !yaojifeng_btn.selected;
//    if (yaojifeng_btn.selected) {
//        
//    }
    [SVProgressHUD showSuccessWithStatus:@"新功能尚未推出,尽请期待"];
}
/**
 *  zhushou_btn
 */
- (IBAction)zhushou:(UIButton *)zhushou_btn {
    [SVProgressHUD showSuccessWithStatus:@"新功能尚未推出,尽请期待"];
}
/**
 *  wodekehu_btn
 */
- (IBAction)wodekehu:(UIButton *)wodekehu_btn {
    wodekehu_btn.selected = !wodekehu_btn.selected;
    [self.delegate louPanBottomBar_click_wodekehu];
}
/**
 *  baobeikehu_btn
 */
- (IBAction)baobeikehu:(UIButton *)baobeikehu_btn {
    baobeikehu_btn.selected = !baobeikehu_btn.selected;
    [self.delegate louPanBottomBar_click_baobeikehu];
}

@end
