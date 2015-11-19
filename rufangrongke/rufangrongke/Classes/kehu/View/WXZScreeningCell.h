//
//  WXZScreeningCell.h
//  rufangrongke
//
//  Created by 儒房融科 on 15/11/17.
//  Copyright © 2015年 王晓植. All rights reserved.
//

/**
 * 筛选类型cell
 **/

#import <UIKit/UIKit.h>

@interface WXZScreeningCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel; // 筛选类型内容展示
@property (weak, nonatomic) IBOutlet UIImageView *selectImgView; // 筛选类型选中图片

@end
