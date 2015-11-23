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

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@property (nonatomic,strong) UIButton *menBtn; // 性别男按钮
@property (nonatomic,strong) UIButton *womenBtn; // 性别女按钮

@property (nonatomic,strong) UITextField *nameTextField; // 姓名
@property (nonatomic,strong) UITextField *phoneNumTextField; // 手机号
@property (nonatomic,strong) UITextField *pricefTextField; // 购房价格范围开始价格
@property (nonatomic,strong) UITextField *priceeTextField; // 购房价格范围结束价格

@property (nonatomic,strong) NSString *priceStr; // 记录价格属性

@property (nonatomic,strong) NSArray *quyuListArr; // 存储区域列表数据数组
@property (nonatomic,strong) NSArray *huxingListArr; // 存储户型列表数据数组
@property (nonatomic,strong) NSArray *fangwuListArr; // 存储房屋类型列表数据数组
@property (nonatomic,strong) NSMutableArray *qiWangQuYuArr; // 存储本地选择的区域意向数组
@property (nonatomic,strong) NSMutableArray *qiWangHuXingArr; // 存储本地选择的户型意向数组
@property (nonatomic,strong) NSMutableArray *fangWuTypeArr; // 存储本地选择的房屋类型意向数组

@property (nonatomic,strong) UILabel *yixiangLabel; // 购房意向整体信息

@end

static NSString *sex = @""; // 记录选择的性别，默认为男

@implementation WXZAddCustomerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // 视图整体背景色
    self.view.backgroundColor = WXZRGBColor(246, 246, 246);
    self.navigationItem.title = self.titleStr;
    
    // 设置 tableView 代理
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    
    // 期望区域列表数据请求
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack]; // 显示菊花
    [self quyuListRequest]; // 请求
    
    sex = @"先生"; // 性别初始值为男
    _priceStr = @""; // 购房价格初始值为空
    // 初始化户型和房型列表数据，并保存到数组中
    self.huxingListArr = @[@"不限户型",@"一室",@"二室",@"三室",@"四室",@"五室及以上"];
    self.fangwuListArr = @[@"复室",@"住宅",@"别墅",@"商铺"];
    // 初始化本地选择的区域、户型、房型数据存储数组
    self.qiWangQuYuArr = [NSMutableArray array];
    self.qiWangHuXingArr = [NSMutableArray array];
    self.fangWuTypeArr = [NSMutableArray array];
    
    // 注册通知，用来返回购房价格范围－输入的开始和结束价格
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backPriceInfo:) name:@"BackPriceInfoAndUpdate" object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    // 每次进来，需清空本地数组中数据
    [self.qiWangQuYuArr removeAllObjects];
    [self.qiWangHuXingArr removeAllObjects];
    [self.fangWuTypeArr removeAllObjects];
}

//- (void)viewDidAppear:(BOOL)animated
//{
//    [self showHeaderInfo]; // 显示购房整体意向
//    [self.myTableView reloadData]; // 刷新列表
//}

#pragma mark - QiWangQuYu List Or Commit Add/Modify Request
// 区域列表数据请求
- (void)quyuListRequest
{
    NSString *url = [OutNetBaseURL stringByAppendingString:quyuliebiao]; // 区域列表请求url
    [[AFHTTPSessionManager manager] POST:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject)
    {
        if ([responseObject[@"ok"] integerValue] == 1)
        {
            // 取出数据，并赋值
            self.quyuListArr = responseObject[@"qus"];
            [self showTheOriginalInfo]; // 重新构造购房意向信息
            [self.myTableView reloadData]; // 刷新列表
            [SVProgressHUD dismiss];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:responseObject[@"msg"] maskType:SVProgressHUDMaskTypeBlack]; // 显示错误信息
            // 判断是否为登陆超时，登录超时则返回登录页面重新登录
            if ([responseObject[@"msg"] isEqualToString:@"登陆超时"])
            {
                [self goBackLoginPage]; // 回到登录页面
            }
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"请求失败" maskType:SVProgressHUDMaskTypeBlack];
    }];
}

