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
    
    // 赋值（上个页面传过来的值有内容，则先显示原来的值）
    self.nameTextField.text = self.woInfoModel.TrueName; // 姓名
    self.idCardTextField.text = self.woInfoModel.sfzid; // 身份证id
    NSString *imgUrlStr = [picBaseULR stringByAppendingFormat:@"%@",self.woInfoModel.sfzPic];
    [self.idCardImgView sd_setImageWithURL:[NSURL URLWithString:imgUrlStr] placeholderImage:[UIImage imageNamed:@"wo_personal_idcard"]]; // 身份证照片
    
    // 设置代理
    self.nameTextField.delegate = self;
    self.idCardTextField.delegate = self;
    
    [self initControl]; // 初始化
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 导航栏右侧按钮
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage2:@"wo_complete" highImage:@"hehe.png" title:@"" target:self action:@selector(completeAction:) isEnable:YES];
    
    // 已认证则不显示按钮，所有东西不可修改；有身份证号但是为False，则为审核中
    if ([self.woInfoModel.IsShiMing isEqualToString:@"True"])
    {
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage2:@"hehe.png" highImage:@"hehe.png" title:@"" target:self action:@selector(completeAction:) isEnable:NO];
        
        self.nameTextField.enabled = NO;
        self.idCardTextField.enabled = NO;
        self.selectImgTap.enabled = NO;
    }
//    else if ([self.woInfoModel.IsShiMing isEqualToString:@"False"] && ![WXZChectObject checkWhetherStringIsEmpty:self.woInfoModel.sfzid])
//    {
//        self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage2:@"hehe.png" highImage:@"hehe.png" title:@"审核中" target:self action:@selector(completeAction:) isEnable:NO];
//        
//        self.nameTextField.enabled = NO;
//        self.idCardTextField.enabled = NO;
//        self.selectImgTap.enabled = NO;
//    }
}

// 初始化控件
- (void)initControl
{
    // 设置图片圆角
    self.idCardImgView.layer.cornerRadius = 6;
    self.idCardImgView.layer.masksToBounds = YES;
}

// 添加身份证正面照的按钮事件
- (IBAction)idCardAction:(id)sender
{
    [self.nameTextField resignFirstResponder];
    [self.idCardTextField resignFirstResponder];
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
        // 存入缓存
        [[NSUserDefaults standardUserDefaults] setObject:imgData forKey:@"sfzimg"];
        
        // 设置图片
        self.idCardImgView.image = [UIImage imageWithData:imgData];
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

#pragma mark - 实名认证请求和图片上传 Request
- (void)modifyRequestWithParameter1:(NSString *)truename parameter2:(NSString *)sfzid parameter3:(NSData *)sfzPic
{
    NSString *requestUrlStr = [OutNetBaseURL stringByAppendingString:jingjirenshimingrenzheng]; // 请求url
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:truename forKey:@"truename"]; // 真实姓名
    [param setObject:sfzid forKey:@"sfzid"]; // 身份证号码
    [param setObject:sfzPic forKey:@"sfzPic"]; // 身份证图片
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:requestUrlStr parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
    {
        // 文件名（随便起，后缀和图片的一样）
        NSString *fileName = [NSString stringWithFormat:@"%@.png", @"certification"];
        
        [formData appendPartWithFileData:sfzPic name:@"headFile" fileName:fileName mimeType:@"image/png"];
        
    } success:^(NSURLSessionDataTask *task, id responseObject)
    {        
        if ([responseObject[@"ok"] integerValue] == 1)
        {
//            [SVProgressHUD showSuccessWithStatus:responseObject[@"msg"] maskType:SVProgressHUDMaskTypeBlack];
            // 发送通知，更新个人资料页面
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdatePersonalDataPage" object:responseObject[@"msg"]];
            [self.navigationController popViewControllerAnimated:YES]; // 修改成功返回上一页面
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:responseObject[@"msg"] maskType:SVProgressHUDMaskTypeBlack];
            // 判断是否为登陆超时，登录超时则返回登录页面重新登录
            if ([responseObject[@"msg"] isEqualToString:@"登录超时"] || [responseObject[@"msg"] isEqualToString:@"登陆超时"])
            {
                [self goBackLoginPage]; // 回到登录页面
            }
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error)
    {
        [SVProgressHUD showErrorWithStatus:@"请求失败" maskType:SVProgressHUDMaskTypeBlack];
    }];
}

// 确定按钮点击事件
- (void)completeAction:(id)sender
{
    [self.nameTextField resignFirstResponder];
    [self.idCardTextField resignFirstResponder];
    // 缓存中获取图片
    NSData *imgData = [[NSUserDefaults standardUserDefaults] objectForKey:@"sfzimg"];
    // 判断传的内容是否符合规范
    if (![WXZChectObject checkWhetherStringIsEmpty:self.nameTextField.text withTipInfo:@"姓名不能为空"] && ![WXZChectObject isBeyondTheScopeOf:4 string:self.nameTextField.text withTipInfo:@"请输入4个字内的姓名"] && [WXZChectObject checkIdCard:self.idCardTextField.text] && imgData != nil)
    {
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack]; // 显示菊花
        [self modifyRequestWithParameter1:self.nameTextField.text parameter2:self.idCardTextField.text parameter3:imgData]; // 实名认证数据请求
    }
    else if (imgData == nil)
    {
        [SVProgressHUD showErrorWithStatus:@"请选择身份证正面照"];
    }
}

// 取消第一响应
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.nameTextField resignFirstResponder];
    [self.idCardTextField resignFirstResponder];
}

- (void)dealloc
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"sfzimg"]; // 清除缓存
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
