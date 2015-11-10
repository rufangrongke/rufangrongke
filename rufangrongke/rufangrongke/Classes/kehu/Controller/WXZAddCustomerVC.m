//
//  WXZAddCustomerVC.m
//  rufangrongke
//
//  Created by 儒房融科 on 15/11/4.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

#import "WXZAddCustomerVC.h"
#import "AFNetworking.h"
#import <SVProgressHUD.h>
#import "WXZStringObject.h"
#import "WXZChectObject.h"
#import "WXZBasicInfoCell.h"
#import "WXZPurchaseIntentionCell.h"
#import "WXZPriceCell.h"

@interface WXZAddCustomerVC ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    NSString *quyuSS;
    NSString *huxingSS;
    NSString *fangwuSS;
}

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@property (nonatomic,strong) UIButton *menBtn; //
@property (nonatomic,strong) UIButton *womenBtn; //
//@property (nonatomic,strong) UIButton *quyuTypeBtn; // 

@property (nonatomic,strong) UITextField *nameTextField; // 姓名
@property (nonatomic,strong) UITextField *phoneNumTextField; // 手机号
@property (nonatomic,strong) UITextField *pricefTextField; // 开始价格
@property (nonatomic,strong) UITextField *priceeTextField; // 结束价格

@property (nonatomic,strong) NSArray *quyuListArr; // 区域列表
@property (nonatomic,strong) NSMutableArray *qiWangQuYuArr; // 区域列表
@property (nonatomic,strong) NSMutableArray *qiWangHuXingArr; // 户型列表
@property (nonatomic,strong) NSMutableArray *fangWuTypeArr; // 房屋类型列表

@property (nonatomic,strong) UILabel *yixiangLabel; // 意向信息
@property (nonatomic,strong) NSString *priceStr; // 记录价格

@end

static NSString *sex = @""; // 记录选择的性别，默认为男

@implementation WXZAddCustomerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // 视图整体背景色
    self.view.backgroundColor = WXZRGBColor(246, 246, 246);
    self.navigationItem.title = @"添加客户";
    
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
//    self.nameTextField.delegate = self;
//    self.phoneNumTextField.delegate = self;
//    self.pricefTextField.delegate = self;
//    self.priceeTextField.delegate = self;
    
    sex = @"先生";
    
    [SVProgressHUD showWithStatus:@"请稍后..." maskType:SVProgressHUDMaskTypeBlack];
    [self quyuListRequest]; // 区域列表请求
    
    // 初始化
    self.qiWangQuYuArr = [NSMutableArray array];
    self.qiWangHuXingArr = [NSMutableArray array];
    self.fangWuTypeArr = [NSMutableArray array];
    quyuSS = @"";
    huxingSS = @"";
    fangwuSS = @"";
    _priceStr = @"";
    
    // 注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backPriceInfo:) name:@"BackPriceInfoAndUpdate" object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.qiWangQuYuArr removeAllObjects];
    [self.qiWangHuXingArr removeAllObjects];
    [self.fangWuTypeArr removeAllObjects];
}

