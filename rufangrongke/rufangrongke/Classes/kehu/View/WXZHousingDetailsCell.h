//
//  WXZHousingDetailsCell.h
//  rufangrongke
//
//  Created by 儒房融科 on 15/11/5.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WXZHousingDetailsCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIView *customerInfoView;
@property (weak, nonatomic) IBOutlet UIView *tipsView;

@property (weak, nonatomic) IBOutlet UIImageView *bg1ImgView;
@property (weak, nonatomic) IBOutlet UIImageView *bg2ImgView;
@property (weak, nonatomic) IBOutlet UIImageView *bg3ImgView;
@property (weak, nonatomic) IBOutlet UIImageView *bj4ImgView;

@property (weak, nonatomic) IBOutlet UILabel *loupanNameLab;
@property (weak, nonatomic) IBOutlet UILabel *bj1Label;
@property (weak, nonatomic) IBOutlet UILabel *bj2Label;
@property (weak, nonatomic) IBOutlet UILabel *bj3Label;
@property (weak, nonatomic) IBOutlet UILabel *bj4Label;
@property (weak, nonatomic) IBOutlet UILabel *jieshouLab;
@property (weak, nonatomic) IBOutlet UILabel *daikanLab;
@property (weak, nonatomic) IBOutlet UILabel *chengjiaoLab;
@property (weak, nonatomic) IBOutlet UILabel *jieyongLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *jiedairenLab;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;

@property (weak, nonatomic) IBOutlet UIButton *statusBtn;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;
@property (weak, nonatomic) IBOutlet UIButton *chongfaBtn;

+ (instancetype)initHousingDetailsCell;

- (void)updateInfo;
- (void)showInfo:(NSDictionary *)dic;

@end
