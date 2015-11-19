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
#import "WXZAddCustomerVC.h"
#import "WXZCustomerDetailsVC.h"
#import "WXZReportPreparationVC.h"
#import "WXZScreeningView.h"
#import "WXZKeHuInfoModel.h"
#import <MJExtension.h>

@interface WXZKeHuController () <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UISearchBarDelegate,BackFilterTypeDelegate>
{
    NSString *eachPage; // 每页显示条数
    BOOL isRefresh; // 是否刷新
}

@property (nonatomic,strong) UISearchBar *searchBar; // 搜索框
//@property (nonatomic,strong) UITextField *searchTextField; // 搜索框

@property (nonatomic,strong) WXZScreeningView *screeningView; // 筛选弹窗
@property (nonatomic,weak) WXZKHListHeaderView *headerView; // 添加客户的section的headerView

@property (nonatomic,strong) NSArray *shaixuanArr; // 存储筛选弹窗数据的数组
@property (nonatomic,strong) NSMutableArray *dataArr; // 存储客户列表数据的数组

@property (nonatomic,strong) WXZKeHuInfoModel *kehuInfoModel; // 客户列表信息的模型
/** 导航栏左侧按钮 **/
@property (nonatomic,strong) UIView *leftView; // 导航栏左侧按钮view
@property (nonatomic,strong) UILabel *leftTitleLabel; // 导航栏左侧按钮标题label
@property (nonatomic,strong) UIImageView *leftImgView; // 导航栏左侧按钮箭头图片

@end

static NSInteger isTanChuangHiden; // 弹框是否隐藏
/** 数据请求相关 **/
static NSInteger currentPage; // 当前页数
static BOOL isMore; // 是否有更多数据
static NSString *shaixuanStr; // 记录筛选类型内容
static NSString *searchStr; // 记录搜索条件内容

@implementation WXZKeHuController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 视图整体背景色
    self.view.backgroundColor = WXZRGBColor(246, 246, 246);
    // 设置tableView的代理和相关属性值
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 初始化导航栏信息
    [self setUp];
    isTanChuangHiden = NO; // 弹框是否隐藏
    
    // 初始化客户信息列表数组，及筛选弹窗的数据
    self.dataArr = [NSMutableArray array];
    self.shaixuanArr = @[@"所有",@"已报备",@"已带看",@"已预约",@"已认购",@"已结佣",@"未报备",@"无效客户"];
    
    /** 客户列表数据请求 **/
    isRefresh = YES; // 是否刷新
    isMore = YES; // 是否有更多数据
    currentPage = 1; // 当钱请求页数
    eachPage = @"10"; // 每页请求的数据条数
    shaixuanStr = @""; // 筛选类型内容
    searchStr = @""; // 搜索条件内容
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack]; // 显示菊花
    [self keHuListRequest:currentPage numberEachPage:eachPage handsomeChooseCategory:shaixuanStr handsomeChooseConditions:searchStr]; // 请求列表
    [self setupRefresh]; // 添加下拉刷新和自动上拉加载更多方法
    
    
    
    // 注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateKeHuInfo:) name:@"UpdateKeHuInfoNotification" object:nil];
}

