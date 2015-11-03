//
//  WXZPersonalCityVC.m
//  rufangrongke
//
//  Created by 儒房融科 on 15/10/26.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

#import "WXZPersonalCityVC.h"
#import "AFNetworking.h"
#import "WXZChectObject.h"
#import "WXZiMuTableObject.h"
#import <SVProgressHUD.h>
#import "WXZPersonalCityCell.h"
#import "WXZCitySectionHeader.h"

@interface WXZPersonalCityVC () <UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate> // PassCityNameDelegate
{
    NSTimer *_removeIndexLargeTitle; // 定时器
}

@property (weak, nonatomic) IBOutlet UISearchBar *citySearchBar; // 搜索框

@property (weak, nonatomic) IBOutlet UITableView *myTableView; // 

@property (weak, nonatomic) IBOutlet UILabel *currentCityLabel; // 当前城市
@property (weak, nonatomic) IBOutlet UILabel *largeIndexZimu; // 字幕

@property (nonatomic,strong) NSMutableArray *citysArr; // 总体数据
@property (nonatomic,strong) NSArray *ziMuAllKeys; // tableview上显示的索引
@property (nonatomic,strong) NSArray *indexZimuAllKeys; // 索引条显示的索引

@property (nonatomic,strong) NSMutableDictionary *sourceDic; // 存储城市和城市对应id
@property (nonatomic,strong) NSMutableDictionary *allCitysDic; // 将索引和内容对应的存储起来，方便显示和查询

@end

static NSString *selectedCurrentCityName; // 存储已选择的当前城市名

@implementation WXZPersonalCityVC

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // 初始化
        self.citysArr=[[NSMutableArray alloc] init];
        self.ziMuAllKeys=[[NSArray alloc] init];
        self.indexZimuAllKeys=[[NSArray alloc] init];
        
        self.sourceDic = [NSMutableDictionary dictionary];
        self.allCitysDic=[[NSMutableDictionary alloc] init];
    }
    return self;
}

//去掉tableview多余的分割线
- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

/**
 *  计算tableview索引
 */
- (void)tableviewZimuXuHao:(NSArray *)dataSou
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        self.allCitysDic = [[WXZiMuTableObject parxuInit] sortedArrayWithPinYinDic:dataSou];
        self.ziMuAllKeys = [[self.allCitysDic allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2)
        {
            return [obj1 compare:obj2 options:NSNumericSearch];
        }];
        
        self.indexZimuAllKeys=[[[[WXZiMuTableObject parxuInit] sortedArrayWithPinYinDic:self.citysArr] allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2)
        {
           return [obj1 compare:obj2 options:NSNumericSearch];
        }];
        // 返回主线程，刷新列表
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.myTableView reloadData];
        });
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // 视图整体背景色
    self.view.backgroundColor = WXZRGBColor(246, 246, 246);
    // 添加标题，设置标题的颜色和字号
    self.navigationItem.title = @"设定城市";
    
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    
    //改变tableview索引的背景颜色
    self.myTableView.sectionIndexColor = WXZRGBColor(27, 28, 27); // 设置索引的字体颜色
    self.myTableView.sectionIndexBackgroundColor=[UIColor clearColor];//设置索引背景色
    self.myTableView.sectionHeaderHeight = 30.f; // 设置头的高
    
    selectedCurrentCityName = @""; // 初始值为空
    _currentCityLabel.text = self.currentCity; // 赋值
    
    // 显示菊花
    [SVProgressHUD showWithStatus:@"正在加载..." maskType:SVProgressHUDMaskTypeBlack];
    // 加载城市列表
    [self cityListRequest];
    
    // 设置字幕的圆角
    self.largeIndexZimu.layer.cornerRadius = 6;
    self.largeIndexZimu.layer.masksToBounds = YES;
    self.largeIndexZimu.hidden = YES;
    
    // 设置searchbar无文字时，return键可点击
    self.citySearchBar.enablesReturnKeyAutomatically = NO;
    self.citySearchBar.delegate = self;
}

#pragma mark - Data Request
// 城市列表请求
- (void)cityListRequest
{
    // 请求链接
    NSString *cityUrlStr = [OutNetBaseURL stringByAppendingString:chengshileibiao];
    
    [[AFHTTPSessionManager manager] GET:cityUrlStr parameters:nil success:^(NSURLSessionDataTask *task, id responseObject)
     {
         NSArray *arr = responseObject[@"citys"];
         if (arr.count > 0)
         {
             for (int i=0; i<arr.count; i++)
             {
                 [self.citysArr addObject:arr[i][@"city"]];
                 [self.sourceDic setObject:arr[i][@"id"] forKey:arr[i][@"city"]];
             }
             [self tableviewZimuXuHao:self.citysArr];
             [self.myTableView reloadData];
             if(self.citysArr.count > 0)
             {
                 [self setExtraCellLineHidden:self.myTableView];
             }
             else
             {
                 self.myTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
             }
         }
         else
         {
             [SVProgressHUD showErrorWithStatus:@"暂无数据"];
         }
         [SVProgressHUD dismiss]; // 取消菊花
         
     } failure:^(NSURLSessionDataTask *task, NSError *error) {
         [SVProgressHUD showErrorWithStatus:@"请求失败"];
         [SVProgressHUD dismiss]; // 取消菊花
     }];
}

