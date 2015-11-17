//
//  WXZPersonalCityCell.h
//  rufangrongke
//
//  Created by 儒房融科 on 15/10/29.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WXZPersonalCityCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *cityNameLabel;

+ (instancetype)initCityCell;

- (void)showContentCell:(NSString *)content;

@end
