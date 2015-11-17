//
//  WXZPersonalController.m
//  rufangrongke
//
//  Created by 儒房融科 on 15/10/24.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

#import "WXZPersonalController.h"
#import <UIImageView+WebCache.h>
#import "AFNetworking.h"
#import <SVProgressHUD.h>
#import "SRMonthPicker.h"
#import "WXZPersonalDataCell.h"
#import "WXZPersonalData2Cell.h"
#import "WXZPersonalDeclarationVC.h"
#import "WXZPersonalCertificationVC.h"
#import "WXZPersonalCityVC.h"
#import "WXZPersonalStoreVC.h"
#import "WXZModifyPhoneVC.h"
#import "WXZPersonalInfoVC.h"
#import "WXZWorkingTimeView.h"
#import "WXZLoginController.h"
#import "WXZNavController.h"

@interface WXZPersonalController () <UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,SRMonthPickerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@property (nonatomic,strong) WXZWorkingTimeView *workingTimeView; // 从业时间view

@property (nonatomic,strong) NSDictionary *personalInfoDic; // 获取登录的缓存数据（即个人资料信息）

@end

static BOOL isRefreshWo;

@implementation WXZPersonalController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // 视图整体背景色
    self.view.backgroundColor = WXZRGBColor(246, 246, 246);
    // 添加标题，设置标题的颜色和字号
    self.navigationItem.title = @"个人资料";
    
    // 设置tableview 的数据源和代理
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    
    isRefreshWo = NO;
    
    // 注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePersonalData:) name:@"UpdatePersonalDataPage" object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    // 隐藏导航navigation
    self.navigationController.navigationBarHidden = NO;
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setImage:[UIImage imageNamed:@"jt"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"jt"] forState:UIControlStateHighlighted];
    leftButton.size = CGSizeMake(70, 30);
    // 让按钮内部的所有内容左对齐
    leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    // 让按钮的内容往左边偏移10
    leftButton.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    [leftButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    // 修改导航栏左边的item
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
//    [self.myTableView reloadData]; // 刷新列表
}

#pragma mark - 个人资料数据请求
- (void)personalDataRequest:(BOOL)isNotification
{
    if (isNotification)
    {
        // 显示菊花
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    }
    
    [self loginRequest:^(id result) {
        if (![result isEqual:@"请求失败"])
        {
            NSDictionary *dic = (NSDictionary *)result;
            // 刷新模型
            self.woInfoModel = [WXZWoInfoModel objectWithKeyValues:dic];
            [self.myTableView reloadData]; // 刷新
            [SVProgressHUD dismiss]; // 结束菊花
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:result];
        }
        isRefreshWo = YES;
    }];
}

// 通知事件（刷新数据）
- (void)updatePersonalData:(NSNotification *)noti
{
    [self personalDataRequest:YES]; // 个人资料数据请求
}

