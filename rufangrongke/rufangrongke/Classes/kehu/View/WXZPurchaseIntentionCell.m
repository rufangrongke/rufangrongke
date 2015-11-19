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

@property (weak, nonatomic) IBOutlet UILabel *typeLabel; // 期望类型信息
@property (weak, nonatomic) IBOutlet UIImageView *lineImgView; // 下划线

@property (nonatomic,strong) UIButton *typeBtn; // 类型btn

@end

@implementation WXZPurchaseIntentionCell

- (void)awakeFromNib {
    // Initialization code
}

// 加载nib文件
+ (instancetype)initPurchaseIntentionCell
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

// 展示期望区域、户型、房型title信息
- (void)showTypeName:(NSInteger)row
{
    NSArray *typeNameArr = @[@"期望区域：",@"期望户型：",@"房屋类型："];
    self.typeLabel.text = typeNameArr[row];
    
    if (row != 0)
    {
        self.lineImgView.hidden = YES;
    }
}

// 初始化期望区域、户型、房型信息按钮
- (void)showTypeData:(NSArray *)typeArr Target:(id)target action:(SEL)action row:(NSInteger)row withQuYuArr:(NSMutableArray *)quyuAr1 withHxArr:(NSMutableArray *)hxAr2 withFwArr:(NSMutableArray *)fwAr3  isModify:(BOOL)ismodify yuanData:(WXZKeHuDetailModel *)model
{
    NSMutableArray *houseArr = [NSMutableArray array]; // 存储初始数据的数组
    NSInteger btnTag = 0; // 按钮tag值
    [houseArr removeAllObjects];
    if (row == 0)
    {
        [houseArr addObjectsFromArray:typeArr]; // 初始化区域数据（网络获取）
        btnTag = 1000030;
    }
    else if (row == 1)
    {
        // 初始化户型数据（本地获取）
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
        // 初始化房型数据（本地获取）
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
            else
            {
                NSArray *array = @[];
                if (row == 0)
                {
                    array = quyuAr1; // 本地存储的区域数据（用户选中的）
                }
                else if (row == 1)
                {
                    array = hxAr2; // 本地存储的户型数据（用户选中的）
                }
                else
                {
                    array = fwAr3; // 本地存储的房型数据（用户选中的）
                }
                // 判断名称是否相等
                if ([self areEqual2:houseArr[i*limit+j][@"q"] localData:array row:row])
                {
                    [self.typeBtn setBackgroundImage:[UIImage imageNamed:@"kh_quyuselected"] forState:UIControlStateNormal];
                    [self.typeBtn setTitleColor:WXZRGBColor(255, 255, 255) forState:UIControlStateNormal];
                }
            }
        }
    }
}

// 判断两个字符串是否相等（初始数据和详情页传过来的数据比较）
- (BOOL)areEqual:(NSString *)nowTitle localData:(WXZKeHuDetailModel *)model row:(NSInteger)row
{
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

// 判断两个字符串是否相等2（初始数据和本地数组中数据比较）
- (BOOL)areEqual2:(NSString *)nowTitle localData:(NSArray *)model row:(NSInteger)row
{
    NSArray *relationArr = model;
    
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