#pragma mark - 初始化导航栏信息
- (void)setUp
{
    // 左边按钮
    _leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 52, 44)];
    _leftView.backgroundColor = [UIColor clearColor];
    // 左边按钮标题
    _leftTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 38, _leftView.height)];
    _leftTitleLabel.text = @"筛选";
    _leftTitleLabel.font = WXZ_SystemFont(18);
    _leftTitleLabel.textColor = [UIColor whiteColor];
    [_leftView addSubview:_leftTitleLabel];
    // 左边按钮箭头图片
    _leftImgView = [[UIImageView alloc] initWithFrame:CGRectMake(_leftView.width-14, (_leftView.height-8)/2, 14, 8)];
    _leftImgView.image = [UIImage imageNamed:@"kh_ip_jt"];
    [_leftView addSubview:_leftImgView];
    // 添加左侧按钮的轻击手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(quDu_click)];
    [_leftView addGestureRecognizer:tap];
    // 显示
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
    NSString *urlStr = [OutNetBaseURL stringByAppendingString:kehuliebiao]; // 请求url
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[NSString stringWithFormat:@"%ld",(long)page] forKey:@"inp"]; // 请求的页数
    [param setObject:eachPage1 forKey:@"ps"]; // 每页请求的条数
    [param setObject:chooseCategory forKey:@"zt"]; // 筛选类型
    [param setObject:chooseConditions forKey:@"key"]; // 搜索条件
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:urlStr parameters:param success:^(NSURLSessionDataTask *task, id responseObject)
    {
        if ([responseObject[@"ok"] integerValue] == 1)
        {
            NSArray *arr = responseObject[@"list"]; // 取出所需数据
            // 判断是否为刷新
            if (isRefresh)
            {
                // 判断数组中是否有数据，有则转模型并加入数组，否则显示“已经全部加载完毕”
                if (arr.count > 0)
                {
                    // 直接把数组里边的字典的值转换为模型
                    self.dataArr = [NSMutableArray arrayWithArray:[WXZKeHuInfoModel objectArrayWithKeyValuesArray:arr]];
                    // 判断数组中的数据是否小于请求的固定条数，小于则显示“已经全部加载完毕”
                    if (arr.count < eachPage.integerValue)
                    {
                        // 显示“已经全部加载完毕”
                        [self.tableView.footer endRefreshingWithNoMoreData];
                        isMore = NO;
                    }
                }
                else
                {
                    // 显示“已经全部加载完毕”
                    [self.dataArr removeAllObjects];
                    [self.tableView.footer endRefreshingWithNoMoreData];
                    isMore = NO;
                }
            }
            else
            {
                // 加载更多
                // 判断是否有第n页的数据，有则加入数组，没有则显示“已经全部加载完毕”
                if (arr.count > 0)
                {
                    // 把再次请求的数据添加到数组中
                    [self.dataArr addObjectsFromArray:[WXZKeHuInfoModel objectArrayWithKeyValuesArray:arr]];
                }
                else
                {
                    // 显示“已经全部加载完毕”
                    [self.tableView.footer endRefreshingWithNoMoreData];
                    isMore = NO;
                }
            }
            [SVProgressHUD dismiss]; // 取消菊花
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:responseObject[@"msg"] maskType:SVProgressHUDMaskTypeBlack];
            if ([responseObject[@"msg"] isEqualToString:@"登录超时"])
            {
                [self goBackLoginPage]; // 回到登录页面
            }
        }
        [self.tableView reloadData]; // 重新加载tableView
        // 结束header刷新
        [self.tableView.header endRefreshing];
        if (isMore)
        {
            // 结束footer刷新
            [self.tableView.footer endRefreshing];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error)
    {
        [SVProgressHUD showErrorWithStatus:@"请求失败" maskType:SVProgressHUDMaskTypeBlack];
    }];
}

