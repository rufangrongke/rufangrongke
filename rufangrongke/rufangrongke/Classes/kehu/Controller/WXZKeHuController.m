//
//  WXZKeHuController.m
//  rufangrongke
//
//  Created by dymost on 15/10/18.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

#import "WXZKeHuController.h"
#import "AFNetworking.h"
#import "WXZChectObject.h"
#import "WXZStringObject.h"
#import "WXZDateObject.h"
#import <SVProgressHUD.h>
#import "WXZKeHuListCell.h"
#import "WXZKHListHeaderView.h"
#import "WXZKHListFooterView.h"
#import "WXZAddCustomerVC.h"
#import "WXZCustomerDetailsVC.h"
#import "WXZReportPreparationVC.h"
#import "WXZScreeningView.h"
#import "WXZKeHuInfoModel.h"
#import <MJExtension.h>
#import "WXZLeftBtnView.h"

@interface WXZKeHuController () <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UISearchBarDelegate,BackFilterTypeDelegate>
{
    NSString *eachPage; // 每页显示条数
    BOOL isRefresh; // 是否刷新
}

@property (nonatomic,strong) UISearchBar *searchBar;
@property (nonatomic,strong) UITextField *searchTextField;

@property (nonatomic,strong) WXZScreeningView *screeningView;

//@property (nonatomic,strong) UIView *mengCengView;

@property (nonatomic,strong) NSMutableArray *dataArr;

@property (nonatomic,strong) NSArray *shaixuanArr;

@property (nonatomic,weak) WXZKHListHeaderView *headerView;
@property (nonatomic,weak) WXZKHListFooterView *footerView;

@property (nonatomic,strong) WXZKeHuInfoModel *kehuInfoModel;

@property (nonatomic,strong) UIButton *leftButton; // 导航栏左侧按钮
@property (nonatomic,strong) UIView *leftView;
@property (nonatomic,strong) UILabel *leftTitleLabel;
@property (nonatomic,strong) UIImageView *leftImgView;
/* leftBtn */
@property (nonatomic , weak) WXZLeftBtnView *leftBtn;
@end

static NSInteger isHiden; // 弹框是否隐藏
static NSInteger currentPage; // 当前页数
static BOOL isMore; // 是否有更多数据
static NSString *shaixuanStr; // 记录筛选类型
static NSString *searchStr; // 记录搜索条件

@implementation WXZKeHuController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 视图整体背景色
    self.view.backgroundColor = WXZRGBColor(246, 246, 246);
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.userInteractionEnabled = YES;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 初始化
    self.dataArr = [NSMutableArray array];
    self.shaixuanArr = @[@"所有",@"已报备",@"已带看",@"已预约",@"已认购",@"已结佣",@"未报备",@"无效客户"];
    
    isRefresh = YES;
    isMore = YES;
    currentPage = 1;
    eachPage = @"10";
    shaixuanStr = @"";
    searchStr = @"";
    // 显示菊花
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    // 请求列表
    [self keHuListRequest:currentPage numberEachPage:eachPage handsomeChooseCategory:shaixuanStr handsomeChooseConditions:searchStr];
    [self setupRefresh];
    
    // 初始化信息
    [self setUp];
    isHiden = NO;
    
    // 注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateKeHuInfo:) name:@"UpdateKeHuInfoNotification" object:nil];
}

