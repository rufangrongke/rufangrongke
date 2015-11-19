//
//  WXZPersonalCityCell.h
//  rufangrongke
//
//  Created by 儒房融科 on 15/10/29.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

/**
 * 城市列表cell
 **/

#import <UIKit/UIKit.h>

@interface WXZPersonalCityCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *cityNameLabel; // 城市名称

+ (instancetype)initCityCell; // 加载nib文件

- (void)showContentCell:(NSString *)content; // 显示城市数据

@end
