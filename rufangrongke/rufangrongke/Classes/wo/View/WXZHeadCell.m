//
//  WXZHeadCell.m
//  rufangrongke
//
//  Created by 儒房融科 on 15/10/22.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

#import "WXZHeadCell.h"

@implementation WXZHeadCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self initBasedControl];
    }
    return self;
}

// 初始化基础控件
- (void)initBasedControl
{
    CGSize size = [self calculateTheSizeOfThePicture:@"wo_headbg"];
    UIImageView *backHeadImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    backHeadImgView.image = [UIImage imageNamed:@"wo_headbg"];
    [self.contentView addSubview:backHeadImgView];
    
    UIImageView *headImgView = [[UIImageView alloc] initWithFrame:CGRectMake((backHeadImgView.width-123)/2, backHeadImgView.y+37, 122, 122)];
    headImgView.image = [UIImage imageNamed:@"wo_head"];
    headImgView.backgroundColor = [UIColor redColor];
    headImgView.layer.cornerRadius = 60;
    headImgView.layer.masksToBounds = YES;
    headImgView.layer.borderColor = WXZRGBColor(27, 28, 27).CGColor;
    headImgView.layer.borderWidth = 5;
    [self.contentView addSubview:headImgView];
}

//计算图片的大小
-(CGSize)calculateTheSizeOfThePicture:(NSString *)imgName
{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    UIImage *img = [UIImage imageNamed:imgName];//获取图片
    CGSize imgSize = img.size;//获取图片的size值
    CGFloat imgWidth = imgSize.width;//取图片的宽
    CGFloat imgHight = imgSize.height;//取图片的高
    CGFloat scale = imgWidth/screenWidth;//通过图片的宽和屏幕的款（屏幕高/图片高），计算系数
    
    //定义变量，用来存储新的size
    CGSize newSize;
    //如果求出来的系数大于1，则宽高计算如下；否则宽高仍旧
    if (scale > 1)
    {
        newSize.width = screenWidth;//新宽，宽等于屏幕的宽
        newSize.height = imgHight/scale;//新高，高等于图片的高 ÷ 系数
    }
    else
    {
//        newSize.width = imgWidth;//旧宽，图片本身的宽
//        newSize.height = imgHight;//旧高，图片本身的高
        newSize.width = screenWidth;
        newSize.height = 249;
    }
    
    //返回图片的size值
    return newSize;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
