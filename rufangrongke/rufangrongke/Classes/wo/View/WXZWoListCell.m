//
//  WXZWoListCell.m
//  rufangrongke
//
//  Created by 儒房融科 on 15/10/22.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

#import "WXZWoListCell.h"

@implementation WXZWoListCell

- (void)awakeFromNib {
    // Initialization code
}

// 加载nib文件
+ (instancetype)initHeadCell
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

// 设置列表信息（意见反馈/排行榜/百问百答/帮助）
- (void)listInfoWithSection:(NSInteger)section row:(NSInteger)row
{
    // 判断列表属于哪个组，显示不同信息
    if (section == 1)
    {
        // section = 1 ,添加分割线
        if (row < 2)
        {
            UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 54.7, [UIScreen mainScreen].bounds.size.width-12, 0.3)];
            lineLabel.backgroundColor = WXZRGBColor(215, 213, 213);
            [self addSubview:lineLabel];
        }
        
        // 自定义信息
        NSArray *listImgArr = @[@"wo_ feedback",@"wo_paihangbang",@"wo_ask_best _answer"];
        NSArray *listTitleArr = @[@"意见反馈",@"排行榜",@"百问百答"];
        // 赋值
        self.listImgView.image = [UIImage imageNamed:listImgArr[row]];
        self.listTitleLabel.text = listTitleArr[row];
    }
    else
    {
        // section = 2 ,信息显示
        self.listImgView.image = [UIImage imageNamed:@"wo_help"];
        self.listTitleLabel.text = @"帮助";
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