// 添加客户，或修改购房意向
- (void)addCustomerRequest:(NSString *)kehuId name:(NSString *)name sex:(NSString *)sex mobile:(NSString *)mobile jiaGeS:(NSString *)jiaGeS jiaGeE:(NSString *)jiaGeE quYu:(NSString *)quyu hx:(NSString *)hx yiXiang:(NSString *)yixinag isModify:(BOOL)isModify
{
    NSString *url = [OutNetBaseURL stringByAppendingString:kehutianjia]; // 添加客户请求url
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (isModify)
    {
        url = [OutNetBaseURL stringByAppendingString:kehuxiugai]; // 修改客户信息请求url
        [param setObject:kehuId forKey:@"id"]; // 客户id
    }
    [param setObject:name forKey:@"XingMing"]; // 客户姓名
    [param setObject:sex forKey:@"Sex"]; // 客户性别
    [param setObject:mobile forKey:@"Mobile"]; // 客户手机号
    [param setObject:jiaGeS forKey:@"JiaGeS"]; // 购房价格范围－开始价格
    [param setObject:jiaGeE forKey:@"JiaGeE"]; // 购房价格范围－结束价格
    [param setObject:quyu forKey:@"QuYu"]; // 购房期望区域
    [param setObject:hx forKey:@"Hx"]; // 购房期望户型和房型
    [param setObject:yixinag forKey:@"YiXiang"]; // 购房整体意向
    
    [[AFHTTPSessionManager manager] POST:url parameters:param success:^(NSURLSessionDataTask *task, id responseObject)
    {
        if ([responseObject[@"ok"] integerValue] == 1)
        {
            // 判断是否是客户详情页面
            if (self.isKeHuDetail)
                [self.updateDelegate updateKeHuDetailInfo:self.detailModel.ID]; // 调用刷新客户详情页代理方法
            else
                [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateKeHuInfoNotification" object:nil]; // 发送通知刷新客户首页方法
            
            [SVProgressHUD dismiss];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:responseObject[@"msg"] maskType:SVProgressHUDMaskTypeBlack];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"请求失败" maskType:SVProgressHUDMaskTypeBlack];
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
        // 客户基本信息cell
        WXZBasicInfoCell *bCell = [tableView dequeueReusableCellWithIdentifier:@"BasicInfoCell"];
        if (!bCell)
        {
            bCell = [WXZBasicInfoCell initBasicInfoCell];
        }
        [bCell.menBtn addTarget:self action:@selector(sexSelectAction:) forControlEvents:UIControlEventTouchUpInside];
        [bCell.womenBtn addTarget:self action:@selector(sexSelectAction:) forControlEvents:UIControlEventTouchUpInside];
        // 赋值给本地btn
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
            // 期望价格cell
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
            // 期望区域、户型、房型cell
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
                // 添加期望区域button和信息
                [pCell showTypeData:self.quyuListArr Target:self action:@selector(typeSelectAction:) row:indexPath.row withQuYuArr:self.qiWangQuYuArr withHxArr:self.qiWangHuXingArr withFwArr:self.fangWuTypeArr isModify:self.isModifyCustomerInfo yuanData:self.detailModel];
            }
            else if (indexPath.row == 1)
            {
                // 添加期望户型button和信息
                [pCell showTypeData:self.huxingListArr Target:self action:@selector(typeSelectAction:) row:indexPath.row withQuYuArr:self.qiWangQuYuArr withHxArr:self.qiWangHuXingArr withFwArr:self.fangWuTypeArr isModify:self.isModifyCustomerInfo yuanData:self.detailModel];
            }
            else
            {
                // 添加房屋类型button和信息
                [pCell showTypeData:self.fangwuListArr Target:self action:@selector(typeSelectAction:) row:indexPath.row withQuYuArr:self.qiWangQuYuArr withHxArr:self.qiWangHuXingArr withFwArr:self.fangWuTypeArr isModify:self.isModifyCustomerInfo yuanData:self.detailModel];
            }
            
            return pCell;
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1)
    {
        // 添加显示购房意向整体信息的headerView
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 33)];
        headerView.backgroundColor = WXZRGBColor(246, 246, 246);
        
        self.yixiangLabel = [[UILabel alloc] initWithFrame:CGRectMake(11, 0, headerView.width-11*2, headerView.height)];
        self.yixiangLabel.font = WXZ_SystemFont(15);
        self.yixiangLabel.textColor = WXZRGBColor(140, 139, 139);
        [headerView addSubview:self.yixiangLabel];
        // 判断是否是修改客户购房信息，且原购房信息不为空，则先显示原购房信息
        if (self.isModifyCustomerInfo && (![WXZChectObject checkWhetherStringIsEmpty:[NSString stringWithFormat:@"%@",self.detailModel.QuYu]] || ![WXZChectObject checkWhetherStringIsEmpty:[NSString stringWithFormat:@"%@",self.detailModel.Hx]] || ![WXZChectObject checkWhetherStringIsEmpty:[NSString stringWithFormat:@"%@",self.detailModel.JiaGeS]] || ![WXZChectObject checkWhetherStringIsEmpty:[NSString stringWithFormat:@"%@",self.detailModel.JiaGeE]]))
        {
            [self showHeaderInfo]; // 展示原购房意向（客户详情页）
        }
        else if (self.qiWangQuYuArr.count != 0 || self.qiWangHuXingArr.count != 0 || self.fangWuTypeArr.count != 0 || ![WXZChectObject checkWhetherStringIsEmpty:_priceStr])
        {
            [self showHeaderInfo]; // 展示本地已有购房意向（手动添加的）
        }
        else
            self.yixiangLabel.text = @"购房意向"; // 显示默认信息
            
        return headerView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 返回行高
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
    // 返回header行高
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
    NSInteger sumHeight = row * 22 + (row - 1) * 15 + 18 + 18 + 10; // (控件高度＋控件之间的间距＋标题的高＋标题距上边的高)
    
    return sumHeight; // 返回行高
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.nameTextField resignFirstResponder];
    [self.phoneNumTextField resignFirstResponder];
    [self.pricefTextField resignFirstResponder];
    [self.priceeTextField resignFirstResponder];
}

