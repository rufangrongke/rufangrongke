//
//  WXZPersonalDataCell.h
//  rufangrongke
//
//  Created by 儒房融科 on 15/10/24.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

/**
 * 个人资料头像cell
 **/

#import <UIKit/UIKit.h>
#import "WXZWoInfoModel.h"

@interface WXZPersonalDataCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headImgView; // 头像图片

@property (nonatomic,strong) WXZWoInfoModel *woInfoModel; // "我"页面数据模型

// 加载nib文件
+ (instancetype)initPersonalDataCell;

@end
