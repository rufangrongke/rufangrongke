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
#import "CDPMonitorKeyboard.h"

@interface WXZPersonalStoreVC () <UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;

@property (weak, nonatomic) IBOutlet UIImageView *cardImgView; // 名片imgView
@property (weak, nonatomic) IBOutlet UIProgressView *uploadProgress; // 上传进度条
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
    
    self.storeNameTextField.text = self.storeName; // 赋值
    self.storeNameTextField.delegate = self; // 遵循协议
    
    self.myScrollView.contentSize = CGSizeMake(WXZ_ScreenWidth, 350); // 设置scrollView的contentSize
    
    [self initControl]; // 初始化progress
    
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

// 初始化控件
- (void)initControl
{
    self.uploadProgress.progress = 0;
    self.uploadProgress.progressTintColor = [UIColor blueColor];
    self.uploadProgress.trackTintColor = [UIColor grayColor];
}

// 选择名片单击事件
- (IBAction)uploadCard:(id)sender
{
    NSLog(@"上传名片");
    // 添加UIActionSheet
    UIActionSheet *photosSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册", nil];
    [photosSheet showInView:self.view];
}

// 提交审核按钮事件
- (IBAction)submitAuditAction:(id)sender
{
    NSLog(@"提交审核");
    NSData *imgData = [[NSUserDefaults standardUserDefaults] objectForKey:@"companyImg"]; // 获取缓存图片
    if (![WXZChectObject checkWhetherStringIsEmpty:self.storeNameTextField.text] && imgData != nil)
    {
        // 显示菊花
        [SVProgressHUD showWithStatus:@"正在提交..." maskType:SVProgressHUDMaskTypeBlack];
        [self modifyRequestWithParameter1:self.storeId parameter2:self.storeNameTextField.text parameter3:imgData]; // 绑定门店请求
    }
    else
    {
        NSLog(@"您还未选择图片");
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
        NSData *imgData = UIImagePNGRepresentation(img);
        // 缓存
        [[NSUserDefaults standardUserDefaults] setObject:imgData forKey:@"companyImg"];
        
        self.cardImgView.image = [UIImage imageWithData:imgData];
        self.cardImgView.layer.cornerRadius = 6;
        self.cardImgView.layer.masksToBounds = YES;
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

// 修改绑定门店请求和图片上传
- (void)modifyRequestWithParameter1:(NSString *)ltcid parameter2:(NSString *)ltname parameter3:(NSData *)picfile
{
    NSString *nameUrlStr = [OutNetBaseURL stringByAppendingString:jinjirengongsibagding];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:ltcid forKey:@"ltcid"]; // 公司编号
    [param setObject:ltname forKey:@"ltname"]; // 公司名称
    [param setObject:picfile forKey:@"picfile"]; // 公司图片
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css", @"text/plain", nil];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:nameUrlStr parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
        
        [formData appendPartWithFileData:picfile name:@"headFile" fileName:fileName mimeType:@"image/png"];
        
    } success:^(NSURLSessionDataTask *task, id responseObject)
     {
         WXZLog(@"%@",responseObject);
     } failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         
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
    //如果想不通输入view获得不同高度，可自己在此方法里分别判断区别
    [[CDPMonitorKeyboard defaultMonitorKeyboard] keyboardWillShowWithSuperView:self.view andNotification:aNotification higherThanKeyboard:10];
}

//当键退出时调用
-(void)keyboardWillHide:(NSNotification *)aNotification
{
    [[CDPMonitorKeyboard defaultMonitorKeyboard] keyboardWillHide];
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