// 代理方法，返回弹窗的信息，并做相应请求操作
- (void)backScreeningType:(NSString *)type
{
    [self hideScreeningView]; // 隐藏弹窗
    currentPage = 1; // 请求页数
    isRefresh = YES; // 是否刷新
    shaixuanStr = type; // 筛选类型
    searchStr = @""; // 搜索条件
    _searchBar.text = @""; // 搜索框置空
    // 判断传回来的筛选类型是否等于“筛选”，等于则传空参数
    if ([type isEqualToString:@"筛选"])
    {
        shaixuanStr = @""; // 置为空
    }
    // 重新布局导航栏左侧按钮的frame
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,WXZ_SystemFont(18),NSFontAttributeName, nil];
    CGRect rect = [type boundingRectWithSize:CGSizeMake(120, 44) options:NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine attributes:dic context:nil]; // 计算leftTitleLabel的宽度
    _leftView.frame = CGRectMake(0, 0, rect.size.width+14, 44);
    _leftTitleLabel.frame = CGRectMake(0, 0, _leftView.width-14, _leftView.height);
    _leftImgView.frame = CGRectMake(_leftView.width-14, (_leftView.height-8)/2, 14, 8);
    _leftTitleLabel.text = type; // title赋值
    [_leftView setNeedsUpdateConstraints]; // 更新约束
    
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
    // 重新布局导航栏左侧按钮的frame
    _leftView.size = CGSizeMake(52, 44);
    _leftTitleLabel.size = CGSizeMake(38, 44);
    _leftImgView.frame = CGRectMake(_leftView.width-14, (_leftView.height-8)/2, 14, 8);
    _leftTitleLabel.text = @"筛选";
    [_leftView setNeedsUpdateConstraints]; // 更新约束
    // 客户列表数据请求（所有的数据）
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
    return self.dataArr.count+1; // 返回section
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1; // 返回行
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        // 虚拟的cell，为了配合添加新客户hederView用的
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
        // 客户列表信息cell
        WXZKeHuListCell *keHuInfoCell = [tableView dequeueReusableCellWithIdentifier:@"KeHuInfoCell"];
        if (!keHuInfoCell)
        {
            keHuInfoCell = [WXZKeHuListCell initListCell];
            keHuInfoCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        keHuInfoCell.controller = self; // 权限
        keHuInfoCell.keHuInfoModel = self.dataArr[indexPath.section-1]; // cell赋值
        
        return keHuInfoCell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self hideScreeningView]; // 选择列表隐藏弹窗
    // push到客户详情页
    WXZCustomerDetailsVC *customerDetailsVC = [[WXZCustomerDetailsVC alloc] init];
    self.kehuInfoModel = self.dataArr[indexPath.section-1]; // 取出点击行的数据
    customerDetailsVC.customerId = self.kehuInfoModel.ID; // 把点击行的id传到详情页
    [self.navigationController pushViewController:customerDetailsVC animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        _headerView = [WXZKHListHeaderView initListHeaderView]; // header背景 view
        // 给headerView添加轻击手势
        UITapGestureRecognizer *headerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addNewKeHuAction:)];
        [_headerView addGestureRecognizer:headerTap];
        
        return _headerView;
    }
    else
    {
        return nil;
    }
}

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
    return 0.01f; // 返回footer的高度
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return 0.0f;
    }
    return [self calculateHeightOfRow:self.dataArr[indexPath.section-1]]; // 返回计算的行高
}

// 计算行高
- (NSInteger)calculateHeightOfRow:(WXZKeHuInfoModel *)model
{
    NSString *yixiangStr = model.YiXiang; // 取出购房意向的内容
    NSInteger yixiang = 0; // 展示购房意向的label的高度
    // 判断是否有购房意向内容，有则购房意向的高度为18，否则为0
    if (![WXZChectObject checkWhetherStringIsEmpty:yixiangStr])
    {
        yixiang = 18; // 购房意向的高度为18
    }
    
    return 20 + 20 + 12 + yixiang + 31; // 返回行高(距上边＋姓名的高＋姓名和意向的间距＋意向的高＋footerview的高)
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self hideScreeningView]; // 将要开始滑动隐藏弹窗
    [_searchBar resignFirstResponder]; // 搜索框键盘失去第一响应
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.screeningView.frame = CGRectMake(0, self.tableView.contentOffset.y, WXZ_ScreenWidth, WXZ_ScreenHeight-64); // 滑动结束重新调整筛选弹窗的frame
}

#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [self hideScreeningView]; // 隐藏弹窗
    return YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    searchStr = searchBar.text; // 搜索条件内容赋值
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder]; // 搜索框键盘失去第一响应
    [self queDing_click]; // 调用搜索请求方法
}

#pragma - mark 数据请求刷新、加载
/**
 * 添加刷新控件
 */
- (void)setupRefresh
{
    // 添加下拉刷新
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshKeHuInfo)];
    // 添加自动上拉加载
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreKeHuInfo)];
    //    self.tableView.footer.hidden = YES;
}

