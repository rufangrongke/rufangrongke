//
//  WXZPersonalCertificationVC.m
//  rufangrongke
//
//  Created by 儒房融科 on 15/10/26.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

#import "WXZPersonalCertificationVC.h"
#import "AFNetworking.h"
#import <UIImageView+WebCache.h>
#import <SVProgressHUD.h>
#import "WXZChectObject.h"
#import "CDPMonitorKeyboard.h"

@interface WXZPersonalCertificationVC () <UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;

@property (weak, nonatomic) IBOutlet UITextField *nameTextField; // 姓名
@property (weak, nonatomic) IBOutlet UITextField *idCardTextField; // 身份证号
@property (weak, nonatomic) IBOutlet UIImageView *idCardImgView; // 身份证正面图片
@property (weak, nonatomic) IBOutlet UIProgressView *uploadProgress; // 上传进度

@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *selectImgTap; // 手势

@end

@implementation WXZPersonalCertificationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // 视图整体背景色
    self.view.backgroundColor = WXZRGBColor(246, 246, 246);
    // 添加标题，设置标题的颜色和字号
    self.navigationItem.title = @"实名认证";
    
    self.myScrollView.contentSize = CGSizeMake(WXZ_ScreenWidth, 300);
    
    // 赋值
    self.nameTextField.text = self.idCardName;
    self.idCardTextField.text = self.idCardId;
    NSString *imgUrlStr = [OutNetBaseURL stringByAppendingString:self.idCardImg];
    [self.idCardImgView sd_setImageWithURL:[NSURL URLWithString:imgUrlStr] placeholderImage:[UIImage imageNamed:@"wo_personal_idcard"]];
    
    // 设置代理
    self.nameTextField.delegate = self;
    self.idCardTextField.delegate = self;
    
    [self initControl]; // 初始化progress
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 导航栏右侧按钮
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"wo_complete" highImage:@"" target:self action:@selector(completeAction:)];
    // 已认证则不显示按钮，所有东西不可修改
    if ([self.isCertification isEqualToString:@"True"])
    {
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"" highImage:@"" target:self action:@selector(completeAction:)];
        
        self.nameTextField.enabled = NO;
        self.idCardTextField.enabled = NO;
        self.selectImgTap.enabled = NO;
    }
}

// 初始化控件
- (void)initControl
{
    // UIProgress 的相关设置
    self.uploadProgress.progress = 0;
    self.uploadProgress.progressTintColor = [UIColor blueColor];
    self.uploadProgress.trackTintColor = [UIColor grayColor];
}

// 添加身份证正面照的按钮事件
- (IBAction)idCardAction:(id)sender
{
    NSLog(@"身份证照");
    // 添加UIActionSheet
    UIActionSheet *photosSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册", nil];
    [photosSheet showInView:self.view];
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
        [[NSUserDefaults standardUserDefaults] setObject:imgData forKey:@"sfzimg"];
        
        // 设置图片圆角
        self.idCardImgView.image = [UIImage imageWithData:imgData];
        self.idCardImgView.layer.cornerRadius = 6;
        self.idCardImgView.layer.masksToBounds = YES;
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

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.tag == 100015)
    {
        // 身份证号字数限制
        NSInteger sum = 18;
        if (range.location >= sum)
        {
            return NO;
        }
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

// 实名认证请求和图片上传
- (void)modifyRequestWithParameter1:(NSString *)truename parameter2:(NSString *)sfzid parameter3:(NSData *)sfzPic
{
    NSString *requestUrlStr = [OutNetBaseURL stringByAppendingString:jingjirenshimingrenzheng];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:truename forKey:@"truename"]; // 真实姓名
    [param setObject:sfzid forKey:@"sfzid"]; // 身份证号码
    [param setObject:sfzPic forKey:@"sfzPic"]; // 身份证图片
    
    /*
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:requestUrlStr parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
    {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
        
        [formData appendPartWithFileData:sfzPic name:@"headFile" fileName:fileName mimeType:@"image/png"];
        
    } error:nil];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSProgress *progress = nil;
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request progress:&progress completionHandler:^(NSURLResponse *response, id responseObject, NSError *error)
    {
        if (error)
        {
            NSLog(@"Error: %@", error);
        } else
        {
            NSLog(@"\n response = %@  \n responseObject = %@", response, responseObject);
            
//
//            response = <NSHTTPURLResponse: 0x7fe52841c040> { URL: http://192.168.1.21:34/Svs/UsRz.ashx } { status code: 200, headers {
//                Server : Microsoft-IIS/8.5,
//                Content-Type : application/json; charset=utf-8,
//                X-Powered-By : ASP.NET,
//                Date : Mon, 02 Nov 2015 12:17:45 GMT,
//                Content-Length : 33,
//                Cache-Control : private,
//                X-AspNet-Version : 4.0.30319
//            } }  
//            responseObject = {
//                msg : 提交失败,
//                ok : 0
//            }
        }
    }];
    
    [uploadTask resume]; */
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [manager POST:requestUrlStr parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
        
        [formData appendPartWithFileData:sfzPic name:@"headFile" fileName:fileName mimeType:@"image/png"];
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
    // 上传
    [manager setTaskDidSendBodyDataBlock:^(NSURLSession *session, NSURLSessionTask *task, int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend)
    {
        // bytesSent本次上传了多少字节,totalBytesSent累计上传了多少字节,totalBytesExpectedToSend文件有多大,应该上传多少
        NSLog(@"task %@ progress is %f ", task, totalBytesSent*1.0/totalBytesExpectedToSend);
        
        // 设置当前进度值
        CGFloat uploadProportion = totalBytesSent*1.0 / totalBytesExpectedToSend;
        self.uploadProgress.progress = uploadProportion;
    }];
}

- (void)completeAction:(id)sender
{
    NSLog(@"完成");
    NSData *imgData = [[NSUserDefaults standardUserDefaults] objectForKey:@"sfzimg"];
    if (![WXZChectObject checkWhetherStringIsEmpty:self.nameTextField.text] && ![WXZChectObject isBeyondTheScopeOf:4 string:self.nameTextField.text] && ![WXZChectObject checkWhetherStringIsEmpty:self.idCardTextField.text] && imgData != nil)
    {
        // 显示菊花
//        [SVProgressHUD showWithStatus:@"请稍后..." maskType:SVProgressHUDMaskTypeBlack];
        [self modifyRequestWithParameter1:self.nameTextField.text parameter2:self.idCardTextField.text parameter3:imgData]; // 请求
    }
    else
    {
        
    }
}

// 取消第一响应
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.nameTextField resignFirstResponder];
    [self.idCardTextField resignFirstResponder];
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
