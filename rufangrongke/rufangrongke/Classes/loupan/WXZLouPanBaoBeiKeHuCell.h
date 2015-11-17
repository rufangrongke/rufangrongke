//
//  WXZLouPanBaoBeiKeHuCell.h
//  rufangrongke
//
//  Created by 儒房融科 on 15/11/16.
//  Copyright © 2015年 王晓植. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXZLouPanBaoBeiKeHuModel.h"

@interface WXZLouPanBaoBeiKeHuCell : UITableViewCell
/* WXZLouPanBaoBeiKeHuModel.h */
@property (nonatomic , strong) List *list;
@property (weak, nonatomic) IBOutlet UIImageView *selectImageView;
@end
