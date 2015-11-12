//
//  WXZquYuListViewCell.h
//  rufangrongke
//
//  Created by 儒房融科 on 15/11/12.
//  Copyright © 2015年 王晓植. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXZquYuListViewCellModel.h"

@interface WXZquYuListViewCell : UITableViewCell
/* WXZquYuListViewCellModel */
@property (nonatomic , strong) Qus *qus;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UIImageView *chooseImage;
@end