// 性别按钮选择事件
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

// 区域、户型、房型按钮选择事件
- (void)typeSelectAction:(UIButton *)sender
{
    [self.nameTextField resignFirstResponder];
    [self.phoneNumTextField resignFirstResponder];
    [self.pricefTextField resignFirstResponder];
    [self.priceeTextField resignFirstResponder];
    // 获取点击的tag值，并判断属于哪个button组
    NSString *str = [NSString stringWithFormat:@"%ld",(long)sender.tag];
    str = [str substringWithRange:NSMakeRange(0, str.length-1)];
    if ([str isEqualToString:@"100003"])
    {
        // 期望区域：通过判断当前背景图片，改变button选中还是未选中
        if ([sender.currentBackgroundImage isEqual:[UIImage imageNamed:@"kh_quyuunselect"]])
        {
            [sender setBackgroundImage:[UIImage imageNamed:@"kh_quyuselected"] forState:UIControlStateNormal];
            [sender setTitleColor:WXZRGBColor(255, 255, 255) forState:UIControlStateNormal];
            [self.qiWangQuYuArr addObject:sender.titleLabel.text]; // 选中则存储选中区域内容
        }
        else
        {
            [sender setBackgroundImage:[UIImage imageNamed:@"kh_quyuunselect"] forState:UIControlStateNormal];
            [sender setTitleColor:WXZRGBColor(27, 28, 27) forState:UIControlStateNormal];
            [self.qiWangQuYuArr removeObject:sender.titleLabel.text]; // 未选中移除相应区域内容
        }
    }
    else if ([str isEqualToString:@"100004"])
    {
        // 期望户型：首先判断是否选中“不限户型”，是则其他按钮为不选中状态
        if (sender.tag == 1000040)
        {
            // 通过判断当前背景图片，改变button选中还是未选中
            if ([sender.currentBackgroundImage isEqual:[UIImage imageNamed:@"kh_quyuunselect"]])
            {
                [sender setBackgroundImage:[UIImage imageNamed:@"kh_quyuselected"] forState:UIControlStateNormal];
                [sender setTitleColor:WXZRGBColor(255, 255, 255) forState:UIControlStateNormal];
                [self.qiWangHuXingArr removeAllObjects]; // 选中“不限户型”，先移除数组中所有数据
                [self.qiWangHuXingArr addObject:sender.titleLabel.text]; // 添加“不限户型”
            }
            else
            {
                [sender setBackgroundImage:[UIImage imageNamed:@"kh_quyuunselect"] forState:UIControlStateNormal];
                [sender setTitleColor:WXZRGBColor(27, 28, 27) forState:UIControlStateNormal];
                [self.qiWangHuXingArr removeObject:sender.titleLabel.text]; // 不选中从数组中移除“不限户型”
            }
            // 通过tag值遍历button，其他按钮为不选中状态
            for (int i = 1; i < 6; i++)
            {
                UIButton *btn = (UIButton *)[self.view viewWithTag:1000040+i];
                [btn setBackgroundImage:[UIImage imageNamed:@"kh_quyuunselect"] forState:UIControlStateNormal];
                [btn setTitleColor:WXZRGBColor(27, 28, 27) forState:UIControlStateNormal];
            }
        }
        else
        {
            // 通过tag值使“不限户型”按钮为不选中状态
            UIButton *btn = (UIButton *)[self.view viewWithTag:1000040];
            [btn setBackgroundImage:[UIImage imageNamed:@"kh_quyuunselect"] forState:UIControlStateNormal];
            [btn setTitleColor:WXZRGBColor(27, 28, 27) forState:UIControlStateNormal];
            [self.qiWangHuXingArr removeObject:btn.titleLabel.text]; // 先移除“不限户型”
            // 通过判断当前背景图片，改变button选中还是未选中
            if ([sender.currentBackgroundImage isEqual:[UIImage imageNamed:@"kh_quyuunselect"]])
            {
                [sender setBackgroundImage:[UIImage imageNamed:@"kh_quyuselected"] forState:UIControlStateNormal];
                [sender setTitleColor:WXZRGBColor(255, 255, 255) forState:UIControlStateNormal];
                [self.qiWangHuXingArr addObject:sender.titleLabel.text]; // 选中，添加对应户型内容
            }
            else
            {
                [sender setBackgroundImage:[UIImage imageNamed:@"kh_quyuunselect"] forState:UIControlStateNormal];
                [sender setTitleColor:WXZRGBColor(27, 28, 27) forState:UIControlStateNormal];
                [self.qiWangHuXingArr removeObject:sender.titleLabel.text]; // 不选中，移除对应户型内容
            }
        }
    }
    else
    {
        // 房屋类型：通过判断当前背景图片，改变button选中还是未选中
        if ([sender.currentBackgroundImage isEqual:[UIImage imageNamed:@"kh_quyuunselect"]])
        {
            [sender setBackgroundImage:[UIImage imageNamed:@"kh_quyuselected"] forState:UIControlStateNormal];
            [sender setTitleColor:WXZRGBColor(255, 255, 255) forState:UIControlStateNormal];
            [self.fangWuTypeArr addObject:sender.titleLabel.text]; // 选中，添加房屋类型对应内容
        }
        else
        {
            [sender setBackgroundImage:[UIImage imageNamed:@"kh_quyuunselect"] forState:UIControlStateNormal];
            [sender setTitleColor:WXZRGBColor(27, 28, 27) forState:UIControlStateNormal];
            [self.fangWuTypeArr removeObject:sender.titleLabel.text]; // 不选中，移除房屋类型对应内容
        }
    }
    
    [self showHeaderInfo]; // 刷新并展示header信息
}

