//
//  WXZWoListCell.h
//  rufangrongke
//
//  Created by 儒房融科 on 15/10/22.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WXZWoListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *listImgView;
@property (weak, nonatomic) IBOutlet UILabel *listTitleLabel;

+ (instancetype)initHeadCell;

@end
