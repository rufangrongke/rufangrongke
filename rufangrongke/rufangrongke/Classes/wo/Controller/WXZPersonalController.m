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
#import "WXZPersonalNameVC.h"
#import "WXZPersonalSexVC.h"

@interface WXZPersonalController () <UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic,strong) NSMutableDictionary *dataArr;
@property (nonatomic,strong) UIImageView *imageView;

@end

@implementation WXZPersonalController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // 视图整体背景色
    self.view.backgroundColor = WXZRGBColor(246, 246, 246);
    // 添加标题，设置标题的颜色和字号
    self.navigationItem.title = @"个人资料";
    NSDictionary *titleAttributeDic = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:WXZ_SystemFont(17)};
    [self.navigationController.navigationBar setTitleTextAttributes:titleAttributeDic];
    
    // 初始化数据源
    self.dataArr = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"",@"pName",@"",@"pSex",@"",@"pWorkingTime",@"",@"pDeclaration",@"",@"pCertification",@"",@"pCity",@"",@"pStore",@"",@"pPhone",@"",@"pResetPwd", nil];
    [self sourceData]; //
    
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
    
    // 返回按钮
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 40, 44);
    [leftBtn setImage:[UIImage imageNamed:@"kh_rjt"] forState:UIControlStateNormal];
    leftBtn.transform = CGAffineTransformMakeRotation(M_PI); // 图片旋转d
    [leftBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)]; // 标题向左侧偏移
    [leftBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
}

// 初始化数据源
- (void)sourceData
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"pName"])
    {
        [self.dataArr setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"pName"] forKey:@"pName"];
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"pSex"])
    {
        [self.dataArr setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"pSex"] forKey:@"pSex"];
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"pWorkingTime"])
    {
        [self.dataArr setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"pWorkingTime"] forKey:@"pWorkingTime"];
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"pDeclaration"])
    {
        [self.dataArr setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"pDeclaration"] forKey:@"pDeclaration"];
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"pCertification"])
    {
        [self.dataArr setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"pCertification"] forKey:@"pCertification"];
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"pCity"])
    {
        [self.dataArr setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"pCity"] forKey:@"pCity"];
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"pStore"])
    {
        [self.dataArr setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"pStore"] forKey:@"pStore"];
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"pPhone"])
    {
        [self.dataArr setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"pPhone"] forKey:@"pPhone"];
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"pResetPwd"])
    {
        [self.dataArr setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"pResetPwd"] forKey:@"pResetPwd"];
    }
}

// 刷新数据
- (void)updatePersonalData:(NSNotification *)noti
{
    [self sourceData];
    [self.myTableView reloadData];
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
        [personalDataCell updateHead]; // 刷新头像
        
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
            [personalData2Cell personalDataInfo:indexPath.row data:self.dataArr];
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
    else if (indexPath.row == 1)
    {
        [self.navigationController pushViewController:[[WXZPersonalNameVC alloc] init] animated:YES];
    }
    else if (indexPath.row == 2)
    {
        [self.navigationController pushViewController:[[WXZPersonalSexVC alloc] init] animated:YES];
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
//    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(__bridge NSString *)kUTTypeImage])
//    {
//        
//    }
    
    UIImage *img = [info objectForKey:UIImagePickerControllerOriginalImage];
    // 缓存
    [[NSUserDefaults standardUserDefaults] setObject:UIImageJPEGRepresentation(img, 1) forKey:@"pHead"];
    [self.myTableView reloadData]; // 刷新tableview
    
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
