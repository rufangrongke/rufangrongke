//
//  WXZLouPanMaiDianCell.h
//  rufangrongke
//
//  Created by 儒房融科 on 15/11/6.
//  Copyright © 2015年 王晓植. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXZLouPanMessageModel.h"
@interface WXZLouPanMaiDianCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *louPanMaiDianLabel;
/* model */
@property (nonatomic , strong) WXZLouPanMessageModel *model;
@end
