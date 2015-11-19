//
//  WXZWoHeadCell.h
//  rufangrongke
//
//  Created by 儒房融科 on 15/10/23.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXZWoInfoModel.h"

@interface WXZWoHeadCell : UITableViewCell

/**
 *  UIImageView:    图片
 *
 *  headBgImgVeiw  头像大背景图
 *  headBorderImgView  头像边框
 *  headImgView   头像
 *  certificationImgView    未认证／已认证
 */
@property (weak, nonatomic) IBOutlet UIImageView *headBgImgVeiw;
@property (weak, nonatomic) IBOutlet UIImageView *headBorderImgView;
@property (weak, nonatomic) IBOutlet UIImageView *headImgView; //
@property (weak, nonatomic) IBOutlet UIImageView *certificationImgView;

/**
 *  UILabel:    信息显示
 *
 *  userNameLabel   用户名
 *  storeYardsLabel     门店码
 *  declarationLabel    服务宣言
 */
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *storeYardsLabel;
@property (weak, nonatomic) IBOutlet UILabel *declarationLabel;

/**
 *  UIButton:   按钮
 *
 *  bindingBtn  立即绑定
 */
@property (weak, nonatomic) IBOutlet UIButton *bindingBtn;

@property (nonatomic,strong) WXZWoInfoModel *woInfoModel; // 数据 

// 加载nib文件
+ (instancetype)initHeadCell;

// 设置头像边框
- (void)headBorder;
// 更新头像
//- (void)updateWoInfo:(NSDictionary *)headInfoDic;

// 设置button单击事件
- (void)buttonWithTarget:(id)target withAction:(SEL)action;

@end
