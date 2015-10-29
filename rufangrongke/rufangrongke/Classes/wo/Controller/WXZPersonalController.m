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
#import "AFNetworking.h"
#import "WXZPersonalDeclarationVC.h"
#import "WXZPersonalCertificationVC.h"
#import "WXZPersonalCityVC.h"
#import "WXZPersonalStoreVC.h"
#import "WXZPersonalPhoneVC.h"
#import "WXZPersonalInfoVC.h"
#import "WXZWorkingTimeView.h"

@interface WXZPersonalController () <UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) WXZWorkingTimeView *workingTimeView;

@property (nonatomic,strong) NSMutableDictionary *dataArr;
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
        // 头像
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
    else if (indexPath.row == 3)
    {
        _workingTimeView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([WXZWorkingTimeView class]) owner:nil options:nil].lastObject;
        _workingTimeView.frame = CGRectMake(0, 0, WXZ_ScreenWidth, WXZ_ScreenHeight);
        [self.view addSubview:_workingTimeView];
        
    }
    else if (indexPath.row == 4)
    {
        // 服务宣言
        WXZPersonalDeclarationVC *declarationVC = [[WXZPersonalDeclarationVC alloc] init];
        declarationVC.declarationContent = self.personalInfoDic[@"XuanYan"];
        [self.navigationController pushViewController:declarationVC animated:YES];
    }
    else if (indexPath.row == 5)
    {
        // 实名认证
        WXZPersonalCertificationVC *certificationVC = [[WXZPersonalCertificationVC alloc] init];
        certificationVC.certificationTitle = self.personalInfoDic[@"TrueName"];
        [self.navigationController pushViewController:certificationVC animated:YES];
    }
    else if (indexPath.row == 6)
    {
        // 设置城市
        WXZPersonalCityVC *cityVC = [[WXZPersonalCityVC alloc] init];
        cityVC.currentCity = self.personalInfoDic[@"cityName"];
        [self.navigationController pushViewController:cityVC animated:YES];
    }
    else if (indexPath.row == 7)
    {
        // 绑定门店
        WXZPersonalStoreVC *storeVC = [[WXZPersonalStoreVC alloc] init];
        storeVC.storeName = self.personalInfoDic[@"LtName"];
        [self.navigationController pushViewController:storeVC animated:YES];
    }
    else if (indexPath.row == 8)
    {
        // 修改手机号
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

#pragma UIImagePickerController Delegate (相机和拍照)
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
//    http://www.lvtao.net/ios/509.html
    //http://blog.csdn.net/justinjing0612/article/details/8751269
//    http://www.swifthumb.com/thread-2555-1-1.html
//    http://www.cnblogs.com/skyblue/archive/2013/05/08/3067108.html
    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:@"public.image"])
    {
        // 如果是则从info字典参数中获取原图片
        UIImage *img = [info objectForKey:UIImagePickerControllerOriginalImage];
        //如果图片选取器的源类型为摄像头
        if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
            //将图片存入系统相册
            UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil);
        }
        NSData *imgData;
//        imgData = UIImagePNGRepresentation(img);
        imgData = UIImageJPEGRepresentation(img, 1.0f);
//        if (UIImagePNGRepresentation(img))
//        {
//            imgData = UIImagePNGRepresentation(img);
//        }
//        else
//        {
//            imgData = UIImageJPEGRepresentation(img, 1.0f);
//        }
        
//        [self saveImage:img];
        [self upLoadHead:imgData]; // 请求
    }
    else
    {
        NSLog(@"不是图片");
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil]; // 取消
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
//    [self saveImage:image];
    [self upLoadHead:UIImageJPEGRepresentation(image, 1.0f)];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil]; // 取消
}

//剪裁图片
- (UIImage *)scaleImage:(UIImage *)img ToSize:(CGSize)size
{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0,0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    //返回新的改变大小后的图片
    return scaledImage;
}

//保存和上传照片
-(void)saveImage:(UIImage *)image
{
    NSData *data=UIImagePNGRepresentation(image);
    
    NSString *docPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"headImg.plist"];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:data,@"imgData", nil];
    [dic writeToFile:docPath atomically:YES];
    
    //选择头像完成后上传头像
    [self upLoadHead:nil]; // 请求
}

- (void)upLoadHead:(NSData *)head
{
    NSString *url = [OutNetBaseURL stringByAppendingString:shangchuangtupian];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"TouXiang" forKey:@"lx"];
    [params setObject:head forKey:@"File"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css", @"text/plain", nil];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
    {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.png", str];

        [formData appendPartWithFileData:head name:@"headFile" fileName:fileName mimeType:@"image/png"];

    } success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        [operation start];
        [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite)
        {
            CGFloat progress = ((float)totalBytesWritten) / totalBytesExpectedToWrite;
            NSLog(@"%lf",progress);
        }];

        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"上传成功");
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"上传失败");
        }];

        NSString *mm=[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"upload = %@",mm);
        
        [self loginRequest:^(id result) {
            // 重新获取缓存数据
            self.personalInfoDic = result;
            [self.myTableView reloadData];
        }];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

    }];
}

// 返回button 事件
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // 发送通知，更新“我”界面信息
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateWoPage" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dfa
{
    
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