// 客户列表刷新数据请求方法
- (void)refreshKeHuInfo
{
    // 客户列表刷新数据请求
    currentPage = 1; // 当前请求页数
    isRefresh = YES; // 是否刷新
    isMore = YES; // 是否有更多数据
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    [self keHuListRequest:currentPage numberEachPage:eachPage handsomeChooseCategory:shaixuanStr handsomeChooseConditions:searchStr]; // 刷新数据请求
}

// 客户列表加载更多数据请求方法
- (void)loadMoreKeHuInfo
{
    // 客户列表加载更多数据请求
    isRefresh = NO; // 是否刷新
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack]; // 显示菊花
    [self keHuListRequest:++currentPage numberEachPage:eachPage handsomeChooseCategory:shaixuanStr handsomeChooseConditions:searchStr]; // 加载更多数据请求,页数自增
}

// 添加新客户事件（轻击手势）
- (void)addNewKeHuAction:(id)sender
{
    [_searchBar resignFirstResponder]; // 搜索框键盘失去第一响应
    // push到添加新客户页
    WXZAddCustomerVC *addCustomerVC = [[WXZAddCustomerVC alloc] init];
    addCustomerVC.isModifyCustomerInfo = NO; // 是否可以修改客户信息值
    addCustomerVC.titleStr = @"添加客户"; // navigation的title值
    addCustomerVC.isKeHuDetail = NO; // 是否为客户详情页
    [self.navigationController pushViewController:addCustomerVC animated:YES];
}

#pragma mark - Navigation BarButtonItem Click Event
// 右侧搜索确定按钮点击事件
- (void)queDing_click
{
    [self.searchBar resignFirstResponder]; // 搜索框键盘失去第一响应
    [self hideScreeningView]; // 隐藏弹窗方法
    // 搜索客户列表请求
    currentPage = 1; // 当前请求页数
    isRefresh = YES; // 是否刷新
    searchStr = self.searchBar.text; // 搜索条件内容
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack]; // 显示菊花
    [self keHuListRequest:currentPage numberEachPage:eachPage handsomeChooseCategory:shaixuanStr handsomeChooseConditions:searchStr]; // 搜索客户列表请求
}

// 左侧筛选按钮点击事件
- (void)quDu_click
{
    [self.searchBar resignFirstResponder]; // 搜索框键盘失去第一响应
    // 判断是否隐藏弹窗
    if (isTanChuangHiden)
    {
        [self hideScreeningView]; // 隐藏弹窗方法
    }
    else
    {
        // 显示视图
        if (_screeningView == nil)
        {
            // 初始化筛选弹窗view
            _screeningView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([WXZScreeningView class]) owner:self options:nil] lastObject];
            _screeningView.frame = CGRectMake(0, self.tableView.contentOffset.y, WXZ_ScreenWidth, WXZ_ScreenHeight-64);
            _screeningView.backgroundColor = [UIColor whiteColor];
            [self.view addSubview:_screeningView];
        }
        
        _screeningView.frame = CGRectMake(0, self.tableView.contentOffset.y, WXZ_ScreenWidth, WXZ_ScreenHeight-64); // 实时修改筛选弹窗的frame
        _screeningView.dataArr = self.shaixuanArr; // 把弹窗数据传给view进行显示
        _screeningView.backScreeningTypeDelegate = self; // 设置返回点击的弹窗数据
        _screeningView.hidden = NO; // 不隐藏弹窗
        self.tableView.scrollEnabled = NO; // tableView不可滑动
        self.headerView.hidden = YES; // 隐藏section的headerView
        isTanChuangHiden = YES; // 改变是否隐藏弹窗的值
    }
}

// 隐藏筛选视图
- (void)hideScreeningView
{
    [self.screeningView setHidden:YES]; // 隐藏弹窗
    self.tableView.scrollEnabled = YES; // tableView可滑动
    self.headerView.hidden = NO; // 不隐藏section的headerView
    isTanChuangHiden = NO; // 改变是否隐藏弹窗的值
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
