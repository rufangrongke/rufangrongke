//
//  WXZPersonalStoreVC.m
//  rufangrongke
//
//  Created by 儒房融科 on 15/10/26.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

#import "WXZPersonalStoreVC.h"
#import "AFNetworking.h"
#import <SVProgressHUD.h>
#import "WXZChectObject.h"

@interface WXZPersonalStoreVC () <UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;

@property (weak, nonatomic) IBOutlet UIImageView *cardImgView; // 名片imgView

@property (weak, nonatomic) IBOutlet UITextField *storeNameTextField; // 新门店输入框

@end

@implementation WXZPersonalStoreVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // 视图整体背景色
    self.view.backgroundColor = WXZRGBColor(246, 246, 246);
    // 添加标题，设置标题的颜色和字号
    self.navigationItem.title = @"修改绑定门店";
    
    self.storeNameTextField.delegate = self; // 遵循协议
    
    [self initControl]; // 初始化
    
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

// 初始化控件
- (void)initControl
{
    // 设置门店图片圆角
    self.cardImgView.layer.cornerRadius = 6;
    self.cardImgView.layer.masksToBounds = YES;
}

// 选择名片单击事件
- (IBAction)uploadCard:(id)sender
{
    [self.storeNameTextField resignFirstResponder];
    // 添加UIActionSheet
    UIActionSheet *photosSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册", nil];
    [photosSheet showInView:self.view];
}

// 提交审核按钮事件
- (IBAction)submitAuditAction:(id)sender
{
    [self.storeNameTextField resignFirstResponder];
    NSData *imgData = [[NSUserDefaults standardUserDefaults] objectForKey:@"companyImg"]; // 获取缓存图片
    if (imgData == nil)
    {
        [SVProgressHUD showErrorWithStatus:@"请选择门店图片"];
    }
    else if (![WXZChectObject checkWhetherStringIsEmpty:self.storeNameTextField.text withTipInfo:@"请输入门店名"] && imgData != nil)
    {
        // 显示菊花
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
        [self modifyRequestWithParameter1:self.storeId parameter2:self.storeNameTextField.text parameter3:imgData]; // 绑定门店请求
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
                [SVProgressHUD showErrorWithStatus:@"摄像头不可用"];
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
                [SVProgressHUD showErrorWithStatus:@"相簿不可用"];
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
        // 如果是则从info字典参数中获取裁剪后的图片
        UIImage *img = [info objectForKey:UIImagePickerControllerEditedImage];
        //如果图片选取器的源类型为摄像头
        if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
            //将图片存入系统相册
            UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil);
        }
        NSData *imgData = UIImageJPEGRepresentation(img, 0.4f);
        // 缓存
        [[NSUserDefaults standardUserDefaults] setObject:imgData forKey:@"companyImg"];
        
        self.cardImgView.image = [UIImage imageWithData:imgData];
    }
    else
    {
        NSLog(@"不是图片");
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil]; // 取消相册页面
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil]; // 取消相册页面
}

#pragma mark - 修改绑定门店请求和图片上传
- (void)modifyRequestWithParameter1:(NSString *)ltcid parameter2:(NSString *)ltname parameter3:(NSData *)picfile
{
    NSString *nameUrlStr = [OutNetBaseURL stringByAppendingString:jinjirengongsibagding]; // 请求url
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:ltcid forKey:@"ltcid"]; // 公司编号
    [param setObject:ltname forKey:@"ltname"]; // 公司名称
    [param setObject:picfile forKey:@"picfile"]; // 公司图片
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager POST:nameUrlStr parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
    {
        NSString *fileName = [NSString stringWithFormat:@"%@.png", @"modifyStore"];
        
        [formData appendPartWithFileData:picfile name:@"headFile" fileName:fileName mimeType:@"image/png"];
        
    } success:^(NSURLSessionDataTask *task, id responseObject)
     {
         if ([responseObject[@"ok"] integerValue] == 1)
         {
//             [SVProgressHUD showSuccessWithStatus:responseObject[@"msg"] maskType:SVProgressHUDMaskTypeBlack];
             // 发送通知，更新个人资料页面
             [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdatePersonalDataPage" object:responseObject[@"msg"]];
             [self.navigationController popViewControllerAnimated:YES]; // 修改成功返回上一页面
         }
         else
         {
             [SVProgressHUD showErrorWithStatus:responseObject[@"msg"] maskType:SVProgressHUDMaskTypeBlack];
             // 判断是否为登陆超时，登录超时则返回登录页面重新登录
             if ([responseObject[@"msg"] isEqualToString:@"登陆超时"])
             {
                 [self goBackLoginPage]; // 回到登录页面
             }
         }
         
     } failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         [SVProgressHUD showErrorWithStatus:@"请求失败" maskType:SVProgressHUDMaskTypeBlack];
     }];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark 键盘监听方法设置
//当键盘出现时调用
-(void)keyboardWillShow:(NSNotification *)aNotification
{
    self.view.frame = CGRectMake(0, -40, WXZ_ScreenWidth, WXZ_ScreenHeight);
}

//当键退出时调用
-(void)keyboardWillHide:(NSNotification *)aNotification
{
    self.view.frame = CGRectMake(0, 64, WXZ_ScreenWidth, WXZ_ScreenHeight);
}

// 取消第一响应
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.storeNameTextField resignFirstResponder];
}

// dealloc中需要移除监听
-(void)dealloc{
    //移除监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    
    //移除监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"companyImg"]; // 清除缓存
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