#pragma 初始化项目
- (void)setUp
{
    // 左边按钮
    _leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 52, 44)];
    _leftView.backgroundColor = [UIColor clearColor];
    
    _leftTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 38, _leftView.height)];
    _leftTitleLabel.text = @"筛选";
    _leftTitleLabel.font = WXZ_SystemFont(18);
    _leftTitleLabel.textColor = [UIColor whiteColor];
    [_leftView addSubview:_leftTitleLabel];
    
    _leftImgView = [[UIImageView alloc] initWithFrame:CGRectMake(_leftView.width-14, (_leftView.height-8)/2, 14, 8)];
    _leftImgView.image = [UIImage imageNamed:@"kh_ip_jt"];
    [_leftView addSubview:_leftImgView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(quDu_click)];
    [_leftView addGestureRecognizer:tap];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_leftView];
    // 右边按钮
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage2:@"lp_qd" highImage:@"lp_qd" title:@"" target:self action:@selector(queDing_click) isEnable:YES];
    
    // 添加一个系统的搜索框
    _searchBar = [[UISearchBar alloc] init];
    _searchBar.backgroundColor = [UIColor clearColor];
    _searchBar.backgroundImage = [UIImage imageNamed:@""];
    _searchBar.placeholder = @"请输入客户姓名";
    _searchBar.delegate = self;
    self.navigationItem.titleView = _searchBar;
}

#pragma mark - Data Request Methods
- (void)keHuListRequest:(NSInteger)page numberEachPage:(NSString *)eachPage1 handsomeChooseCategory:(NSString *)chooseCategory handsomeChooseConditions:(NSString *)chooseConditions
{
    NSString *urlStr = [OutNetBaseURL stringByAppendingString:kehuliebiao];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[NSString stringWithFormat:@"%ld",(long)page] forKey:@"inp"];
    [param setObject:eachPage1 forKey:@"ps"];
    [param setObject:chooseCategory forKey:@"zt"];
    [param setObject:chooseConditions forKey:@"key"];
//    WXZLog(@"%@",param);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager POST:urlStr parameters:param success:^(NSURLSessionDataTask *task, id responseObject)
    {
        if ([responseObject[@"ok"] integerValue] == 1)
        {
            WXZLog(@"%@", responseObject);
            NSArray *arr = responseObject[@"list"];
            if (isRefresh)
            {
                if (arr.count > 0)
                {
                    // 直接把数组里边的字典的值转换为模型
                    self.dataArr = [NSMutableArray arrayWithArray:[WXZKeHuInfoModel objectArrayWithKeyValuesArray:arr]];
                    if (arr.count < eachPage.integerValue)
                    {
                        [self.tableView.footer endRefreshingWithNoMoreData];
                        isMore = NO;
                    }
                }
                else
                {
                    [self.dataArr removeAllObjects];
                    [self.tableView.footer endRefreshingWithNoMoreData];
                    isMore = NO;
                }
            }
            else
            {
                if (arr.count > 0)
                {
                    [self.dataArr addObjectsFromArray:[WXZKeHuInfoModel objectArrayWithKeyValuesArray:arr]];
                }
                else
                {
                    [self.tableView.footer endRefreshingWithNoMoreData];
                    isMore = NO;
                }
            }
            [SVProgressHUD dismiss]; // 取消菊花
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:responseObject[@"msg"]];
            if ([responseObject[@"msg"] isEqualToString:@"登陆超时"])
            {
                [self goBackLoginPage]; // 回到登录页面
            }
        }
        [self.tableView reloadData];
        // 结束刷新
        [self.tableView.header endRefreshing];
        if (isMore)
        {
            // 结束刷新
            [self.tableView.footer endRefreshing];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error)
    {
        [SVProgressHUD showErrorWithStatus:@"请求失败"];
    }];
}

- (void)backScreeningType:(NSString *)type
{
    [self hideScreeningView];
    currentPage = 1;
    isRefresh = YES;
    shaixuanStr = type;
    if ([type isEqualToString:@"筛选"])
    {
        shaixuanStr = @"";
    }
    // 计算宽度
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,WXZ_SystemFont(18),NSFontAttributeName, nil];
    CGRect rect = [type boundingRectWithSize:CGSizeMake(120, 44) options:NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine attributes:dic context:nil];
    _leftView.frame = CGRectMake(0, 0, rect.size.width+14, 44);
    _leftTitleLabel.frame = CGRectMake(0, 0, _leftView.width-14, _leftView.height);
    _leftImgView.frame = CGRectMake(_leftView.width-14, (_leftView.height-8)/2, 14, 8);
    _leftTitleLabel.text = type;
    [_leftView setNeedsUpdateConstraints]; // 更新约束
    
    if ([type isEqualToString:@"筛选"])
    {
        shaixuanStr = @"";
    }
    
    // 显示菊花
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    // 请求列表
    [self keHuListRequest:currentPage numberEachPage:eachPage handsomeChooseCategory:shaixuanStr handsomeChooseConditions:searchStr];
}

