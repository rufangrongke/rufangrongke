//
//  WXZPersonalData2Cell.m
//  rufangrongke
//
//  Created by 儒房融科 on 15/10/24.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

#import "WXZPersonalData2Cell.h"

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
- (void)personalDataInfo:(NSInteger)row;
{
    NSArray *titleArr = @[@"",@"真实姓名",@"性别",@"从业时间",@"服务宣言",@"实名认证",@"所在城市",@"修改绑定门店",@"修改绑定手机",@"修改密码"];
    NSArray *tipArr = @[@"",@"",@"",@"添加年限",@"编辑服务宣言",@"未认证",@"",@"绑定门店",@"",@""];
    
    self.titleLabel.hidden = NO;
    self.tipLabel.hidden = YES;
    self.certificationLabel.hidden = YES;
    self.certificationImgView.hidden = YES;
    self.titleLabel.text = titleArr[row];
    if (row == 3 || row == 4 || row == 7)
    {
        self.tipLabel.hidden = NO;
        self.tipLabel.text = tipArr[row];
    }
    else if (row == 5)
    {
        self.certificationImgView.hidden = NO;
        self.certificationLabel.hidden = NO;
        self.certificationLabel.text = tipArr[row];
    }
    
    // 添加分割线
    if (row <10)
    {
        UIImageView *lineImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 54, WXZ_ScreenWidth-20, 1)];
        lineImgView.image = [UIImage imageNamed:@"wo_personaldata_ divider"];
        [self.contentView addSubview:lineImgView];
    }
}

- (void)buttonWithTarget:(id)target action:(SEL)action
{
    self.titleLabel.hidden = YES;
    self.tipLabel.hidden = YES;
    self.certificationLabel.hidden = YES;
    self.certificationImgView.hidden = YES;
    
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
    
    self.accessoryType = UITableViewCellAccessoryNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
