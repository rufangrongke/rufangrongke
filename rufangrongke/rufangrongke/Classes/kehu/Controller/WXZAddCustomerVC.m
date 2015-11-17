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
#import <MJExtension.h>

@interface WXZAddCustomerVC () <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
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
@property (nonatomic,strong) NSArray *huxingListArr; // 户型列表
@property (nonatomic,strong) NSArray *fangwuListArr; // 房屋类型列表
@property (nonatomic,strong) NSMutableArray *qiWangQuYuArr; // 区域意向
@property (nonatomic,strong) NSMutableArray *qiWangHuXingArr; // 户型意向
@property (nonatomic,strong) NSMutableArray *fangWuTypeArr; // 房屋类型意向

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
    self.navigationItem.title = self.titleStr;
    
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    [self quyuListRequest]; // 区域列表请求
    
    // 初始化
    sex = @"先生";
    self.huxingListArr = @[@"不限户型",@"一室",@"二室",@"三室",@"四室",@"五室及以上"];
    self.fangwuListArr = @[@"复室",@"住宅",@"别墅",@"商铺"];
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

- (void)viewDidAppear:(BOOL)animated
{
    [self showHeaderInfo]; // 显示购房意向
    [self.myTableView reloadData];
}

#pragma mark - Request
// 区域列表数据请求
- (void)quyuListRequest
{
    NSString *url = [OutNetBaseURL stringByAppendingString:quyuliebiao];
    [[AFHTTPSessionManager manager] POST:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject)
    {
        if ([responseObject[@"ok"] integerValue] == 1)
        {
//            WXZLog(@"%@",responseObject);
            // 赋值
            self.quyuListArr = responseObject[@"qus"];
            [self showTheOriginalInfo]; // 重新构造购房意向信息
            [self.myTableView reloadData];
            [SVProgressHUD dismiss];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:responseObject[@"msg"]];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"请求失败"];
    }];
}

