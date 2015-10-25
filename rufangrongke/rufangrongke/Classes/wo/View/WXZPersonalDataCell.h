//
//  WXZPersonalDataCell.h
//  rufangrongke
//
//  Created by 儒房融科 on 15/10/24.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WXZPersonalDataCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headImgView;

// 加载nib文件
+ (instancetype)initPersonalDataCell;

// 头像边框
- (void)headBorder;
// 刷新头像
- (void)updateHead;

@end
