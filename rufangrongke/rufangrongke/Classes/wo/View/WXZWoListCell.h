//
//  WXZWoListCell.h
//  rufangrongke
//
//  Created by 儒房融科 on 15/10/22.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WXZWoListCell : UITableViewCell

/**
 *  列表:  意见反馈/排行榜/百问百答/帮助
 *
 *  listImgView     列表左侧图片
 *  listTitleLabel  列表的标题
 */
@property (weak, nonatomic) IBOutlet UIImageView *listImgView;
@property (weak, nonatomic) IBOutlet UILabel *listTitleLabel;

// 加载nib文件
+ (instancetype)initHeadCell;

// 设置列表信息（意见反馈/排行榜/百问百答/帮助）
- (void)listInfoWithSection:(NSInteger)section row:(NSInteger)row;

@end