// 添加客户或修改购房意向
- (void)addCustomerRequest:(NSString *)kehuId name:(NSString *)name sex:(NSString *)sex mobile:(NSString *)mobile jiaGeS:(NSString *)jiaGeS jiaGeE:(NSString *)jiaGeE quYu:(NSString *)quyu hx:(NSString *)hx yiXiang:(NSString *)yixinag isModify:(BOOL)isModify
{
    NSString *url = [OutNetBaseURL stringByAppendingString:kehutianjia];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (isModify)
    {
        url = [OutNetBaseURL stringByAppendingString:kehuxiugai];
        [param setObject:kehuId forKey:@"id"];
    }
    [param setObject:name forKey:@"XingMing"];
    [param setObject:sex forKey:@"Sex"];
    [param setObject:mobile forKey:@"Mobile"];
    [param setObject:jiaGeS forKey:@"JiaGeS"];
    [param setObject:jiaGeE forKey:@"JiaGeE"];
    [param setObject:quyu forKey:@"QuYu"];
    [param setObject:hx forKey:@"Hx"];
    [param setObject:yixinag forKey:@"YiXiang"];
//    WXZLog(@"add param = %@",param);
    [[AFHTTPSessionManager manager] POST:url parameters:param success:^(NSURLSessionDataTask *task, id responseObject)
    {
        if ([responseObject[@"ok"] integerValue] == 1)
        {
            if (self.isKeHuDetail)
                [self.updateDelegate updateKeHuDetailInfo:self.detailModel.ID]; // 调用刷新客户详情页代理方法
            else
                [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateKeHuInfoNotification" object:nil]; // 发送通知刷新客户首页方法
            
            [SVProgressHUD dismiss];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:responseObject[@"msg"]];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"请求失败"];
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
        self.nameTextField = bCell.nameTextField;
        self.phoneNumTextField = bCell.phoneNumTextField;
        // 修改传过来的信息，展示
        [bCell modifyInfo:self.detailModel isModify:self.isModifyCustomerInfo];
        
        return bCell;
    }
    else
    {
        if (indexPath.row == 3)
        {
            WXZPriceCell *priceCell;
            for (UIView *subView in priceCell.subviews)
            {
                [subView removeFromSuperview];
            }
//            WXZPriceCell *priceCell = [tableView dequeueReusableCellWithIdentifier:@"PriceCell"];
//            if (!priceCell)
//            {
                priceCell = [WXZPriceCell initPriceCell];
//            }
            
            [priceCell.noLimitBtn addTarget:self action:@selector(selectPriceAction:) forControlEvents:UIControlEventTouchUpInside];
            [priceCell.determineBtn addTarget:self action:@selector(determineAction:) forControlEvents:UIControlEventTouchUpInside];
            self.pricefTextField = priceCell.pricefTextField;
            self.priceeTextField = priceCell.priceeTextField;
            priceCell.controller = self;
            [priceCell updateInfo:self.detailModel isModify:self.isModifyCustomerInfo]; //
            
            return priceCell;
        }
        else
        {
            WXZPurchaseIntentionCell *pCell;
            for (UIView *subView in pCell.subviews)
            {
                [subView removeFromSuperview];
            }
            
//            WXZPurchaseIntentionCell *pCell = [tableView dequeueReusableCellWithIdentifier:@"PurchaseIntentionCell"];
//            if (!pCell)
//            {
                pCell = [WXZPurchaseIntentionCell initPurchaseIntentionCell];
//            }
            
            [pCell showTypeName:indexPath.row];
            if (indexPath.row == 0)
            {
                [pCell showTypeData:self.quyuListArr Target:self action:@selector(typeSelectAction:) row:indexPath.row isModify:self.isModifyCustomerInfo yuanData:self.detailModel]; // 添加button
            }
            else if (indexPath.row == 1)
            {
                [pCell showTypeData:self.huxingListArr Target:self action:@selector(typeSelectAction:) row:indexPath.row isModify:self.isModifyCustomerInfo yuanData:self.detailModel]; // 添加button
            }
            else
            {
                [pCell showTypeData:self.fangwuListArr Target:self action:@selector(typeSelectAction:) row:indexPath.row isModify:self.isModifyCustomerInfo yuanData:self.detailModel]; // 添加button
            }
            
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
        self.yixiangLabel.font = WXZ_SystemFont(15);
        self.yixiangLabel.textColor = WXZRGBColor(140, 139, 139);
        [headerView addSubview:self.yixiangLabel];
        
        if (self.isModifyCustomerInfo && (![WXZChectObject checkWhetherStringIsEmpty:[NSString stringWithFormat:@"%@",self.detailModel.QuYu]] || ![WXZChectObject checkWhetherStringIsEmpty:[NSString stringWithFormat:@"%@",self.detailModel.Hx]] || ![WXZChectObject checkWhetherStringIsEmpty:[NSString stringWithFormat:@"%@",self.detailModel.JiaGeS]] || ![WXZChectObject checkWhetherStringIsEmpty:[NSString stringWithFormat:@"%@",self.detailModel.JiaGeE]]))
            [self showHeaderInfo]; // 展示已有购房意向
        else
            self.yixiangLabel.text = @"购房意向";
            
        return headerView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return 80;
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
            return [self calculateHeightOfRow:self.huxingListArr];
        }
        else if (indexPath.row == 2)
        {
            return [self calculateHeightOfRow:self.fangwuListArr];
        }
        else
        {
            return 259;
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

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.nameTextField resignFirstResponder];
    [self.phoneNumTextField resignFirstResponder];
    [self.pricefTextField resignFirstResponder];
    [self.priceeTextField resignFirstResponder];
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
    NSInteger sumHeight = row * 22 + (row - 1) * 15 + 18 + 18 + 10; // (控件高度＋控件之间的间距＋标题的高＋标题距上边的高)
    
    return sumHeight; // 返回行高
}

- (void)sexSelectAction:(UIButton *)sender
{
    [self.nameTextField resignFirstResponder];
    [self.phoneNumTextField resignFirstResponder];
    [self.pricefTextField resignFirstResponder];
    [self.priceeTextField resignFirstResponder];
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
}

- (void)typeSelectAction:(UIButton *)sender
{
    [self.nameTextField resignFirstResponder];
    [self.phoneNumTextField resignFirstResponder];
    [self.pricefTextField resignFirstResponder];
    [self.priceeTextField resignFirstResponder];
    NSString *str = [NSString stringWithFormat:@"%ld",(long)sender.tag];
    str = [str substringWithRange:NSMakeRange(0, str.length-1)];
    if ([str isEqualToString:@"100003"])
    {
        if ([sender.currentBackgroundImage isEqual:[UIImage imageNamed:@"kh_quyuunselect"]])
        {
            [sender setBackgroundImage:[UIImage imageNamed:@"kh_quyuselected"] forState:UIControlStateNormal];
            [sender setTitleColor:WXZRGBColor(255, 255, 255) forState:UIControlStateNormal];
            [self.qiWangQuYuArr addObject:sender.titleLabel.text];
        }
        else
        {
            [sender setBackgroundImage:[UIImage imageNamed:@"kh_quyuunselect"] forState:UIControlStateNormal];
            [sender setTitleColor:WXZRGBColor(27, 28, 27) forState:UIControlStateNormal];
            [self.qiWangQuYuArr removeObject:sender.titleLabel.text];
        }
    }
    else if ([str isEqualToString:@"100004"])
    {
        if (sender.tag == 1000040)
        {
            if ([sender.currentBackgroundImage isEqual:[UIImage imageNamed:@"kh_quyuunselect"]])
            {
                [sender setBackgroundImage:[UIImage imageNamed:@"kh_quyuselected"] forState:UIControlStateNormal];
                [sender setTitleColor:WXZRGBColor(255, 255, 255) forState:UIControlStateNormal];
                [self.qiWangHuXingArr removeAllObjects];
                [self.qiWangHuXingArr addObject:sender.titleLabel.text];
            }
            else
            {
                [sender setBackgroundImage:[UIImage imageNamed:@"kh_quyuunselect"] forState:UIControlStateNormal];
                [sender setTitleColor:WXZRGBColor(27, 28, 27) forState:UIControlStateNormal];
                [self.qiWangHuXingArr removeObject:sender.titleLabel.text];
            }
            
            for (int i = 1; i < 6; i++)
            {
                UIButton *btn = (UIButton *)[self.view viewWithTag:1000040+i];
                [btn setBackgroundImage:[UIImage imageNamed:@"kh_quyuunselect"] forState:UIControlStateNormal];
                [btn setTitleColor:WXZRGBColor(27, 28, 27) forState:UIControlStateNormal];
            }
        }
        else
        {
            UIButton *btn = (UIButton *)[self.view viewWithTag:1000040];
            [btn setBackgroundImage:[UIImage imageNamed:@"kh_quyuunselect"] forState:UIControlStateNormal];
            [btn setTitleColor:WXZRGBColor(27, 28, 27) forState:UIControlStateNormal];
            [self.qiWangHuXingArr removeObject:btn.titleLabel.text]; // 移除不限户型
            
            if ([sender.currentBackgroundImage isEqual:[UIImage imageNamed:@"kh_quyuunselect"]])
            {
                [sender setBackgroundImage:[UIImage imageNamed:@"kh_quyuselected"] forState:UIControlStateNormal];
                [sender setTitleColor:WXZRGBColor(255, 255, 255) forState:UIControlStateNormal];
                [self.qiWangHuXingArr addObject:sender.titleLabel.text];
            }
            else
            {
                [sender setBackgroundImage:[UIImage imageNamed:@"kh_quyuunselect"] forState:UIControlStateNormal];
                [sender setTitleColor:WXZRGBColor(27, 28, 27) forState:UIControlStateNormal];
                [self.qiWangHuXingArr removeObject:sender.titleLabel.text];
            }
        }
    }
    else
    {
        if ([sender.currentBackgroundImage isEqual:[UIImage imageNamed:@"kh_quyuunselect"]])
        {
            [sender setBackgroundImage:[UIImage imageNamed:@"kh_quyuselected"] forState:UIControlStateNormal];
            [sender setTitleColor:WXZRGBColor(255, 255, 255) forState:UIControlStateNormal];
            [self.fangWuTypeArr addObject:sender.titleLabel.text];
        }
        else
        {
            [sender setBackgroundImage:[UIImage imageNamed:@"kh_quyuunselect"] forState:UIControlStateNormal];
            [sender setTitleColor:WXZRGBColor(27, 28, 27) forState:UIControlStateNormal];
            [self.fangWuTypeArr removeObject:sender.titleLabel.text];
        }
    }
    
    [self showHeaderInfo]; // 展示header信息
}

- (void)selectPriceAction:(UIButton *)sender
{
    if ([sender.currentBackgroundImage isEqual:[UIImage imageNamed:@"kh_quyuunselect"]])
    {
        [sender setBackgroundImage:[UIImage imageNamed:@"kh_quyuselected"] forState:UIControlStateNormal];
        [sender setTitleColor:WXZRGBColor(255, 255, 255) forState:UIControlStateNormal];
        _priceStr = @"";
        [self.pricefTextField resignFirstResponder];
        [self.priceeTextField resignFirstResponder];
        self.pricefTextField.text = @"";
        self.priceeTextField.text = @"";
    }
    else
    {
        [sender setBackgroundImage:[UIImage imageNamed:@"kh_quyuunselect"] forState:UIControlStateNormal];
        [sender setTitleColor:WXZRGBColor(27, 28, 27) forState:UIControlStateNormal];
    }
    [self showHeaderInfo]; // 展示header信息
}

- (void)determineAction:(id)sender
{
    // 添加客户请求
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    
    if (![WXZChectObject checkWhetherStringIsEmpty:self.nameTextField.text withTipInfo:@"请输入姓名"] && [WXZStringObject judgmentIsCharacterOrCharacters:self.nameTextField.text withTipInfo:@"姓名中不能包含特殊字符"] && ![WXZChectObject checkWhetherStringIsEmpty:sex withTipInfo:@"请选择性别"] && ![WXZChectObject checkWhetherStringIsEmpty:self.phoneNumTextField.text withTipInfo:@"请输入手机号"] && [WXZChectObject checkPhone2:self.phoneNumTextField.text withTipInfo:@"手机号格式不正确"])
    {
        NSString *gfyxStr = self.yixiangLabel.text;
        if ([gfyxStr isEqualToString:@"购房意向"])
        {
            gfyxStr = @"";
        }
        
        if ([self.navigationItem.title isEqualToString:@"添加客户"])
        {
            [self addCustomerRequest:@"" name:self.nameTextField.text sex:sex mobile:self.phoneNumTextField.text jiaGeS:self.pricefTextField.text jiaGeE:self.priceeTextField.text quYu:[WXZStringObject whetherStringContainsCharacter2:[self quyuMethod] character:@","] hx:[WXZStringObject whetherStringContainsCharacter2:[self huxingMethod] character:@","] yiXiang:gfyxStr isModify:NO];
        }
        else
        {
            // 修改客户信息
            [self addCustomerRequest:self.detailModel.ID name:self.nameTextField.text sex:sex mobile:self.phoneNumTextField.text jiaGeS:self.pricefTextField.text jiaGeE:self.priceeTextField.text quYu:[WXZStringObject whetherStringContainsCharacter2:[self quyuMethod] character:@","] hx:[WXZStringObject whetherStringContainsCharacter2:[self huxingMethod] character:@","] yiXiang:gfyxStr isModify:YES];
        }
    }
}

// 展示header信息
- (void)showHeaderInfo
{
    if ([WXZChectObject checkWhetherStringIsEmpty:[self quyuMethod]] && [WXZChectObject checkWhetherStringIsEmpty:[self huxingMethod]] && [WXZChectObject checkWhetherStringIsEmpty:[self yixiangMethod]])
    {
        self.yixiangLabel.text = @"购房意向";
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

// 修改客户信息：展示原来选择的信息
- (void)showTheOriginalInfo
{
    if (self.isModifyCustomerInfo)
    {
        [self.qiWangQuYuArr removeAllObjects];
        [self.qiWangHuXingArr removeAllObjects];
        [self.fangWuTypeArr removeAllObjects];
        // 原区域选择信息
        NSString *quyuStr = [WXZStringObject whetherStringContainsCharacter2:self.detailModel.QuYu character:@","];
        self.qiWangQuYuArr = (NSMutableArray *)[WXZStringObject interceptionOfString:quyuStr interceptType:@"/"];
        
        // 判断当前户型是否包含原来的户型，没有则从数组中移除，且购房意向不显示
        NSMutableArray *saveQuyuArr = [NSMutableArray array];
        for (NSString *oldQuyu in self.qiWangQuYuArr)
        {
            for (NSDictionary *newQUyuDic in self.quyuListArr)
            {
                if ([oldQuyu isEqualToString:newQUyuDic[@"q"]])
                {
                    [saveQuyuArr addObject:oldQuyu];
                }
            }
        }
        self.qiWangQuYuArr = saveQuyuArr;
        
        // 原户型和房屋类型选择信息
        NSString *hxStr = [WXZStringObject whetherStringContainsCharacter2:self.detailModel.Hx character:@","];
        NSArray *hxArr = [WXZStringObject interceptionOfString:hxStr interceptType:@"/"];
        [self.qiWangHuXingArr addObjectsFromArray:[WXZStringObject traversalReturnsString:hxArr allArr:self.huxingListArr]];
        [self.fangWuTypeArr addObjectsFromArray:[WXZStringObject traversalReturnsString:hxArr allArr:self.fangwuListArr]];
        
        [self showHeaderInfo]; // 重新构造购房意向
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self showHeaderInfo]; // 展示header信息，构造购房意向
    
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
