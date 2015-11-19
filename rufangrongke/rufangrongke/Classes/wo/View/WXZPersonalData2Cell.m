//
//  WXZPersonalData2Cell.m
//  rufangrongke
//
//  Created by 儒房融科 on 15/10/24.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

#import "WXZPersonalData2Cell.h"
#import "WXZDateObject.h"
#import "WXZStringObject.h"
#import "WXZChectObject.h"

@implementation WXZPersonalData2Cell

- (void)awakeFromNib {
    // Initialization code
}

// 加载nib文件
+ (instancetype)initPersonalData2Cell
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

// 初始化信息
- (void)personalDataInfo:(NSInteger)row
{
    NSArray *titleArr = @[@"真实姓名",@"性别",@"从业时间",@"服务宣言",@"实名认证",@"所在城市",@"修改绑定门店",@"修改绑定手机",@"修改密码"];
    
    self.titleLabel.text = titleArr[row-1]; // 设置标题
    
    // 添加分割线
    if (row <10)
    {
        UIImageView *lineImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 54, WXZ_ScreenWidth-20, 1)];
        lineImgView.image = [UIImage imageNamed:@"wo_personaldata_divider"];
        [self.contentView addSubview:lineImgView];
    }
}

// 刷新数据
- (void)updatePersonalDataInfo:(NSInteger)row data:(WXZWoInfoModel *)personalInfoModel
{
    NSArray *tipArr = @[@"录入真实姓名",@"选择性别",@"添加年限",@"编辑服务宣言",@"未认证",@"设置城市",@"绑定门店",@"绑定手机",@""]; // 提示信息
    
    NSString *tipStr = @"";
    switch (row)
    {
        case 1:
            tipStr = personalInfoModel.TrueName; // 原真实姓名
            break;
        case 2:
            tipStr = personalInfoModel.Sex; // 原用户性别
            break;
        case 3:
        {
            // 时间的转换
            NSString *time = personalInfoModel.CongYeTime;
            time = [WXZStringObject replacementString:time replace:@"/" replaced:@"-"];
            NSDate *date = [WXZDateObject formatDate1:time dateFormat:@"yyyy-MM-dd HH:mm:ss"];
            tipStr = [WXZDateObject formatDate2:date dateFormat:@"yyyy-MM"]; // 原从业时间
        }
            break;
        case 4:
            tipStr = personalInfoModel.XuanYan; // 原服务宣言
            break;
        case 5:
            tipStr = personalInfoModel.IsShiMing; // 原是否实名
            break;
        case 6:
            tipStr = personalInfoModel.cityName; // 原城市名称
            break;
        case 7:
            tipStr = personalInfoModel.LtName; // 原绑定门店名称
            break;
        case 8:
            tipStr = personalInfoModel.Mobile; // 原手机号
            break;
            
        default:
            break;
    }
    
    self.tipLabel.hidden = NO;
    self.certificationLabel.hidden = YES;
    self.certificationImgView.hidden = YES;
    
    self.tipLabel.text = tipStr;
    // 判断是否有原数据，没有则显示默认提示信息
    if ([tipStr isEqualToString:@""] || tipStr == nil)
    {
        self.tipLabel.text = tipArr[row-1];
    }
    
    if (row == 5)
    {
        self.tipLabel.hidden = YES;
        self.certificationImgView.hidden = NO;
        self.certificationLabel.hidden = NO;
        // 判断是否已认证；若没有认证并有身份证号，则显示审核中；否则未认证
        if ([tipStr isEqualToString:@"True"])
        {
            self.certificationImgView.image = [UIImage imageNamed:@"wo_personaldata_certified"];
            self.certificationLabel.text = @"已认证";
        }
        else if ([tipStr isEqualToString:@"False"] && ![WXZChectObject checkWhetherStringIsEmpty:personalInfoModel.sfzid])
        {
            self.certificationImgView.image = [UIImage imageNamed:@"wo_personaldata_certification"];
            self.certificationLabel.text = @"审核中";
        }
        else
        {
            self.certificationImgView.image = [UIImage imageNamed:@"wo_personaldata_certification"];
            self.certificationLabel.text = tipArr[row-1];
        }
    }
}

// 添加退出登录按钮点击事件
- (void)buttonWithTarget:(id)target action:(SEL)action
{
    self.titleLabel.hidden = YES;
    self.tipLabel.hidden = YES;
    self.certificationLabel.hidden = YES;
    self.certificationImgView.hidden = YES;
    // 初始化button
    UIButton *logOutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    logOutBtn.frame = CGRectMake(10, 8, WXZ_ScreenWidth-20, 39);
    [logOutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [logOutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    logOutBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica-Blod" size:14];
    logOutBtn.layer.cornerRadius = 5;
    logOutBtn.layer.masksToBounds = YES;
    [logOutBtn setBackgroundColor:WXZRGBColor(20, 138, 225)];
    [logOutBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:logOutBtn];
    
    self.accessoryType = UITableViewCellAccessoryNone; // 不显示cell系统的左侧箭头
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
