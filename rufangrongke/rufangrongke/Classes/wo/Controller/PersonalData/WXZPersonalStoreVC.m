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

@interface WXZPersonalStoreVC () <UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;

@property (weak, nonatomic) IBOutlet UIImageView *cardImgView;
@property (weak, nonatomic) IBOutlet UIProgressView *uploadProgress;
@property (weak, nonatomic) IBOutlet UITextField *storeNameTextField;

@end

@implementation WXZPersonalStoreVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // 视图整体背景色
    self.view.backgroundColor = WXZRGBColor(246, 246, 246);
    // 添加标题，设置标题的颜色和字号
    self.navigationItem.title = @"修改绑定门店";
    
    self.storeNameTextField.text = self.storeName;
    
    self.myScrollView.contentSize = CGSizeMake(WXZ_ScreenWidth, 350);
    
    [self initControl]; // 初始化progress
}

- (void)initControl
{
    self.uploadProgress.progress = 0;
    self.uploadProgress.progressTintColor = [UIColor blueColor];
    self.uploadProgress.trackTintColor = [UIColor grayColor];
}

- (IBAction)uploadCard:(id)sender
{
    NSLog(@"上传名片");
    UIActionSheet *photosSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册", nil];
    [photosSheet showInView:self.view];
}

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
    
    // 1. Create `AFHTTPRequestSerializer` which will create your request
    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    // 2. Create an `NSMutableURLRequest`
    NSMutableURLRequest *request = [serializer multipartFormRequestWithMethod:@"POST" URLString:nameUrlStr parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
    {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
        
        [formData appendPartWithFileData:picfile name:@"headFile" fileName:fileName mimeType:@"image/png"];
        
    } error:nil];
    // 3. Create and use `AFHTTPRequestOperationManager` to create an `AFHTTPRequestOperation` from the `NSMutableURLRequest` that we just created
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    AFHTTPRequestOperation *opration = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject)
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
    [opration setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite)
    {
        NSLog(@"Wrote %lld/%lld", totalBytesWritten, totalBytesExpectedToWrite);
        // 设置上传进度
        self.uploadProgress.progress = totalBytesWritten / totalBytesExpectedToWrite;
    }];
    // 5. Begin
    [opration start];
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
