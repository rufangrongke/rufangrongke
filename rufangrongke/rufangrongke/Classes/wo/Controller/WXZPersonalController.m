//
//  WXZPersonalController.m
//  rufangrongke
//
//  Created by 儒房融科 on 15/10/24.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

#import "WXZPersonalController.h"
#import "WXZPersonalDataCell.h"
#import "WXZPersonalData2Cell.h"
#import <UIImageView+WebCache.h>
#import "WXZPersonalDeclarationVC.h"
#import "WXZPersonalCertificationVC.h"
#import "WXZPersonalCityVC.h"
#import "WXZPersonalStoreVC.h"
#import "WXZPersonalPhoneVC.h"
#import "WXZPersonalInfoVC.h"

@interface WXZPersonalController () <UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic,strong) NSMutableDictionary *dataArr;
@property (nonatomic,strong) UIImageView *imageView;

@property (nonatomic,strong) NSDictionary *personalInfoDic;

@end

@implementation WXZPersonalController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // 视图整体背景色
    self.view.backgroundColor = WXZRGBColor(246, 246, 246);
    // 添加标题，设置标题的颜色和字号
    self.navigationItem.title = @"个人资料";
    
    // 获取缓存数据
    self.personalInfoDic = [self localUserInfo];
    
    // 设置tableview 的数据源和代理
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    
    // 注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePersonalData:) name:@"UpdatePersonalDataPage" object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    // 隐藏导航navigation
    self.navigationController.navigationBarHidden = NO;
    
    [self.myTableView reloadData];
}

// 刷新数据
- (void)updatePersonalData:(NSNotification *)noti
{
    [self loginRequest:^(id result) {
        // 重新获取缓存数据
        self.personalInfoDic = result;
        [self.myTableView reloadData];
    }];
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
        
        [personalDataCell headBorder]; // 分割线
        [personalDataCell updateHead:self.personalInfoDic[@"TouXiang"]]; // 刷新头像
        
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
            [personalData2Cell updatePersonalDataInfo:indexPath.row data:self.personalInfoDic];
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
        UIActionSheet *photosSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册", nil];
        [photosSheet showInView:self.view];
    }
    else if (indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 9)
    {
        WXZPersonalInfoVC *personalInfo = [[WXZPersonalInfoVC alloc] init];
        if (indexPath.row == 1)
        {
            personalInfo.whichController = @"ModifyPersonalName";
            personalInfo.titleStr = @"修改姓名";
            personalInfo.nameOrSex = self.personalInfoDic[@"TrueName"];
        }
        else if (indexPath.row == 2)
        {
            personalInfo.whichController = @"ModifyPersonalSex";
            personalInfo.titleStr = @"修改性别";
            personalInfo.nameOrSex = self.personalInfoDic[@"Sex"];
        }
        else
        {
            personalInfo.whichController = @"ModifyPersonalPwd";
            personalInfo.titleStr = @"修改密码";
        }
        [self.navigationController pushViewController:personalInfo animated:YES];
    }
    else if (indexPath.row == 4)
    {
        WXZPersonalDeclarationVC *declarationVC = [[WXZPersonalDeclarationVC alloc] init];
        declarationVC.declarationContent = self.personalInfoDic[@"XuanYan"];
        [self.navigationController pushViewController:declarationVC animated:YES];
    }
    else if (indexPath.row == 5)
    {
        WXZPersonalCertificationVC *certificationVC = [[WXZPersonalCertificationVC alloc] init];
        certificationVC.certificationTitle = self.personalInfoDic[@"TrueName"];
        [self.navigationController pushViewController:certificationVC animated:YES];
    }
    else if (indexPath.row == 6)
    {
        WXZPersonalCityVC *cityVC = [[WXZPersonalCityVC alloc] init];
        cityVC.currentCity = self.personalInfoDic[@"cityName"];
        [self.navigationController pushViewController:cityVC animated:YES];
    }
    else if (indexPath.row == 7)
    {
        WXZPersonalStoreVC *storeVC = [[WXZPersonalStoreVC alloc] init];
        storeVC.storeName = self.personalInfoDic[@"LtName"];
        [self.navigationController pushViewController:storeVC animated:YES];
    }
    else if (indexPath.row == 8)
    {
        WXZPersonalPhoneVC *phoneVC = [[WXZPersonalPhoneVC alloc] init];
        phoneVC.phone = self.personalInfoDic[@"Mobile"];
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

- (void)logOutAction:(id)sender
{
    NSLog(@"退出登录");
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

#pragma UIImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
//    http://www.lvtao.net/ios/509.html
    //http://blog.csdn.net/justinjing0612/article/details/8751269
//    http://www.swifthumb.com/thread-2555-1-1.html
//    http://www.cnblogs.com/skyblue/archive/2013/05/08/3067108.html
//    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(__bridge NSString *)kUTTypeImage])
//    {
//        
//    }
    
    
    
    UIImage *img = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSData *data = UIImageJPEGRepresentation(img, 1.0f);
    
    UIImageView *imgs = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 30, 30)];
    imgs.image = img;
    [self.view addSubview:imgs];
    
    [self.myTableView reloadData]; // 刷新tableview
    
    [picker dismissViewControllerAnimated:YES completion:nil]; // 取消
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil]; // 取消
}

// 返回button 事件
- (void)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
