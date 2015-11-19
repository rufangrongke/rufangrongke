//
//  WXZPersonalInfoVC.h
//  rufangrongke
//
//  Created by 儒房融科 on 15/10/27.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

/**
 * 修改姓名、性别、密码共用页面
 **/

#import <UIKit/UIKit.h>
#import "WXZWoInfoModel.h"

@interface WXZPersonalInfoVC : UIViewController

@property (nonatomic,strong) NSString *whichController; // 哪个控制器

@property (nonatomic,strong) NSString *titleStr; // 标题

@property (nonatomic,strong) WXZWoInfoModel *woInfoModel; // “我”页面的数据模型

@end
