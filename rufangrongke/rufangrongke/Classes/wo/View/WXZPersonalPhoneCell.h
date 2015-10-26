//
//  WXZPersonalPhoneCell.h
//  rufangrongke
//
//  Created by 儒房融科 on 15/10/26.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WXZPersonalPhoneCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *phoneInfoLabel;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;

@property (weak, nonatomic) IBOutlet UIButton *codeBtn;

// 加载nib文件
+ (instancetype)initPersonalPhoneCell;

- (void)phoneInfo:(NSIndexPath *)indexPath;

@end