// 通知事件，刷新客户列表（显示所有数据）
- (void)updateKeHuInfo:(id)sender
{
    [_screeningView removeFromSuperview]; // 移除弹出框view
    _screeningView = nil; // 置为空
    
    _leftView.size = CGSizeMake(52, 44);
    _leftTitleLabel.size = CGSizeMake(38, 44);
    _leftImgView.frame = CGRectMake(_leftView.width-14, (_leftView.height-8)/2, 14, 8);
    _leftTitleLabel.text = @"筛选";
    [_leftView setNeedsUpdateConstraints]; // 更新约束
    
    currentPage = 1;
    isRefresh = YES;
    shaixuanStr = @"";
    searchStr = @"";
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack]; // 显示菊花
    [self keHuListRequest:currentPage numberEachPage:eachPage handsomeChooseCategory:shaixuanStr handsomeChooseConditions:searchStr]; // 请求列表
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArr.count+1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        NSString *identifier = @"cell";
        UITableViewCell *headerCell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!headerCell)
        {
            headerCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        return headerCell;
    }
    else
    {
        WXZKeHuListCell *keHuInfoCell = [tableView dequeueReusableCellWithIdentifier:@"KeHuInfoCell"];
        
        if (!keHuInfoCell)
        {
            keHuInfoCell = [WXZKeHuListCell initListCell];
            keHuInfoCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        keHuInfoCell.controller = self; // 权限
        
        // 赋值
        keHuInfoCell.keHuInfoModel = self.dataArr[indexPath.section-1];
        
        return keHuInfoCell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self hideScreeningView];
    // 客户详情页
    WXZCustomerDetailsVC *customerDetailsVC = [[WXZCustomerDetailsVC alloc] init];
    self.kehuInfoModel = self.dataArr[indexPath.section-1];
    customerDetailsVC.customerId = self.kehuInfoModel.ID;
    [self.navigationController pushViewController:customerDetailsVC animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        _headerView = [WXZKHListHeaderView initListHeaderView]; // header背景 view
        // 添加轻击手势
        UITapGestureRecognizer *headerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addNewKeHuAction:)];
        [_headerView addGestureRecognizer:headerTap];
        
        return _headerView;
    }
    else
    {
        return nil;
    }
}

//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
////    if (section != 0)
////    {
////        // 首先判断有没有值
////        self.kehuInfoModel = self.dataArr[section-1];
////        if (![WXZChectObject checkWhetherStringIsEmpty:self.kehuInfoModel.hdTime] || ![WXZChectObject checkWhetherStringIsEmpty:self.kehuInfoModel.typebig] || ![WXZChectObject checkWhetherStringIsEmpty:self.kehuInfoModel.loupan])
////        {
////            _footerView = [WXZKHListFooterView initListFooterView]; // footer背景 view
////            _footerView.keHuInfoModel = self.dataArr[section-1]; // footer 信息
////            
////            return _footerView;
////        }
////        else
////        {
////            return nil;
////        }
////    }
//    return nil;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    // 返回header的高
    if (section == 0)
    {
        return 48;
    }
    else
    {
        return 0.1f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
//    if (section == 0)
//    {
//        return 0.001;
//    }
//    return 31;
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return 0.0f;
    }
    return [self calculateHeightOfRow:self.dataArr[indexPath.section-1]]; // 75
}

