//
//  WXZPurchaseIntentionCell.m
//  rufangrongke
//
//  Created by 儒房融科 on 15/11/4.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

#import "WXZPurchaseIntentionCell.h"

@interface WXZPurchaseIntentionCell ()

@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *lineImgView;

@property (nonatomic,strong) UIButton *typeBtn; //

@end

@implementation WXZPurchaseIntentionCell

- (void)awakeFromNib {
    // Initialization code
}

+ (instancetype)initPurchaseIntentionCell
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

- (void)showTypeName:(NSInteger)row
{
    NSArray *typeNameArr = @[@"期望区域：",@"期望户型：",@"房屋类型："];
    self.typeLabel.text = typeNameArr[row];
    
    if (row != 0)
    {
        self.lineImgView.hidden = YES;
    }
}

- (void)showTypeData:(NSArray *)typeArr Target:(id)target action:(SEL)action row:(NSInteger)row
{
    NSMutableArray *houseArr = [NSMutableArray array];
    NSInteger btnTag = 0;
    [houseArr removeAllObjects];
    if (row == 0)
    {
//        [houseArr removeAllObjects];
        [houseArr addObjectsFromArray:typeArr];
        btnTag = 1000030;
    }
    else if (row == 1)
    {
//        [houseArr removeAllObjects];
//        NSArray *keyArr = @[@"nolimit",@"oneh",@"twoh",@"threeh",@"fourh",@"moreh"];
        NSArray *valueArr = @[@"不限户型",@"一室",@"二室",@"三室",@"四室",@"五室及以上"];
        for (int i = 0; i < typeArr.count; i++)
        {
            NSMutableDictionary *doorModelDic = [NSMutableDictionary dictionary];
            [doorModelDic setObject:valueArr[i] forKey:@"q"];
            [houseArr addObject:doorModelDic];
        }
        btnTag = 1000040;
    }
    else if (row == 2)
    {
//        [houseArr removeAllObjects];
//        NSArray *keyArr = @[@"multicellular",@"residential",@"villa",@"shops"];
        NSArray *valueArr = @[@"复室",@"住宅",@"别墅",@"商铺"];
        for (int i = 0; i < typeArr.count; i++)
        {
            NSMutableDictionary *houseTypeDic = [NSMutableDictionary dictionary];
            [houseTypeDic setObject:valueArr[i] forKey:@"q"];
            [houseArr addObject:houseTypeDic];
        }
        btnTag = 1000050;
    }
    
    NSInteger limit = 0; // 每行显示的个数
    NSInteger spacing = 0; // 间距
    if ([UIScreen mainScreen].bounds.size.width == 320)
    {
        limit = 4; // 每行显示的个数
        spacing = 33; // 间距
    }
    else
    {
        limit = 5; // 每行显示的个数
        spacing = 25; // 间距
    }
    NSInteger count = houseArr.count % limit; // 取余数
    NSInteger hang = 1; // 行数
    NSInteger lie = 1; // 列数
    // 计算行数和列数
    if (count != 0)
    {
        if (houseArr.count < limit)
        {
            hang = 1;
            lie = houseArr.count;
        }
        else
        {
            hang = houseArr.count / limit + 1;
            lie = limit;
        }
    }
    else
    {
        hang = houseArr.count / limit;
        lie = limit;
    }
    
    for (int i = 0; i < hang; i++)
    {
        // 计算最后一行应该显示几列
        if (houseArr.count > limit && houseArr.count % limit != 0 && i == hang-1)
        {
            lie = houseArr.count % limit;
        }
        // 显示button
        for (int j =0 ; j < lie; j++)
        {
            self.typeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            self.typeBtn.frame = CGRectMake(11+spacing*j+50*j, self.typeLabel.x+self.typeLabel.height+10+10*i+19*i, 50, 19);
            self.typeBtn.tag = btnTag + (i*limit+j); // 设置tag值
            [self.typeBtn setTitle:houseArr[i*limit+j][@"q"] forState:UIControlStateNormal];
            [self.typeBtn setTitleColor:WXZRGBColor(27, 28, 27) forState:UIControlStateNormal];
            self.typeBtn.titleLabel.font = WXZ_SystemFont(10);
            self.typeBtn.backgroundColor = [UIColor lightGrayColor];
            [self.typeBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:self.typeBtn];
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
