//
//  WXZPersonalData2Cell.h
//  rufangrongke
//
//  Created by 儒房融科 on 15/10/24.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WXZPersonalData2Cell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UILabel *certificationLabel;
@property (weak, nonatomic) IBOutlet UIImageView *certificationImgView;

// 加载nib文件
+ (instancetype)initPersonalData2Cell;

// 初始化信息
- (void)personalDataInfo:(NSInteger)row data:(NSMutableDictionary *)dic;
//
- (void)buttonWithTarget:(id)target action:(SEL)action;

@end