// 购房价格范围选择事件
- (void)selectPriceAction:(UIButton *)sender
{
    // 价格不限：通过判断当前背景图片，改变button选中还是未选中
    if ([sender.currentBackgroundImage isEqual:[UIImage imageNamed:@"kh_quyuunselect"]])
    {
        [sender setBackgroundImage:[UIImage imageNamed:@"kh_quyuselected"] forState:UIControlStateNormal];
        [sender setTitleColor:WXZRGBColor(255, 255, 255) forState:UIControlStateNormal];
        _priceStr = @""; // 选中不限价格，则价格传空值
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
    [self showHeaderInfo]; // 更新并展示header信息
}

// 确定按钮点击事件
- (void)determineAction:(id)sender
{
    // 添加或修改客户信息请求
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack]; // 显示菊花
    // 判断所填信息是否符合规范
    if (![WXZChectObject checkWhetherStringIsEmpty:self.nameTextField.text withTipInfo:@"请输入姓名"] && [WXZStringObject judgmentIsCharacterOrCharacters:self.nameTextField.text withTipInfo:@"姓名中不能包含特殊字符"] && ![WXZChectObject checkWhetherStringIsEmpty:sex withTipInfo:@"请选择性别"] && ![WXZChectObject checkWhetherStringIsEmpty:self.phoneNumTextField.text withTipInfo:@"请输入手机号"] && [WXZChectObject checkPhone2:self.phoneNumTextField.text withTipInfo:@"手机号格式不正确"])
    {
        NSString *gfyxStr = self.yixiangLabel.text;
        if ([gfyxStr isEqualToString:@"购房意向"])
        {
            gfyxStr = @"";
        }
        // 判断是添加还是修改客户信息
        if ([self.navigationItem.title isEqualToString:@"添加客户"])
        {
            // 添加客户信息请求
            [self addCustomerRequest:@"" name:self.nameTextField.text sex:sex mobile:self.phoneNumTextField.text jiaGeS:self.pricefTextField.text jiaGeE:self.priceeTextField.text quYu:[WXZStringObject whetherStringContainsCharacter2:[self quyuMethod] character:@","] hx:[WXZStringObject whetherStringContainsCharacter2:[self huxingMethod] character:@","] yiXiang:gfyxStr isModify:NO];
        }
        else
        {
            // 修改客户信息请求
            [self addCustomerRequest:self.detailModel.ID name:self.nameTextField.text sex:sex mobile:self.phoneNumTextField.text jiaGeS:self.pricefTextField.text jiaGeE:self.priceeTextField.text quYu:[WXZStringObject whetherStringContainsCharacter2:[self quyuMethod] character:@","] hx:[WXZStringObject whetherStringContainsCharacter2:[self huxingMethod] character:@","] yiXiang:gfyxStr isModify:YES];
        }
    }
}

