//
//  WXZLouPanMessageCell_0_1.h
//  rufangrongke
//
//  Created by 儒房融科 on 15/10/28.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXZLouPanMessageModel.h"
@interface WXZLouPanMessageCell_0_1 : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *yixiangkehuNum;
@property (weak, nonatomic) IBOutlet UILabel *hezuojingjirenNum;
@property (weak, nonatomic) IBOutlet UILabel *zuijinchengjiaoNum;
/* model */
@property (nonatomic , strong) View *model;
@end