#pragma mark - Request
- (void)quyuListRequest
{
    NSString *url = [OutNetBaseURL stringByAppendingString:quyuliebiao];
    [[AFHTTPSessionManager manager] POST:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject)
    {
        if ([responseObject[@"ok"] integerValue] == 1)
        {
            // 赋值
            self.quyuListArr = responseObject[@"qus"];
            [self.myTableView reloadData];
        }
        else
        {
        
        }
        [SVProgressHUD dismiss];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

- (void)addCustomerRequest:(NSString *)name sex:(NSString *)sex mobile:(NSString *)mobile jiaGeS:(NSString *)jiaGeS jiaGeE:(NSString *)jiaGeE quYu:(NSString *)quyu hx:(NSString *)hx yiXiang:(NSString *)yixinag
{
    NSString *url = [OutNetBaseURL stringByAppendingString:kehutianjia];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:name forKey:@"XingMing"];
    [param setObject:sex forKey:@"Sex"];
    [param setObject:mobile forKey:@"Mobile"];
    [param setObject:jiaGeS forKey:@"JiaGeS"];
    [param setObject:jiaGeE forKey:@"JiaGeE"];
    [param setObject:quyu forKey:@"QuYu"];
    [param setObject:hx forKey:@"Hx"];
    [param setObject:yixinag forKey:@"YiXiang"];
    
    [[AFHTTPSessionManager manager] POST:url parameters:param success:^(NSURLSessionDataTask *task, id responseObject)
    {
        WXZLog(@"%@",responseObject);
        if ([responseObject[@"ok"] integerValue] == 1)
        {
            
        }
        else
        {
            
        }
        [SVProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }
    else
    {
        return 4;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        WXZBasicInfoCell *bCell = [tableView dequeueReusableCellWithIdentifier:@"BasicInfoCell"];
        if (!bCell)
        {
            bCell = [WXZBasicInfoCell initBasicInfoCell];
        }
        [bCell.menBtn addTarget:self action:@selector(sexSelectAction:) forControlEvents:UIControlEventTouchUpInside];
        [bCell.womenBtn addTarget:self action:@selector(sexSelectAction:) forControlEvents:UIControlEventTouchUpInside];
        self.menBtn = bCell.menBtn;
        self.womenBtn = bCell.womenBtn;
        [self.menBtn setImage:[UIImage imageNamed:@"kh_nvbzhu"] forState:UIControlStateNormal];
        self.nameTextField = bCell.nameTextField;
        self.phoneNumTextField = bCell.phoneNumTextField;
        
        return bCell;
    }
    else
    {
        if (indexPath.row == 3)
        {
            WXZPriceCell *priceCell = [tableView dequeueReusableCellWithIdentifier:@"PriceCell"];
            if (!priceCell)
            {
                priceCell = [WXZPriceCell initPriceCell];
            }
            
            [priceCell.noLimitBtn addTarget:self action:@selector(selectPriceAction:) forControlEvents:UIControlEventTouchUpInside];
            [priceCell.determineBtn addTarget:self action:@selector(determineAction:) forControlEvents:UIControlEventTouchUpInside];
            self.pricefTextField = priceCell.pricefTextField;
            self.priceeTextField = priceCell.priceeTextField;
            [priceCell updateInfo]; // 
            
            return priceCell;
        }
        else
        {
            WXZPurchaseIntentionCell *pCell = [tableView dequeueReusableCellWithIdentifier:@"PurchaseIntentionCell"];
            if (!pCell)
            {
                pCell = [WXZPurchaseIntentionCell initPurchaseIntentionCell];
            }
            
            [pCell showTypeName:indexPath.row];
            [pCell showTypeData:self.quyuListArr Target:self action:@selector(typeSelectAction:) row:indexPath.row]; // 添加button
            
            return pCell;
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1)
    {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 33)];
        headerView.backgroundColor = WXZRGBColor(246, 246, 246);
        
        self.yixiangLabel = [[UILabel alloc] initWithFrame:CGRectMake(11, 0, headerView.width-11*2, headerView.height)];
        self.yixiangLabel.text = @"购买意向";
        self.yixiangLabel.font = WXZ_SystemFont(15);
        self.yixiangLabel.textColor = WXZRGBColor(140, 139, 139);
        [headerView addSubview:self.yixiangLabel];
        
        return headerView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return 106;
    }
    else
    {
        if (indexPath.row == 0)
        {
            if (self.quyuListArr.count != 0)
            {
                return [self calculateHeightOfRow:self.quyuListArr];
            }
            else
            {
                return 18 + 16;
            }
        }
        else if (indexPath.row == 1)
        {
            NSArray *valueArr = @[@"不限户型",@"一室",@"二室",@"三室",@"四室",@"五室及以上"];
            return [self calculateHeightOfRow:valueArr];
        }
        else if (indexPath.row == 2)
        {
            NSArray *valueArr = @[@"复室",@"住宅",@"别墅",@"商铺"];
            return [self calculateHeightOfRow:valueArr];
        }
        else
        {
            return 257;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1)
    {
        return 33;
    }
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

// 计算行高
- (NSInteger)calculateHeightOfRow:(NSArray *)arr
{
    NSInteger limit = 0;
    if ([UIScreen mainScreen].bounds.size.width == 320)
    {
        limit = 4;
    }
    else
    {
        limit = 5;
    }
    
    NSInteger count = [arr count];
    NSInteger remainder = count % limit; // 余数
    
    NSInteger row = 0;
    if (remainder == 0)
    {
        row = count / limit; // 行数
    }
    else
    {
        row = count / limit + 1; // 行数
    }
    return row * 19 + (row - 1) * 10 + 18 + 16; // 返回行高
}

- (void)sexSelectAction:(UIButton *)sender
{
    if (sender.tag == 100018)
    {
        [self.menBtn setImage:[UIImage imageNamed:@"kh_nvbzhu"] forState:UIControlStateNormal];
        [self.womenBtn setImage:[UIImage imageNamed:@"kh_nanzhu"] forState:UIControlStateNormal];
        sex = @"先生";
    }
    else
    {
        [self.womenBtn setImage:[UIImage imageNamed:@"kh_nvbzhu"] forState:UIControlStateNormal];
        [self.menBtn setImage:[UIImage imageNamed:@"kh_nanzhu"] forState:UIControlStateNormal];
        sex = @"女士";
    }
    NSLog(@"%@",sex);
}

- (void)typeSelectAction:(UIButton *)sender
{
    NSString *str = [NSString stringWithFormat:@"%ld",(long)sender.tag];
    str = [str substringWithRange:NSMakeRange(0, str.length-1)];
    if ([str isEqualToString:@"100003"])
    {
        NSLog(@"%ld",(long)sender.tag);
        if ([sender.backgroundColor isEqual:[UIColor lightGrayColor]])
        {
            sender.backgroundColor = WXZRGBColor(2, 135, 227);
            [sender setTitleColor:WXZRGBColor(255, 255, 255) forState:UIControlStateNormal];
            [self.qiWangQuYuArr addObject:sender.titleLabel.text];
        }
        else
        {
            sender.backgroundColor = [UIColor lightGrayColor];
            [sender setTitleColor:WXZRGBColor(27, 28, 27) forState:UIControlStateNormal];
            [self.qiWangQuYuArr removeObject:sender.titleLabel.text];
        }
    }
    else if ([str isEqualToString:@"100004"])
    {
        NSLog(@"%ld",(long)sender.tag);
        if (sender.tag == 1000040 && [sender.backgroundColor isEqual:WXZRGBColor(2, 135, 227)])
        {
            if (sender.tag == 1000040)
            {
                if ([sender.backgroundColor isEqual:[UIColor lightGrayColor]])
                {
                    sender.backgroundColor = WXZRGBColor(2, 135, 227);
                    [sender setTitleColor:WXZRGBColor(255, 255, 255) forState:UIControlStateNormal];
                    [self.qiWangHuXingArr addObject:sender.titleLabel.text];
                }
                else
                {
                    sender.backgroundColor = [UIColor lightGrayColor];
                    [sender setTitleColor:WXZRGBColor(27, 28, 27) forState:UIControlStateNormal];
                    [self.qiWangHuXingArr removeObject:sender.titleLabel.text];
                }
            }
            else
            {
                sender.backgroundColor = [UIColor lightGrayColor];
                [sender setTitleColor:WXZRGBColor(27, 28, 27) forState:UIControlStateNormal];
                [self.qiWangHuXingArr removeObject:sender.titleLabel.text];
            }
        }
        if ([sender.backgroundColor isEqual:[UIColor lightGrayColor]])
        {
            sender.backgroundColor = WXZRGBColor(2, 135, 227);
            [sender setTitleColor:WXZRGBColor(255, 255, 255) forState:UIControlStateNormal];
            [self.qiWangHuXingArr addObject:sender.titleLabel.text];
        }
        else
        {
            sender.backgroundColor = [UIColor lightGrayColor];
            [sender setTitleColor:WXZRGBColor(27, 28, 27) forState:UIControlStateNormal];
            [self.qiWangHuXingArr removeObject:sender.titleLabel.text];
        }
    }
    else
    {
        NSLog(@"%ld",(long)sender.tag);
        if ([sender.backgroundColor isEqual:[UIColor lightGrayColor]])
        {
            sender.backgroundColor = WXZRGBColor(2, 135, 227);
            [sender setTitleColor:WXZRGBColor(255, 255, 255) forState:UIControlStateNormal];
            [self.fangWuTypeArr addObject:sender.titleLabel.text];
        }
        else
        {
            sender.backgroundColor = [UIColor lightGrayColor];
            [sender setTitleColor:WXZRGBColor(27, 28, 27) forState:UIControlStateNormal];
            [self.fangWuTypeArr removeObject:sender.titleLabel.text];
        }
    }
    
    [self showHeaderInfo]; // 展示header信息
}

- (void)selectPriceAction:(UIButton *)sender
{
    NSLog(@"不限");
    if ([sender.backgroundColor isEqual:[UIColor lightGrayColor]])
    {
        sender.backgroundColor = WXZRGBColor(2, 135, 227);
        [sender setTitleColor:WXZRGBColor(255, 255, 255) forState:UIControlStateNormal];
        _priceStr = @"";
    }
    else
    {
        sender.backgroundColor = [UIColor lightGrayColor];
        [sender setTitleColor:WXZRGBColor(27, 28, 27) forState:UIControlStateNormal];
    }
    [self showHeaderInfo]; // 展示header信息
}

- (void)determineAction:(id)sender
{
    NSLog(@"%@ - %@",self.pricefTextField.text,self.priceeTextField.text);
    
    [SVProgressHUD showWithStatus:@"正在提交..." maskType:SVProgressHUDMaskTypeBlack];
    [self addCustomerRequest:self.nameTextField.text sex:sex mobile:self.phoneNumTextField.text jiaGeS:self.pricefTextField.text jiaGeE:self.priceeTextField.text quYu:[WXZStringObject whetherStringContainsCharacter2:[self quyuMethod] character:@","] hx:[WXZStringObject whetherStringContainsCharacter2:[self huxingMethod] character:@","] yiXiang:self.yixiangLabel.text];
}

// 展示header信息
- (void)showHeaderInfo
{
    if ([WXZChectObject checkWhetherStringIsEmpty:[self quyuMethod]] && [WXZChectObject checkWhetherStringIsEmpty:[self huxingMethod]] && [WXZChectObject checkWhetherStringIsEmpty:[self yixiangMethod]])
    {
        self.yixiangLabel.text = @"购买意向";
    }
    else
    {
        self.yixiangLabel.text = [[self quyuMethod] stringByAppendingString:[self huxingMethod]];
        self.yixiangLabel.text = [self.yixiangLabel.text stringByAppendingString:[self yixiangMethod]];
        self.yixiangLabel.text = [WXZStringObject whetherStringContainsCharacter2:self.yixiangLabel.text character:@","];
    }
}

- (NSString *)quyuMethod
{
    return [WXZStringObject pinJieString1:self.qiWangQuYuArr];
}

- (NSString *)huxingMethod
{
    NSString *huxingStr = [WXZStringObject pinJieString1:self.qiWangHuXingArr];
    NSString *fangwuStr = [WXZStringObject pinJieString1:self.fangWuTypeArr];
    NSString *allStr = @"";
    if (![WXZChectObject checkWhetherStringIsEmpty:fangwuStr] && ![WXZChectObject checkWhetherStringIsEmpty:huxingStr])
    {
        allStr = [WXZStringObject replacementString:huxingStr replace:@"," replaced:@"/"];
        allStr = [allStr stringByAppendingString:fangwuStr];
    }
    else if ([WXZChectObject checkWhetherStringIsEmpty:fangwuStr] && ![WXZChectObject checkWhetherStringIsEmpty:huxingStr])
    {
        allStr = huxingStr;
    }
    else if (![WXZChectObject checkWhetherStringIsEmpty:fangwuStr] && [WXZChectObject checkWhetherStringIsEmpty:huxingStr])
    {
        allStr = fangwuStr;
    }
    else
    {
        allStr = @"";
    }
    return allStr;
}

- (NSString *)yixiangMethod
{
    if (![WXZChectObject checkWhetherStringIsEmpty:self.pricefTextField.text] || ![WXZChectObject checkWhetherStringIsEmpty:self.priceeTextField.text])
    {
        _priceStr = [NSString stringWithFormat:@"%@-%@万",self.pricefTextField.text,self.priceeTextField.text];
    }
    else
    {
        _priceStr = @"";
    }
    return _priceStr;
}
// 通知事件
- (void)backPriceInfo:(NSNotification *)notification
{
    [self showHeaderInfo]; // 展示header信息
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self showHeaderInfo]; // 展示header信息
    
    [self.nameTextField resignFirstResponder];
    [self.phoneNumTextField resignFirstResponder];
    [self.pricefTextField resignFirstResponder];
    [self.priceeTextField resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end