// 计算行高
- (NSInteger)calculateHeightOfRow:(WXZKeHuInfoModel *)model
{
    NSString *yixiangStr = model.YiXiang;
    NSInteger yixiang = 0;
    if (![WXZChectObject checkWhetherStringIsEmpty:yixiangStr])
    {
        yixiang = 18;
    }
    
    return 20 + 20 + 12 + yixiang+31; // 返回行高
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self hideScreeningView];
    [_searchBar resignFirstResponder];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.screeningView.frame = CGRectMake(0, self.tableView.contentOffset.y, WXZ_ScreenWidth, WXZ_ScreenHeight-64);
}

#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [self hideScreeningView];
    return YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    searchStr = searchBar.text;
    [self hideScreeningView];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
//    searchStr = searchBar.text;
    [self queDing_click]; //
}

#pragma - mark 刷新、加载
/**
 * 添加刷新控件
 */
- (void)setupRefresh
{
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshKeHuInfo)];
    
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreKeHuInfo)];
    //    self.tableView.footer.hidden = YES;
}
- (void)refreshKeHuInfo
{
    // 刷新
    currentPage = 1;
    isRefresh = YES;
    isMore = YES;
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    [self keHuListRequest:currentPage numberEachPage:eachPage handsomeChooseCategory:shaixuanStr handsomeChooseConditions:searchStr];
}
- (void)loadMoreKeHuInfo
{
    // 加载更多
    isRefresh = NO;
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    [self keHuListRequest:++currentPage numberEachPage:eachPage handsomeChooseCategory:shaixuanStr handsomeChooseConditions:searchStr];
}

// 添加新客户事件
- (void)addNewKeHuAction:(id)sender
{
    [self hideScreeningView];
    [_searchBar resignFirstResponder];
    // 添加新客户页
    WXZAddCustomerVC *addCustomerVC = [[WXZAddCustomerVC alloc] init];
    addCustomerVC.isModifyCustomerInfo = NO;
    addCustomerVC.titleStr = @"添加客户";
    addCustomerVC.isKeHuDetail = NO;
    [self.navigationController pushViewController:addCustomerVC animated:YES];
}

#pragma mark - Navigation BarButtonItem Click Event
// 右上方按钮监听点击
- (void)queDing_click
{
    [self.searchBar resignFirstResponder];
    [self hideScreeningView];
    currentPage = 1;
    isRefresh = YES;
    searchStr = self.searchBar.text;
    // 显示菊花
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    // 请求列表
    [self keHuListRequest:currentPage numberEachPage:eachPage handsomeChooseCategory:shaixuanStr handsomeChooseConditions:searchStr];
}
// 左上方按钮监听点击
- (void)quDu_click
{
    [self.searchBar resignFirstResponder];
    if (isHiden)
    {
        [self hideScreeningView];
    }
    else
    {
        // 显示视图
        if (_screeningView == nil)
        {
            _screeningView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([WXZScreeningView class]) owner:self options:nil] lastObject];
            _screeningView.frame = CGRectMake(0, self.tableView.contentOffset.y, WXZ_ScreenWidth, WXZ_ScreenHeight-64);
            _screeningView.backgroundColor = [UIColor whiteColor];
            [self.view addSubview:_screeningView];
        }
        
        _screeningView.frame = CGRectMake(0, self.tableView.contentOffset.y, WXZ_ScreenWidth, WXZ_ScreenHeight-64);
        _screeningView.dataArr = self.shaixuanArr;
        _screeningView.backScreeningTypeDelegate = self;
        _screeningView.hidden = NO;
        self.tableView.scrollEnabled = NO;
        self.headerView.hidden = YES;
        self.footerView.hidden = YES;
        isHiden = YES;
    }
}
// 隐藏筛选视图
- (void)hideScreeningView
{
    [self.screeningView setHidden:YES];
    self.tableView.scrollEnabled = YES;
    self.headerView.hidden = NO;
    self.footerView.hidden = NO;
    isHiden = NO;
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
