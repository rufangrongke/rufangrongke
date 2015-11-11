//
//  WXZBasicInfoCell.h
//  rufangrongke
//
//  Created by 儒房融科 on 15/11/4.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXZKeHuDetailModel.h"

@interface WXZBasicInfoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTextField;

@property (weak, nonatomic) IBOutlet UIButton *menBtn;
@property (weak, nonatomic) IBOutlet UIButton *womenBtn;

@property (nonatomic,strong) WXZKeHuDetailModel *detailModel;

+ (instancetype)initBasicInfoCell;

- (void)modifyInfo:(WXZKeHuDetailModel *)model isModify:(BOOL)ismodify;

@end