#pragma mark - UITableViewDataSource/Delegate Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 11;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        // 头像
        WXZPersonalDataCell *personalDataCell = [tableView dequeueReusableCellWithIdentifier:@"PersonalDataCell"];
        if (!personalDataCell)
        {
            personalDataCell = [WXZPersonalDataCell initPersonalDataCell];
        }
        
        personalDataCell.woInfoModel = self.woInfoModel;
        
        return personalDataCell;
    }
    else
    {
        // 个人资料其他信息
        WXZPersonalData2Cell *personalData2Cell = [tableView dequeueReusableCellWithIdentifier:@"PersonalDataCell2"];
        if (!personalData2Cell)
        {
            personalData2Cell = [WXZPersonalData2Cell initPersonalData2Cell];
        }
        
        if (indexPath.row < 10)
        {
            // 初始化信息
            [personalData2Cell personalDataInfo:indexPath.row];
            [personalData2Cell updatePersonalDataInfo:indexPath.row data:self.woInfoModel];
        }
        else
        {
            // 退出登录事件
            [personalData2Cell buttonWithTarget:self action:@selector(logOutAction:)];
        }
        
        return personalData2Cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld",(long)indexPath.row);
    if (indexPath.row == 0)
    {
        // 头像 - 添加UIActionSheet
        UIActionSheet *photosSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册", nil];
        [photosSheet showInView:self.view];
    }
    else if (indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 9)
    {
        WXZPersonalInfoVC *personalInfo = [[WXZPersonalInfoVC alloc] init];
        if (indexPath.row == 1)
        {
            // 修改姓名
            personalInfo.whichController = @"ModifyPersonalName";
            personalInfo.titleStr = @"修改姓名";
            personalInfo.nameOrSex = self.woInfoModel.TrueName;
        }
        else if (indexPath.row == 2)
        {
            // 修改性别
            personalInfo.whichController = @"ModifyPersonalSex";
            personalInfo.titleStr = @"修改性别";
            personalInfo.nameOrSex = self.woInfoModel.Sex;
        }
        else
        {
            // 修改密码
            personalInfo.whichController = @"ModifyPersonalPwd";
            personalInfo.titleStr = @"修改密码";
        }
        [self.navigationController pushViewController:personalInfo animated:YES];
    }
    else if (indexPath.row == 3)
    {
        // 从业时间
        _workingTimeView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([WXZWorkingTimeView class]) owner:nil options:nil].lastObject;
        _workingTimeView.frame = CGRectMake(0, 0, WXZ_ScreenWidth, WXZ_ScreenHeight); // 设置view的位置
        [self.view addSubview:_workingTimeView];
        
        [self initWorkingTime]; // 调用初始化方法
    }
    else if (indexPath.row == 4)
    {
        // 服务宣言
        WXZPersonalDeclarationVC *declarationVC = [[WXZPersonalDeclarationVC alloc] init];
        declarationVC.declarationContent = self.woInfoModel.XuanYan;
        [self.navigationController pushViewController:declarationVC animated:YES];
    }
    else if (indexPath.row == 5)
    {
        // 实名认证
        WXZPersonalCertificationVC *certificationVC = [[WXZPersonalCertificationVC alloc] init];
        certificationVC.woInfoModel = self.woInfoModel;
        [self.navigationController pushViewController:certificationVC animated:YES];
    }
    else if (indexPath.row == 6)
    {
        // 设置城市
        WXZPersonalCityVC *cityVC = [[WXZPersonalCityVC alloc] init];
        cityVC.currentCity = self.woInfoModel.cityName;
        [self.navigationController pushViewController:cityVC animated:YES];
    }
    else if (indexPath.row == 7)
    {
        // 绑定门店
        WXZPersonalStoreVC *storeVC = [[WXZPersonalStoreVC alloc] init];
        storeVC.storeId = [NSString stringWithFormat:@"%@",self.woInfoModel.LtCid];
        [self.navigationController pushViewController:storeVC animated:YES];
    }
    else if (indexPath.row == 8)
    {
        // 修改手机号
        WXZModifyPhoneVC *phoneVC = [[WXZModifyPhoneVC alloc] init];
        phoneVC.phone = self.woInfoModel.Mobile;
        [self.navigationController pushViewController:phoneVC animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        return 75;
    }
    else
    {
        return 55;
    }
}

#pragma UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
        {
            // 判断相机是否可用
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                imagePicker.delegate = self; // 设置代理
                imagePicker.allowsEditing = YES; // 设置可以编辑
                imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera; // 设置源
                imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto; // 设定图片选取器的摄像头捕获模式
                [self presentViewController:imagePicker animated:YES completion:nil]; // 开启拾取器界面
            }
            else
            {
                NSLog(@"相机不可用!");
            }
        }
            break;
        case 1:
        {
            // 判断相簿是否可用
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
            {
                UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                imagePicker.delegate = self; // 设置代理
                imagePicker.allowsEditing = YES; // 设置可以编辑
                imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary; // 设置源
                [self presentViewController:imagePicker animated:YES completion:nil]; // 开启拾取器界面
            }
            else
            {
                NSLog(@"相簿不可用！");
            }
        }
            break;
            
        default:
            break;
    }
}

#pragma UIImagePickerController Delegate (相机和拍照)
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:@"public.image"])
    {
        // 如果是则从info字典参数中获取原图片
        UIImage *img = [info objectForKey:UIImagePickerControllerOriginalImage];
        //如果图片选取器的源类型为摄像头
        if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
            //将图片存入系统相册
            UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil);
        }
        
        // 图片压缩
        NSData *imgData = UIImageJPEGRepresentation(img, 0.4f);
        
        // 添加转圈
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
        [self upLoadHead:imgData]; // 请求
    }
    else
    {
        NSLog(@"不是图片");
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil]; // 取消
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil]; // 取消
}

#pragma mark - 上传头像请求
- (void)upLoadHead:(NSData *)head
{
    NSString *url = [OutNetBaseURL stringByAppendingString:shangchuangtupian];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"TouXiang" forKey:@"lx"];
    [params setObject:head forKey:@"File"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
    {
        NSString *fileName = [NSString stringWithFormat:@"%@.png", @"customerHead"];
        
        [formData appendPartWithFileData:head name:@"headFile" fileName:fileName mimeType:@"image/png"];
        
    } success:^(NSURLSessionDataTask *task, id responseObject)
    {
        if ([responseObject[@"ok"] integerValue] == 1)
        {
            [SVProgressHUD showSuccessWithStatus:responseObject[@"msg"]];
            // 刷新界面
            [self personalDataRequest:YES]; // 个人资料数据请求
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:responseObject[@"msg"]];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"请求失败"];
//        [SVProgressHUD dismiss]; // 取消菊花
    }];
}

