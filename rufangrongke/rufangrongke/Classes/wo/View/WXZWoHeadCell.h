//
//  WXZWoHeadCell.h
//  rufangrongke
//
//  Created by 儒房融科 on 15/10/23.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WXZWoHeadCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headBgImgVeiw; // 头像大背景图
@property (weak, nonatomic) IBOutlet UIImageView *headBorderImgView; // 头像边框
@property (weak, nonatomic) IBOutlet UIImageView *headImgView; // 头像
@property (weak, nonatomic) IBOutlet UIImageView *certificationImgView;

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *storeYardsLabel;
@property (weak, nonatomic) IBOutlet UILabel *declarationLabel;

@property (weak, nonatomic) IBOutlet UIButton *bindingBtn;

+ (instancetype)initHeadCell;

@end