// 展示header信息方法
- (void)showHeaderInfo
{
    // 判断返回的区域、户型和房型是否为空
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

// 返回区域拼接后的信息
- (NSString *)quyuMethod
{
    return [WXZStringObject pinJieString1:self.qiWangQuYuArr];
}

// 返回户型和房型拼接后的信息
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

// 返回意向拼接后的信息
- (NSString *)yixiangMethod
{
    if (![WXZChectObject checkWhetherStringIsEmpty:self.pricefTextField.text] || ![WXZChectObject checkWhetherStringIsEmpty:self.priceeTextField.text])
    {
        NSString *sStr = @"";
        NSString *eStr = @"";
        if (![WXZChectObject checkWhetherStringIsEmpty:self.pricefTextField.text] && [WXZChectObject checkIsAllNumber:self.pricefTextField.text withTipInfo:@"请检查价格"])
        {
            sStr = self.pricefTextField.text;
        }
        if (![WXZChectObject checkWhetherStringIsEmpty:self.priceeTextField.text] && [WXZChectObject checkIsAllNumber:self.priceeTextField.text withTipInfo:@"请检查价格"])
        {
            eStr = self.priceeTextField.text;
        }
        _priceStr = [NSString stringWithFormat:@"%@-%@万",sStr,eStr];
    }
    else
    {
        _priceStr = @"";
    }
    return _priceStr;
}
// 通知事件，返回输入的购房价格信息
- (void)backPriceInfo:(NSNotification *)notification
{
    [self showHeaderInfo]; // 更新并展示header信息
}

// 修改客户信息：展示原来选择的购房信息
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