#pragma mark - WorkingTime Start
- (void)initWorkingTime
{
    if ([UIScreen mainScreen].bounds.size.width == 320)
    {
        _workingTimeView.bgView.frame = CGRectMake(12, 40, 320-24, 320-24+1);
    }
    
    // 遵循协议
    _workingTimeView.timePickerView.monthPickerDelegate = self;
    
    // 设置年的范围
    NSString *maximunYearStr = [self formatDate:[NSDate date] dateFormat:@"yyyy"]; // 获取当前年
    _workingTimeView.timePickerView.maximumYear = [NSNumber numberWithInt:maximunYearStr.intValue]; // 设置年的最大值
    _workingTimeView.timePickerView.minimumYear = @1980; // 设置年的最小值
    _workingTimeView.timePickerView.yearFirst = YES; // 今年是否显示在前面
    
    // 设置显示年月的text的宽度
    if ([UIScreen mainScreen].bounds.size.width == 320)
    {
        _workingTimeView.timePickerView.monthWidth = 120.f;
        _workingTimeView.timePickerView.yearWidth = 70.f;
    }
    else if (WXZ_ScreenWidth == 414)
    {
        _workingTimeView.timePickerView.monthWidth = 130.f;
        _workingTimeView.timePickerView.yearWidth = 81.f;
    }
    else
    {
        _workingTimeView.timePickerView.monthWidth = 138.f;
        _workingTimeView.timePickerView.yearWidth = 71.f;
    }
    
    // 添加事件
    [_workingTimeView.determineBtn addTarget:self action:@selector(cancelOrDetrmineAction:) forControlEvents:UIControlEventTouchUpInside];
    [_workingTimeView.cancelBtn addTarget:self action:@selector(cancelOrDetrmineAction:) forControlEvents:UIControlEventTouchUpInside];
}

// 日期格式化方法
- (NSString*)formatDate:(NSDate *)date dateFormat:(NSString *)format
{
    // A convenience method that formats the date in Year/Month-Year format
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = format;
    return [formatter stringFromDate:date];
}

// 取消/确定按钮单击事件
- (void)cancelOrDetrmineAction:(UIButton *)sender
{
    if (sender.tag == 100017)
    {
        // All this GCD stuff is here so that the label change on -[self monthPickerWillChangeDate] will be visible
        dispatch_queue_t delayQueue = dispatch_queue_create("com.simonrice.SRMonthPickerExample.DelayQueue", 0);
        
        dispatch_async(delayQueue, ^{
            // Wait 1 second
            sleep(1);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                // 显示菊花
                [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
                [self workingTimeRequest:[self formatDate:_workingTimeView.timePickerView.date dateFormat:@"yyyy-MM-dd"]]; // 修改从业时间请求
            });
        });
    }
    else
    {
        [self removeWorkingTimeView]; // 从父view移除该view
    }
}

// 从父view移除该view
- (void)removeWorkingTimeView
{
    if (_workingTimeView)
    {
        [_workingTimeView removeFromSuperview];
    }
}

#pragma mark - WorkingTime Request
- (void)workingTimeRequest:(NSString *)date
{
    NSString *url = [OutNetBaseURL stringByAppendingString:jinjirenziliaoxiugai];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@"CongYeTime" forKey:@"lN"]; // 修改的属性名
    [param setObject:date forKey:@"lD"]; // 从业时间（yyyy-MM-dd）nsdate形式
    
    [[AFHTTPSessionManager manager] POST:url parameters:param success:^(NSURLSessionDataTask *task, id responseObject)
    {
        if ([responseObject[@"ok"] integerValue] == 1)
        {
            [self removeWorkingTimeView]; // 把view从父view上移除
            [SVProgressHUD showSuccessWithStatus:responseObject[@"msg"]];
            // 刷新界面
            [self personalDataRequest:YES]; // 个人资料数据请求
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:responseObject[@"msg"]];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"请求失败"];
//        [SVProgressHUD dismiss]; // 
    }];
}
#pragma mark - WorkingTime End

// 退出登录
- (void)logOutAction:(id)sender
{
//    NSLog(@"退出登录");
    // 跳到登录页面
    WXZLoginController *loginController = [[WXZLoginController alloc]init];
    WXZNavController *nav = [[WXZNavController alloc] initWithRootViewController:loginController];
    [[[[UIApplication sharedApplication] delegate] window] setRootViewController:nav];
}

// 返回button 事件
- (void)backAction:(id)sender
{
    if (isRefreshWo)
    {
        // 发送通知，更新“我”界面信息
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateWoPage" object:nil];
        
        [self removeWorkingTimeView]; // 从父view移除该view
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self]; // 取消所有网络请求
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
