//
//  WXZKHListFooterView.h
//  rufangrongke
//
//  Created by 儒房融科 on 15/10/24.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXZKeHuInfoModel.h"

@interface WXZKHListFooterView : UIView

@property (nonatomic,strong) WXZKeHuInfoModel *keHuInfoModel;

// 加载nib文件
+ (instancetype)initListFooterView;

// footer信息
//- (void)footerInfoLabel:(NSDictionary *)info;

@end
