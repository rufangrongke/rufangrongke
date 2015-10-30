//
//  WXZPersonalStoreVC.m
//  rufangrongke
//
//  Created by 儒房融科 on 15/10/26.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

#import "WXZPersonalStoreVC.h"
#import "AFNetworking.h"

@interface WXZPersonalStoreVC () <UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

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
        //        [self upLoadHead:imgData]; // 请求
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

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    //    [self saveImage:image];
    //    [self upLoadHead:UIImageJPEGRepresentation(image, 1.0f)];
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
    //    [self upLoadHead:nil]; // 请求
}

// 修改手机号请求
- (void)modifyRequestWithParameter1:(NSString *)ltcid parameter2:(NSString *)ltname parameter3:(NSString *)picfile
{
    NSString *nameUrlStr = [OutNetBaseURL stringByAppendingString:jinjirengongsibagding];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:ltcid forKey:@"ltcid"]; // 公司编号
    [param setObject:ltname forKey:@"ltname"]; // 公司名称
    [param setObject:picfile forKey:@"picfile"]; // 公司图片
    
    [[AFHTTPSessionManager manager] POST:nameUrlStr parameters:param success:^(NSURLSessionDataTask *task, id responseObject)
     {
         if ([responseObject[@"ok"] integerValue] == 1)
         {
             NSLog(@"%@",responseObject[@"msg"]);
             // 发送通知
             [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdatePersonalDataPage" object:nil];
             [self.navigationController popViewControllerAnimated:YES]; // 修改成功返回上一页面
         }
         else
         {
             NSLog(@"%@",responseObject[@"msg"]);
         }
         
     } failure:^(NSURLSessionDataTask *task, NSError *error) {
         
     }];
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
