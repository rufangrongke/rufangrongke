//
//  WXZLouPanMessageCell_0_0.h
//  rufangrongke
//
//  Created by 儒房融科 on 15/10/28.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXZLouPanMessageModel.h"

@interface WXZLouPanMessageCell_0_0 : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *loupanJunJia;
@property (weak, nonatomic) IBOutlet UILabel *loupanWeiZhi;
@property (weak, nonatomic) IBOutlet UILabel *shouCangNum;

/* WXZLouPanMessageCell_0_0_Dic */
//@property (nonatomic , strong) NSNumber *shouCan;

/* model */
@property (nonatomic , strong) View *model;
@end
