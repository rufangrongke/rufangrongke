//
//  WXZPurchaseIntentionCell.m
//  rufangrongke
//
//  Created by 儒房融科 on 15/11/4.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

#import "WXZPurchaseIntentionCell.h"
#import "WXZStringObject.h"

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

- (void)showTypeData:(NSArray *)typeArr Target:(id)target action:(SEL)action row:(NSInteger)row  isModify:(BOOL)ismodify yuanData:(WXZKeHuDetailModel *)model
{
    NSMutableArray *houseArr = [NSMutableArray array];
    NSInteger btnTag = 0;
    [houseArr removeAllObjects];
    if (row == 0)
    {
        [houseArr addObjectsFromArray:typeArr];
        btnTag = 1000030;
    }
    else if (row == 1)
    {
        for (int i = 0; i < typeArr.count; i++)
        {
            NSMutableDictionary *doorModelDic = [NSMutableDictionary dictionary];
            [doorModelDic setObject:typeArr[i] forKey:@"q"];
            [houseArr addObject:doorModelDic];
        }
        btnTag = 1000040;
    }
    else if (row == 2)
    {
        for (int i = 0; i < typeArr.count; i++)
        {
            NSMutableDictionary *houseTypeDic = [NSMutableDictionary dictionary];
            [houseTypeDic setObject:typeArr[i] forKey:@"q"];
            [houseArr addObject:houseTypeDic];
        }
        btnTag = 1000050;
    }
    
    NSInteger limit = 0; // 每行显示的个数
    NSInteger spacing = 0; // 间距
    if ([UIScreen mainScreen].bounds.size.width == 320)
    {
        limit = 4; // 每行显示的个数
        spacing = 23; // 间距
    }
    else if (WXZ_ScreenWidth == 414)
    {
        limit = 5; // 每行显示的个数
        spacing = 26.5; // 间距
    }
    else
    {
        limit = 5; // 每行显示的个数
        spacing = 17; // 间距
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
            self.typeBtn.frame = CGRectMake(11+spacing*j+55*j, self.typeLabel.x+self.typeLabel.height+15+10*i+19*i, 65, 22);
            self.typeBtn.tag = btnTag + (i*limit+j); // 设置tag值
            [self.typeBtn setTitle:houseArr[i*limit+j][@"q"] forState:UIControlStateNormal];
            [self.typeBtn setTitleColor:WXZRGBColor(27, 28, 27) forState:UIControlStateNormal];
            self.typeBtn.titleLabel.font = WXZ_SystemFont(12);
            [self.typeBtn setBackgroundImage:[UIImage imageNamed:@"kh_quyuunselect"] forState:UIControlStateNormal];
            [self.typeBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:self.typeBtn];
            // 是否是修改页
            if (ismodify)
            {
                // 判断名称是否相等
                if ([self areEqual:houseArr[i*limit+j][@"q"] localData:model row:row])
                {
                    [self.typeBtn setBackgroundImage:[UIImage imageNamed:@"kh_quyuselected"] forState:UIControlStateNormal];
                    [self.typeBtn setTitleColor:WXZRGBColor(255, 255, 255) forState:UIControlStateNormal];
                }
            }
        }
    }
}

// 判断两个字符串是否相等
- (BOOL)areEqual:(NSString *)nowTitle localData:(WXZKeHuDetailModel *)model row:(NSInteger)row
{
//    WXZLog(@"%@",model);
    NSString *huoquStr = @"";
    if (row == 0)
    {
        huoquStr = model.QuYu;
    }
    else if (row == 1 || row == 2)
    {
        huoquStr = model.Hx;
    }
    NSArray *relationArr = [WXZStringObject interceptionOfString:huoquStr interceptType:@"/"];
    
    for (NSString *subStr in relationArr)
    {
        if ([subStr isEqualToString:nowTitle])
        {
            return YES;
        }
    }
    return NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