// 修改城市请求
- (void)modifyRequestWithParameter:(NSString *)param1
{
    NSString *nameUrlStr = [OutNetBaseURL stringByAppendingString:jinjirenziliaoxiugai];
    
//    //把汉字进行UTF8转码
//    NSString *utfText=(NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)param1, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8));
    
    NSString *cityId = self.sourceDic[param1];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@"cityid" forKey:@"lN"]; // 属性名
    [param setObject:cityId forKey:@"lD"]; // 城市id
    
    [[AFHTTPSessionManager manager] POST:nameUrlStr parameters:param success:^(NSURLSessionDataTask *task, id responseObject)
     {
         if ([responseObject[@"ok"] integerValue] == 1)
         {
             NSLog(@"%@",responseObject[@"msg"]);
             // 发送通知
             [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdatePersonalDataPage" object:nil];
             [self.navigationController popViewControllerAnimated:YES];
         }
         else
         {
             NSLog(@"%@",responseObject[@"msg"]);
         }
         
     } failure:^(NSURLSessionDataTask *task, NSError *error) {
         
     }];
}

#pragma mark - UITableViewDataSource/UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.ziMuAllKeys.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.allCitysDic objectForKey:[self.ziMuAllKeys objectAtIndex:section]] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WXZPersonalCityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CityCell"];
    if (!cell)
    {
        cell = [WXZPersonalCityCell initCityCell];
    }
    
    [cell showContentCell:[[self.allCitysDic objectForKey:[self.ziMuAllKeys objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row]];
    
    return cell;
}

// 选择行
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    [self.cityDelegate passCityNames:[[self.allCitysDic objectForKey:[self.ziMuAllKeys objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row]]; // 选中传给上一页
    selectedCurrentCityName = [[self.allCitysDic objectForKey:[self.ziMuAllKeys objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    
    // 显示菊花
    [SVProgressHUD showWithStatus:@"请稍后..." maskType:SVProgressHUDMaskTypeBlack];
    [self modifyRequestWithParameter:selectedCurrentCityName]; // 修改城市数据请求
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    return [self.ziMuAllKeys objectAtIndex:section]; // 返回每个索引的内容
//}

// 自定义headerView
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    WXZCitySectionHeader *sectionHeaderView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([WXZCitySectionHeader class]) owner:nil options:nil].lastObject;
    // 返回每个索引的内容
    sectionHeaderView.headerTitleLabel.text = [self.ziMuAllKeys objectAtIndex:section];
    
    return sectionHeaderView;
}

// tableview索引
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
//    return self.indexZimuAllKeys; // 索引的标题数组（有几个显示几个）
    return [NSArray arrayWithObjects:@"#",@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z", nil];
}

// 响应点击索引时的委托方法
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    _largeIndexZimu.hidden = NO; // 不隐藏索引放大控件
    _largeIndexZimu.text = title; // 显示放大的索引值
    
    // 索引放大，显示0.3秒后移除（添加定时器）
    _removeIndexLargeTitle = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(removeIndexLargeTarget) userInfo:nil repeats:NO];
    
    return index;
}

// 定时器事件
- (void)removeIndexLargeTarget
{
    _largeIndexZimu.hidden = YES; // 隐藏索引放大控件
}

#pragma mark - searchBarDelegate 随着文本的输入实时更新数据
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSString *searchString = [_citySearchBar text];
    // 文本为空显示所有数据
    if([searchString isEqualToString:@""])
    {
        [self tableviewZimuXuHao:_citysArr];
    }
    else // 根据搜索内容显示对应信息
    {
        NSMutableArray *_searchList = [[NSMutableArray alloc] init];
        
        // 输入文字搜索
        for (NSInteger i=0; i<_citysArr.count; i++)
        {
            NSString *name1 = _citysArr[i];
            if ([name1 rangeOfString:searchString].location != NSNotFound)
            {
                [_searchList addObject:_citysArr[i]];
            }
        }
        // 输入拼音搜索
        for (NSInteger i=0; i<_ziMuAllKeys.count; i++)
        {
            NSString *name2 = _ziMuAllKeys[i];
            if ([[name2 lowercaseString] rangeOfString:searchString].location != NSNotFound)
            {
                _searchList = [_allCitysDic objectForKey:[_ziMuAllKeys objectAtIndex:i]];
            }
        }
        
        [self tableviewZimuXuHao:_searchList];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder]; // 搜索框失去第一响应
}
#pragma end

// 轻击当前城市事件
- (IBAction)currentCityTapAction:(id)sender
{
    // 选择当前城市
    selectedCurrentCityName = self.currentCityLabel.text; // 赋值
    
    // 显示菊花
    [SVProgressHUD showWithStatus:@"请稍后..." maskType:SVProgressHUDMaskTypeBlack];
    [self modifyRequestWithParameter:selectedCurrentCityName]; // 修改城市数据请求
}

// touch事件，使搜索框失去第一响应事件
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_citySearchBar resignFirstResponder];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    //移除计时器
    [_removeIndexLargeTitle invalidate];
    _removeIndexLargeTitle=nil;
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