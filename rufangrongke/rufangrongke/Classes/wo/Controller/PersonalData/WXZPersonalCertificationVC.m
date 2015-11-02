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
    
    self.nameTextField.delegate = self;
    self.idCardTextField.delegate = self;
    
    [self initControl]; // 初始化progress
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"wo_complete" highImage:@"" target:self action:@selector(completeAction:)];
    // 已认证则不显示按钮，所有东西不可修改
    if (![self.isCertification isEqualToString:@"True"])
    {
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"" highImage:@"" target:self action:@selector(completeAction:)];
        
        self.nameTextField.enabled = NO;
        self.idCardTextField.enabled = NO;
        self.selectImgTap.enabled = NO;
    }
}

- (void)initControl
{
    self.uploadProgress.progress = 0;
    self.uploadProgress.progressTintColor = [UIColor blueColor];
    self.uploadProgress.trackTintColor = [UIColor grayColor];
}

- (IBAction)idCardAction:(id)sender
{
    NSLog(@"身份证照");
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
    
    // http://www.itstrike.cn/Question/11b43d03-1586-410c-87d9-30c0fdf94cdd.html
    // 1. Create `AFHTTPRequestSerializer` which will create your request
    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    // 2. Create an `NSMutableURLRequest`
    NSMutableURLRequest *request = [serializer multipartFormRequestWithMethod:@"POST" URLString:requestUrlStr parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
    {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
        
        [formData appendPartWithFileData:sfzPic name:@"headFile" fileName:fileName mimeType:@"image/png"];
        
    } error:nil];
    // 3. Create and use `AFHTTPRequestOperationManager` to create an `AFHTTPRequestOperation` from the `NSMutableURLRequest` that we just created
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSLog(@"Success %@", responseObject);
        [SVProgressHUD showErrorWithStatus:responseObject[@"msg"]];
        [SVProgressHUD dismiss]; // 取消菊花
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        NSLog(@"Failure %@", error.description);
        [SVProgressHUD showErrorWithStatus:@"请求失败"];
        [SVProgressHUD dismiss]; // 取消菊花
    }];
    
    // 4. Set the progress block of the operation
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite)
    {
        NSLog(@"Wrote %lld/%lld", totalBytesWritten, totalBytesExpectedToWrite);
        // 设置上传进度
        self.uploadProgress.progress = totalBytesWritten / totalBytesExpectedToWrite;
    }];
    
    // 5. 开始（Begin）
    [operation start];
}

- (void)completeAction:(id)sender
{
    NSLog(@"完成");
    NSData *imgData = [[NSUserDefaults standardUserDefaults] objectForKey:@"sfzimg"];
    if (![WXZChectObject checkWhetherStringIsEmpty:self.nameTextField.text] && ![WXZChectObject isBeyondTheScopeOf:4 string:self.nameTextField.text] && ![WXZChectObject checkWhetherStringIsEmpty:self.idCardTextField.text] && imgData != nil)
    {
        // 显示菊花
        [SVProgressHUD showWithStatus:@"请稍后..." maskType:SVProgressHUDMaskTypeBlack];
        [self modifyRequestWithParameter1:self.nameTextField.text parameter2:self.idCardTextField.text parameter3:imgData]; // 请求
    }
    else
    {
        
    }
}

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
